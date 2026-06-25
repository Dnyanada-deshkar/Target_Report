using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace Target_Report
{
    public partial class MonthlySnapshotReport : System.Web.UI.Page
    {
        // ViewState keys
        private const string VS_SORT_EXPR = "SortExpression";
        private const string VS_SORT_DIR = "SortDirection";
        private const string VS_CURRENT_PAGE = "CurrentPage";

        private static readonly string[] MonthNames =
        {
            "", "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };

        private string ConnString => ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState[VS_SORT_EXPR] = "PartnerName";
                ViewState[VS_SORT_DIR] = "ASC";
                ViewState[VS_CURRENT_PAGE] = 1;

                BindMonths();
                BindYears();
                BindPartners();

                // Default the filter to the most recently completed month,
                // since that is the most likely snapshot a user opens this
                // report to look at.
                DateTime defaultMonth = DateTime.Now.AddMonths(-1);
                ddlMonth.SelectedValue = defaultMonth.Month.ToString();
                ddlYear.SelectedValue = defaultMonth.Year.ToString();

                LoadReport();
            }
        }

        // =====================================================
        // DROPDOWN BINDING METHODS
        // =====================================================

        private void BindMonths()
        {
            // Month list items are declared statically in the markup
            // (January .. December), so no data binding is required here.
            // Method retained per the requested code-behind structure and
            // as the natural place to extend month logic later (e.g.
            // restricting to months with closed snapshots only).
        }

        private void BindYears()
        {
            ddlYear.Items.Clear();
            ddlYear.Items.Add(new ListItem("Select year", ""));

            int currentYear = DateTime.Now.Year;
            for (int year = currentYear - 5; year <= currentYear + 5; year++)
            {
                ddlYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
            }
        }

        private void BindPartners()
        {
            DataTable partners = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT PartnerID, PartnerName FROM WardhaApp.PartnerMaster ORDER BY PartnerName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(partners);
                }
            }

            ddlPartner.DataSource = partners;
            ddlPartner.DataTextField = "PartnerName";
            ddlPartner.DataValueField = "PartnerID";
            ddlPartner.DataBind();
            ddlPartner.Items.Insert(0, new ListItem("All Partners", ""));
        }

        // =====================================================
        // PAGE EVENTS
        // =====================================================

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            ViewState[VS_CURRENT_PAGE] = 1;
            LoadReport();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMonth.SelectedValue) ||
                string.IsNullOrEmpty(ddlYear.SelectedValue))
            {
                ShowToast("Cannot export",
                          "Please select a month and year before exporting.",
                          "warning");
                return;
            }

            DataTable exportData = GetSnapshotData(false);

            if (exportData.Rows.Count == 0)
            {
                ShowToast("Nothing to export",
                          "There is no data for the selected filters.",
                          "warning");
                return;
            }

            ExportToExcel(exportData);
        }

        // =====================================================
        // REPORT LOADING — grid + KPI cards
        // =====================================================

        /// <summary>
        /// Loads the grid for the current filter/sort/page state and
        /// refreshes the KPI summary cards from the same filtered result
        /// set (unpaged), so the cards always reflect the full filtered
        /// total rather than just the rows visible on the current page.
        /// </summary>
        private void LoadReport()
        {
            if (string.IsNullOrEmpty(ddlMonth.SelectedValue) || string.IsNullOrEmpty(ddlYear.SelectedValue))
            {
                gvSnapshot.DataSource = null;
                gvSnapshot.DataBind();
                litResultCount.Text = "0 records";
                LoadSummaryCards(new DataTable());
                return;
            }

            DataTable fullResult = GetSnapshotData(applyPaging: false);
            LoadSummaryCards(fullResult);

            DataTable pagedResult = ApplySortAndPaging(fullResult);

            gvSnapshot.DataSource = pagedResult;
            gvSnapshot.DataBind();

            litResultCount.Text = fullResult.Rows.Count == 1 ? "1 record" : $"{fullResult.Rows.Count} records";

            BindPaginationControls(fullResult.Rows.Count);
        }

        /// <summary>
        /// Calls WardhaApp.usp_MonthlySnapshotReport with the current
        /// filter selections. Returns the full result set; paging, when
        /// requested by the caller, is applied afterward in-memory via
        /// ApplySortAndPaging, since the stored procedure itself returns
        /// the complete filtered set for a given month (snapshot reports
        /// are bounded by partner count, not by daily transaction volume,
        /// so in-memory paging here is appropriate).
        /// </summary>
        private DataTable GetSnapshotData(bool applyPaging)
        {
            DataTable result = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("WardhaApp.usp_MonthlySnapshotReport", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TargetMonth", Convert.ToInt32(ddlMonth.SelectedValue));
                cmd.Parameters.AddWithValue("@TargetYear", Convert.ToInt32(ddlYear.SelectedValue));
                cmd.Parameters.AddWithValue("@PartnerID", string.IsNullOrEmpty(ddlPartner.SelectedValue) ? (object)DBNull.Value : Convert.ToInt32(ddlPartner.SelectedValue));
                cmd.Parameters.AddWithValue("@Branch", string.IsNullOrEmpty(ddlBranch.SelectedValue) ? (object)DBNull.Value : ddlBranch.SelectedValue);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(result);
                }
            }

            return result;
        }

        /// <summary>
        /// Computes the four KPI summary values from the full filtered
        /// result set (not just the current page). Handles an empty
        /// result set and null/zero target without throwing — division
        /// by zero is guarded explicitly per the validation requirement
        /// that the report never raises a runtime exception regardless
        /// of the data shape it receives.
        /// </summary>
        private void LoadSummaryCards(DataTable data)
        {
            decimal totalTarget = 0;
            decimal totalAchievement = 0;
            decimal totalBalance = 0;

            foreach (DataRow row in data.Rows)
            {
                totalTarget += row["SalesTarget"] != DBNull.Value ? Convert.ToDecimal(row["SalesTarget"]) : 0;
                totalAchievement += row["Achievement"] != DBNull.Value ? Convert.ToDecimal(row["Achievement"]) : 0;
                totalBalance += row["Balance"] != DBNull.Value ? Convert.ToDecimal(row["Balance"]) : 0;
            }

            decimal achievementPercentage = totalTarget > 0
                ? Math.Round((totalAchievement / totalTarget) * 100, 2)
                : 0;

            lblTotalTarget.Text = FormatCurrency(totalTarget);
            lblTotalAchievement.Text = FormatCurrency(totalAchievement);
            lblTotalBalance.Text = FormatCurrency(totalBalance);
            lblAchievementPercentage.Text = achievementPercentage.ToString("N2", CultureInfo.InvariantCulture) + "%";
        }

        private string FormatCurrency(decimal value)
        {
            // Indian numbering convention (lakhs/crores grouping) formatted
            // explicitly via the en-IN culture so values render as
            // ₹ 1,20,000.00 rather than the Western ₹120,000.00 grouping.
            CultureInfo inCulture = CultureInfo.GetCultureInfo("en-IN");
            return "₹ " + value.ToString("N2", inCulture);
        }

        /// <summary>
        /// Called from the inline data-binding expression in
        /// MonthlySnapshotReport.aspx (GetAchievementPctClass) — must
        /// remain protected, since ItemTemplate expressions compile
        /// against the page's public/protected surface, not its private
        /// members.
        /// </summary>
        protected string GetAchievementPctClass(decimal achievementPercentage)
        {
            if (achievementPercentage >= 80) return "is-high";
            if (achievementPercentage >= 50) return "is-medium";
            return "is-low";
        }

        // =====================================================
        // IN-MEMORY SORT + PAGE
        // (the stored procedure returns the full filtered set for
        // the selected month; sorting/paging for display is applied
        // here so the KPI cards above can use the same unpaged
        // result without a second round trip to the database)
        // =====================================================

        private DataTable ApplySortAndPaging(DataTable source)
        {
            string sortExpr = ViewState[VS_SORT_EXPR] as string ?? "PartnerName";
            string sortDir = ViewState[VS_SORT_DIR] as string ?? "ASC";
            int currentPage = ViewState[VS_CURRENT_PAGE] != null ? (int)ViewState[VS_CURRENT_PAGE] : 1;
            int pageSize = int.Parse(ddlPageSize.SelectedValue);

            DataView view = new DataView(source);

            if (source.Columns.Contains(sortExpr))
            {
                view.Sort = $"{sortExpr} {(sortDir == "DESC" ? "DESC" : "ASC")}";
            }

            DataTable sorted = view.ToTable();

            int totalPages = (int)Math.Ceiling(sorted.Rows.Count / (double)pageSize);
            if (totalPages == 0) totalPages = 1;

            if (currentPage > totalPages)
            {
                currentPage = totalPages;
                ViewState[VS_CURRENT_PAGE] = currentPage;
            }

            DataTable paged = sorted.Clone();
            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.Min(startIndex + pageSize, sorted.Rows.Count);

            for (int i = startIndex; i < endIndex; i++)
            {
                paged.ImportRow(sorted.Rows[i]);
            }

            return paged;
        }

        private void BindPaginationControls(int totalRecordCount)
        {
            int pageSize = int.Parse(ddlPageSize.SelectedValue);
            int currentPage = ViewState[VS_CURRENT_PAGE] != null ? (int)ViewState[VS_CURRENT_PAGE] : 1;
            int totalPages = (int)Math.Ceiling(totalRecordCount / (double)pageSize);
            if (totalPages == 0) totalPages = 1;

            lnkFirst.Enabled = currentPage > 1;
            lnkPrev.Enabled = currentPage > 1;
            lnkNext.Enabled = currentPage < totalPages;
            lnkLast.Enabled = currentPage < totalPages;

            int windowStart = Math.Max(1, currentPage - 2);
            int windowEnd = Math.Min(totalPages, windowStart + 4);
            windowStart = Math.Max(1, windowEnd - 4);

            var pageItems = new List<PageNumberItem>();
            for (int i = windowStart; i <= windowEnd; i++)
            {
                pageItems.Add(new PageNumberItem { PageNumber = i, CurrentPage = currentPage });
            }

            rptPageNumbers.DataSource = pageItems;
            rptPageNumbers.DataBind();
        }

        private class PageNumberItem
        {
            public int PageNumber { get; set; }
            public int CurrentPage { get; set; }
        }

        // =====================================================
        // SORT / PAGE EVENT HANDLERS
        // =====================================================

        protected void gvSnapshot_Sorting(object sender, GridViewSortEventArgs e)
        {
            string currentSortExpr = ViewState[VS_SORT_EXPR] as string;
            string currentSortDir = ViewState[VS_SORT_DIR] as string;

            if (currentSortExpr == e.SortExpression)
            {
                ViewState[VS_SORT_DIR] = currentSortDir == "ASC" ? "DESC" : "ASC";
            }
            else
            {
                ViewState[VS_SORT_EXPR] = e.SortExpression;
                ViewState[VS_SORT_DIR] = "ASC";
            }

            LoadReport();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            LoadReport();
        }

        protected void lnkFirst_Click(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            LoadReport();
        }

        protected void lnkPrev_Click(object sender, EventArgs e)
        {
            int current = (int)ViewState[VS_CURRENT_PAGE];
            ViewState[VS_CURRENT_PAGE] = Math.Max(1, current - 1);
            LoadReport();
        }

        protected void lnkNext_Click(object sender, EventArgs e)
        {
            int current = (int)ViewState[VS_CURRENT_PAGE];
            ViewState[VS_CURRENT_PAGE] = current + 1;
            LoadReport();
        }

        protected void lnkLast_Click(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = int.MaxValue;
            LoadReport();
        }

        protected void rptPageNumbers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "GoToPage")
            {
                ViewState[VS_CURRENT_PAGE] = Convert.ToInt32(e.CommandArgument);
                LoadReport();
            }
        }

        // =====================================================
        // EXPORT TO EXCEL
        // Generates a real OOXML (.xlsx) workbook by hand —
        // no external package dependency. The format is the
        // minimal valid SpreadsheetML structure: a single
        // worksheet inside a zip container with the required
        // [Content_Types].xml, _rels, and workbook parts.
        // =====================================================

        private void ExportToExcel(DataTable data)
        {
            string fileName =
                "MonthlySnapshotReport_" +
                DateTime.Now.ToString("yyyyMMdd") +
                ".xlsx";

            string[] headers =
            {
        "Partner Name",
        "Branch",
        "Sales Target",
        "Achievement",
        "Balance",
        "Achievement %",
        "Closed Date"
    };

            List<string[]> rows = new List<string[]>();

            foreach (DataRow row in data.Rows)
            {
                rows.Add(new[]
                {
            row["PartnerName"].ToString(),
            row["NativeBranch"].ToString(),
            row["SalesTarget"].ToString(),
            row["Achievement"].ToString(),
            row["Balance"].ToString(),
            row["AchievementPercentage"].ToString(),
            row["ClosedDate"].ToString()
        });
            }

            byte[] fileBytes = BuildXlsxWorkbook(headers, rows);

            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();

            Response.Buffer = true;

            Response.ContentType =
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            Response.AddHeader(
                "Content-Disposition",
                "attachment; filename=" + fileName);

            Response.BinaryWrite(fileBytes);

            Response.Flush();

            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        /// <summary>
        /// Builds a minimal valid .xlsx file (OOXML SpreadsheetML inside
        /// a zip container) entirely from raw bytes, with no dependency
        /// on a third-party Excel library. All cells are written as
        /// inline strings ("t=\"inlineStr\"") so no shared-strings table
        /// is required, keeping the structure as small as possible while
        /// remaining fully spec-compliant and openable in Excel.
        /// </summary>
        private byte[] BuildXlsxWorkbook(string[] headers, List<string[]> rows)
        {
            string sheetXml = BuildSheetXml(headers, rows);

            using (MemoryStream zipStream = new MemoryStream())
            {
                using (ZipArchive archive = new ZipArchive(zipStream, ZipArchiveMode.Create, true))
                {
                    AddZipEntry(archive, "[Content_Types].xml", ContentTypesXml);
                    AddZipEntry(archive, "_rels/.rels", RootRelsXml);
                    AddZipEntry(archive, "xl/workbook.xml", WorkbookXml);
                    AddZipEntry(archive, "xl/_rels/workbook.xml.rels", WorkbookRelsXml);
                    AddZipEntry(archive, "xl/styles.xml", StylesXml);
                    AddZipEntry(archive, "xl/worksheets/sheet1.xml", sheetXml);
                }

                return zipStream.ToArray();
            }
        }

        private void AddZipEntry(ZipArchive archive, string entryPath, string content)
        {
            ZipArchiveEntry entry = archive.CreateEntry(entryPath, CompressionLevel.Optimal);
            using (StreamWriter writer = new StreamWriter(entry.Open(), new UTF8Encoding(false)))
            {
                writer.Write(content);
            }
        }

        private string BuildSheetXml(string[] headers, List<string[]> rows)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
            sb.Append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
            sb.Append("<sheetData>");

            // Header row (bold style index 1, defined in styles.xml)
            sb.Append("<row r=\"1\">");
            for (int col = 0; col < headers.Length; col++)
            {
                string cellRef = GetColumnLetter(col) + "1";
                sb.Append($"<c r=\"{cellRef}\" s=\"1\" t=\"inlineStr\"><is><t>{XmlEscape(headers[col])}</t></is></c>");
            }
            sb.Append("</row>");

            // Data rows
            for (int r = 0; r < rows.Count; r++)
            {
                int excelRow = r + 2;
                sb.Append($"<row r=\"{excelRow}\">");
                for (int col = 0; col < rows[r].Length; col++)
                {
                    string cellRef = GetColumnLetter(col) + excelRow;
                    sb.Append($"<c r=\"{cellRef}\" t=\"inlineStr\"><is><t>{XmlEscape(rows[r][col])}</t></is></c>");
                }
                sb.Append("</row>");
            }

            sb.Append("</sheetData>");
            sb.Append("</worksheet>");
            return sb.ToString();
        }

        private string GetColumnLetter(int zeroBasedIndex)
        {
            int dividend = zeroBasedIndex + 1;
            string columnLetter = "";
            while (dividend > 0)
            {
                int modulo = (dividend - 1) % 26;
                columnLetter = Convert.ToChar(65 + modulo) + columnLetter;
                dividend = (dividend - modulo - 1) / 26;
            }
            return columnLetter;
        }

        private string XmlEscape(string value)
        {
            if (string.IsNullOrEmpty(value)) return "";
            return value
                .Replace("&", "&amp;")
                .Replace("<", "&lt;")
                .Replace(">", "&gt;")
                .Replace("\"", "&quot;")
                .Replace("'", "&apos;");
        }

        private const string ContentTypesXml =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">" +
            "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>" +
            "<Default Extension=\"xml\" ContentType=\"application/xml\"/>" +
            "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>" +
            "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>" +
            "<Override PartName=\"/xl/styles.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml\"/>" +
            "</Types>";

        private const string RootRelsXml =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>" +
            "</Relationships>";

        private const string WorkbookXml =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">" +
            "<sheets><sheet name=\"Monthly Snapshot\" sheetId=\"1\" r:id=\"rId1\"/></sheets>" +
            "</workbook>";

        private const string WorkbookRelsXml =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>" +
            "<Relationship Id=\"rId2\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>" +
            "</Relationships>";

        private const string StylesXml =
             "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
             "<styleSheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">" +

             "<fonts count=\"2\">" +
             "<font><sz val=\"11\"/><name val=\"Calibri\"/></font>" +
             "<font><b/><sz val=\"11\"/><name val=\"Calibri\"/></font>" +
             "</fonts>" +

             "<fills count=\"2\">" +
             "<fill><patternFill patternType=\"none\"/></fill>" +
             "<fill><patternFill patternType=\"gray125\"/></fill>" +
             "</fills>" +

             "<borders count=\"1\">" +
             "<border>" +
             "<left/><right/><top/><bottom/><diagonal/>" +
             "</border>" +
             "</borders>" +

             "<cellStyleXfs count=\"1\">" +
             "<xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"0\"/>" +
             "</cellStyleXfs>" +

             "<cellXfs count=\"2\">" +
             "<xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"0\" xfId=\"0\"/>" +
             "<xf numFmtId=\"0\" fontId=\"1\" fillId=\"0\" borderId=\"0\" xfId=\"0\" applyFont=\"1\"/>" +
             "</cellXfs>" +

             "<cellStyles count=\"1\">" +
             "<cellStyle name=\"Normal\" xfId=\"0\" builtinId=\"0\"/>" +
             "</cellStyles>" +

             "</styleSheet>";

        // =====================================================
        // TOAST NOTIFICATION
        // =====================================================

        /// <summary>
        /// Shows a dismissible toast in one of four styles (success,
        /// error, warning, info), matching the pattern established in
        /// PartnerMaster.aspx. Auto-dismiss after 3 seconds is handled
        /// client-side via the small inline script emitted alongside
        /// the toast markup in the .aspx.
        /// </summary>
        private void ShowToast(string title, string text, string type = "success")
        {
            litToastTitle.Text = title;
            litToastText.Text = text;
            pnlToast.Visible = true;

            switch (type)
            {
                case "error":
                    pnlToast.CssClass = "toast-stack is-error";
                    break;
                case "warning":
                    pnlToast.CssClass = "toast-stack is-warning";
                    break;
                case "info":
                    pnlToast.CssClass = "toast-stack is-info";
                    break;
                default:
                    pnlToast.CssClass = "toast-stack";
                    break;
            }
        }
    }
}