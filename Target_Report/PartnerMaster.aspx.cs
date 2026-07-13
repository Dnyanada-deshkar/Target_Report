using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class PartnerMaster : System.Web.UI.Page
    {
        // ViewState keys
        private const string VS_SORT_EXPR = "SortExpression";
        private const string VS_SORT_DIR = "SortDirection";
        private const string VS_CURRENT_PAGE = "CurrentPage";
        private const string VS_DELETE_TARGET_ID = "PendingDeletePartnerId";

        private string ConnString => ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState[VS_SORT_EXPR] = "PartnerID";
                ViewState[VS_SORT_DIR] = "ASC";
                ViewState[VS_CURRENT_PAGE] = 1;
                LoadBrands();

                ResetFormToAddMode();
                BindGrid();
            }
        }

        // =====================================================
        // DATA ACCESS
        // =====================================================

        /// <summary>
        /// Retrieves partners filtered by search text and branch, sorted and paged.
        /// Replace table/column names to match your actual schema if different.
        /// </summary>
        private DataTable GetPartnermaster(string searchText, string branchFilter, string sortExpr, string sortDir,
                                       int pageNumber, int pageSize, out int totalRecords)
        {
            var result = new DataTable();
            totalRecords = 0;

            string allowedSort = new[] { "PartnerID", "PartnerName", "ContactNumber", "City", "NativeBranch", "CreatedDate" }
                .Contains(sortExpr) ? sortExpr : "PartnerID";
            string allowedDir = sortDir == "DESC" ? "DESC" : "ASC";

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();
                const string query = @"
                    SELECT PartnerID, PartnerName, ContactNumber, City, NativeBranch, CreatedDate,
                           COUNT(*) OVER() AS TotalRecords
                    FROM Partnermaster
                    WHERE (@Search = '' 
                           OR PartnerName LIKE '%' + @Search + '%' 
                           OR ContactNumber LIKE '%' + @Search + '%' 
                           OR City LIKE '%' + @Search + '%')
                      AND (@Branch = '' OR NativeBranch = @Branch)
                   ORDER BY
    CASE WHEN @SortExpr = 'PartnerID' AND @SortDir = 'ASC' THEN PartnerID END ASC,
    CASE WHEN @SortExpr = 'PartnerID' AND @SortDir = 'DESC' THEN PartnerID END DESC,

    CASE WHEN @SortExpr = 'PartnerName' AND @SortDir = 'ASC' THEN PartnerName END ASC,
    CASE WHEN @SortExpr = 'PartnerName' AND @SortDir = 'DESC' THEN PartnerName END DESC,

    CASE WHEN @SortExpr = 'ContactNumber' AND @SortDir = 'ASC' THEN ContactNumber END ASC,
    CASE WHEN @SortExpr = 'ContactNumber' AND @SortDir = 'DESC' THEN ContactNumber END DESC,

    CASE WHEN @SortExpr = 'NativeBranch' AND @SortDir = 'ASC' THEN NativeBranch END ASC,
    CASE WHEN @SortExpr = 'NativeBranch' AND @SortDir = 'DESC' THEN NativeBranch END DESC,

    CASE WHEN @SortExpr = 'City' AND @SortDir = 'ASC' THEN City END ASC,
    CASE WHEN @SortExpr = 'City' AND @SortDir = 'DESC' THEN City END DESC,

    CASE WHEN @SortExpr = 'CreatedDate' AND @SortDir = 'ASC' THEN CreatedDate END ASC,
    CASE WHEN @SortExpr = 'CreatedDate' AND @SortDir = 'DESC' THEN CreatedDate END DESC

OFFSET @Offset ROWS
FETCH NEXT @PageSize ROWS ONLY";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", searchText ?? "");
                    cmd.Parameters.AddWithValue("@Branch", branchFilter ?? "");
                    cmd.Parameters.AddWithValue("@SortExpr", allowedSort);
                    cmd.Parameters.AddWithValue("@SortDir", allowedDir);
                    cmd.Parameters.AddWithValue("@Offset", (pageNumber - 1) * pageSize);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }
            }

            if (result.Rows.Count > 0 && result.Columns.Contains("TotalRecords"))
            {
                totalRecords = Convert.ToInt32(result.Rows[0]["TotalRecords"]);
            }

            return result;
        }

        private bool PartnerNameExists(string partnerName, int excludePartnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT COUNT(1) FROM Partnermaster 
                                        WHERE PartnerName = @PartnerName AND PartnerID <> @ExcludeId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartnerName", partnerName);
                    cmd.Parameters.AddWithValue("@ExcludeId", excludePartnerId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private bool ContactNumberExists(string contactNumber, int excludePartnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT COUNT(1) FROM Partnermaster 
                                        WHERE ContactNumber = @ContactNumber AND PartnerID <> @ExcludeId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ContactNumber", contactNumber);
                    cmd.Parameters.AddWithValue("@ExcludeId", excludePartnerId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private int InsertPartner(string name, string contact, string city, string branch)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_Partner_Insert", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@PartnerName", name);
                cmd.Parameters.AddWithValue("@ContactNumber", contact);
                cmd.Parameters.AddWithValue("@City", city);
                cmd.Parameters.AddWithValue("@NativeBranch", branch);

                conn.Open();

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void LoadBrands()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_Brand_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SearchText", "");

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                cblBrands.DataSource = dr;
                cblBrands.DataTextField = "BrandName";
                cblBrands.DataValueField = "BrandID";
                cblBrands.DataBind();
            }
        }
        private void UpdatePartner(int partnerId, string name, string contact, string city, string branch)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"UPDATE Partnermaster 
                                        SET PartnerName = @PartnerName, ContactNumber = @ContactNumber, 
                                            City = @City, NativeBranch = @NativeBranch
                                        WHERE PartnerID = @PartnerID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartnerName", name);
                    cmd.Parameters.AddWithValue("@ContactNumber", contact);
                    cmd.Parameters.AddWithValue("@City", city);
                    cmd.Parameters.AddWithValue("@NativeBranch", branch);
                    cmd.Parameters.AddWithValue("@PartnerID", partnerId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private DataRow GetPartnerById(int partnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT PartnerID, PartnerName, ContactNumber, City, NativeBranch 
                                        FROM Partnermaster WHERE PartnerID = @PartnerID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartnerID", partnerId);
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                    }
                }
            }
        }

        private void DeletePartnerById(int partnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = "DELETE FROM Partnermaster WHERE PartnerID = @PartnerID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartnerID", partnerId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // =====================================================
        // GRID BINDING — search, filter, sort, page
        // =====================================================

        private void BindGrid()
        {
            string searchText = txtSearch.Text.Trim();
            string branchFilter = ddlBranchFilter.SelectedValue;
            string sortExpr = ViewState[VS_SORT_EXPR] as string ?? "PartnerID";
            string sortDir = ViewState[VS_SORT_DIR] as string ?? "ASC";
            int currentPage = ViewState[VS_CURRENT_PAGE] != null ? (int)ViewState[VS_CURRENT_PAGE] : 1;
            int pageSize = int.Parse(ddlPageSize.SelectedValue);

            int totalRecords;
            DataTable partners = GetPartnermaster(
                searchText,
                branchFilter,
                sortExpr,
                sortDir,
                currentPage,
                pageSize,
                out totalRecords);

            gvPartners.DataSource = partners;
            gvPartners.DataBind();

            int totalPages = (int)Math.Ceiling(totalRecords / (double)pageSize);
            if (totalPages == 0) totalPages = 1;

            // Clamp current page if filtering reduced the result set
            if (currentPage > totalPages)
            {
                currentPage = totalPages;
                ViewState[VS_CURRENT_PAGE] = currentPage;
                partners = GetPartnermaster(searchText, branchFilter, sortExpr, sortDir, currentPage, pageSize, out totalRecords);
            }


            gvPartners.DataSource = partners;
            gvPartners.DataBind();

            litResultCount.Text = totalRecords == 1 ? "1 Partner" : $"{totalRecords} Partners";

            BindPaginationControls(currentPage, totalPages);
        }

        private void BindPaginationControls(int currentPage, int totalPages)
        {
            lnkFirst.Enabled = currentPage > 1;
            lnkPrev.Enabled = currentPage > 1;
            lnkNext.Enabled = currentPage < totalPages;
            lnkLast.Enabled = currentPage < totalPages;

            // Show a sliding window of up to 5 page numbers
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
        // SEARCH / FILTER / SORT / PAGE EVENT HANDLERS
        // =====================================================

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void ddlBranchFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void gvPartners_Sorting(object sender, GridViewSortEventArgs e)
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

            BindGrid();
        }

        protected void lnkFirst_Click(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void lnkPrev_Click(object sender, EventArgs e)
        {
            int current = (int)ViewState[VS_CURRENT_PAGE];
            ViewState[VS_CURRENT_PAGE] = Math.Max(1, current - 1);
            BindGrid();
        }

        protected void lnkNext_Click(object sender, EventArgs e)
        {
            int current = (int)ViewState[VS_CURRENT_PAGE];
            ViewState[VS_CURRENT_PAGE] = current + 1;
            BindGrid();
        }

        protected void lnkLast_Click(object sender, EventArgs e)
        {
            // BindGrid() clamps to totalPages internally; setting a large
            // number here is safe and avoids a second round-trip.
            ViewState[VS_CURRENT_PAGE] = int.MaxValue;
            BindGrid();
        }

        protected void rptPageNumbers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "GoToPage")
            {
                ViewState[VS_CURRENT_PAGE] = Convert.ToInt32(e.CommandArgument);
                BindGrid();
            }
        }

        // =====================================================
        // GRID ROW ACTIONS — Edit / Delete
        // =====================================================

        protected void gvPartners_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int partnerId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditPartner")
            {
                LoadPartnerIntoForm(partnerId);
            }
            else if (e.CommandName == "DeletePartner")
            {
                OpenDeleteConfirmation(partnerId);
            }
        }

        private void LoadPartnerIntoForm(int partnerId)
        {
            DataRow partner = GetPartnerById(partnerId);
            if (partner == null)
            {
                ShowToast("Partner not found", "This partner may have already been removed.", isError: true);
                BindGrid();
                return;
            }

            hdnPartnerId.Value = partnerId.ToString();
            txtPartnerName.Text = partner["PartnerName"].ToString();
            txtContactNumber.Text = partner["ContactNumber"].ToString();
            txtCity.Text = partner["City"].ToString();
            ddlNativeBranch.SelectedValue = partner["NativeBranch"].ToString();
            LoadPartnerBrands(partnerId);
            SetFormMode(isEditing: true);
            ClearFormMessage();
        }
        private void DeletePartnerBrands(int partnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_PartnerBrandMapping_DeleteByPartnerID", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@PartnerID", partnerId);

                conn.Open();

                cmd.ExecuteNonQuery();
            }
        }
        private void OpenDeleteConfirmation(int partnerId)
        {
            DataRow partner = GetPartnerById(partnerId);
            if (partner == null)
            {
                ShowToast("Partner not found", "This partner may have already been removed.", isError: true);
                BindGrid();
                return;
            }

            ViewState[VS_DELETE_TARGET_ID] = partnerId;
            litDeletePartnerName.Text = partner["PartnerName"].ToString();
            pnlDeleteModalOverlay.CssClass = "modal-overlay";
        }

        protected void btnCancelDelete_Click(object sender, EventArgs e)
        {
            ViewState[VS_DELETE_TARGET_ID] = null;
            pnlDeleteModalOverlay.CssClass = "modal-overlay is-hidden";
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (ViewState[VS_DELETE_TARGET_ID] != null)
            {
                int partnerId = (int)ViewState[VS_DELETE_TARGET_ID];
                string partnerName = litDeletePartnerName.Text;

                try
                {
                    DeletePartnerById(partnerId);

                    if (hdnPartnerId.Value == partnerId.ToString())
                    {
                        ResetFormToAddMode();
                    }

                    ShowToast("Partner deleted",
                        $"\"{partnerName}\" has been removed from the partner list.");
                }
                catch (SqlException)
                {
                    ShowToast("Unable to delete partner",
                        "This partner may be referenced by existing target or sales records.",
                        isError: true);
                }
            }

            ViewState[VS_DELETE_TARGET_ID] = null;
            pnlDeleteModalOverlay.CssClass = "modal-overlay is-hidden";
            BindGrid();
        } 
        protected void btnSave_Click(object sender, EventArgs e)
        {

            foreach (ListItem x in cblBrands.Items)
            {
                System.Diagnostics.Debug.WriteLine(
                    x.Text + " = " + x.Selected);
            }

            bool brandSelected = cblBrands.Items.Cast<ListItem>()
                                    .Any(x => x.Selected);

            if (!brandSelected)
            {
                ShowFormMessage("Please select at least one Brand.");
                return;
            }

            if (!Page.IsValid) return;

            string name = txtPartnerName.Text.Trim();
            string contact = txtContactNumber.Text.Trim();
            string city = txtCity.Text.Trim();
            string branch = ddlNativeBranch.SelectedValue;

            if (PartnerNameExists(name, excludePartnerId: 0))
            {
                ShowFormMessage("A partner with this name already exists.");
                return;
            }
            if (ContactNumberExists(contact, excludePartnerId: 0))
            {
                ShowFormMessage("This contact number is already registered to another partner.");
                return;
            }

            int partnerId = InsertPartner(name, contact, city, branch);
            SavePartnerBrands(partnerId);

            ShowToast("Partner saved", $"\"{name}\" has been added to the partner list.");

            ResetFormToAddMode();
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();


            ResetFormToAddMode();
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }
        private void LoadPartnerBrands(int partnerId)
        {
          
            foreach (ListItem item in cblBrands.Items)
            {
                item.Selected = false;
            }

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_PartnerBrandMapping_GetByPartnerID", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PartnerID", partnerId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        string brandId = dr["BrandID"].ToString();

                        ListItem item = cblBrands.Items.FindByValue(brandId);

                        if (item != null)
                            item.Selected = true;
                    }
                }
            }
        }

        private void SavePartnerBrands(int partnerId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();

                foreach (ListItem item in cblBrands.Items)
                {
                    if (!item.Selected)
                        continue;

                    using (SqlCommand cmd = new SqlCommand("USP_PartnerBrandMapping_Save", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = partnerId;
                        cmd.Parameters.Add("@BrandID", SqlDbType.Int).Value = Convert.ToInt32(item.Value);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;


            int partnerId = Convert.ToInt32(hdnPartnerId.Value);
            string name = txtPartnerName.Text.Trim();
            string contact = txtContactNumber.Text.Trim();
            string city = txtCity.Text.Trim();
            string branch = ddlNativeBranch.SelectedValue;

            bool brandSelected = cblBrands.Items.Cast<ListItem>().Any(x => x.Selected);

            if (!brandSelected)
            {
                ShowFormMessage("Please select at least one Brand.");
                return;
            }
            if (PartnerNameExists(name, partnerId))
            {
                ShowFormMessage("A partner with this name already exists.");
                return;
            }
            if (ContactNumberExists(contact, partnerId))
            {
                ShowFormMessage("This contact number is already registered to another partner.");
                return;
            }

            UpdatePartner(partnerId, name, contact, city, branch);
            DeletePartnerBrands(partnerId);

            SavePartnerBrands(partnerId);

            ShowToast("Partner updated",
                $"Changes to \"{name}\" have been saved.");

            ResetFormToAddMode();

            BindGrid();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            // Clear wipes the fields but keeps current Add/Edit mode
            txtPartnerName.Text = "";
            txtContactNumber.Text = "";
            txtCity.Text = "";
            ddlNativeBranch.SelectedValue = "";
            ClearFormMessage();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetFormToAddMode();
        }

        // =====================================================
        // FORM MODE HELPERS
        // =====================================================

        private void ResetFormToAddMode()
        {
            hdnPartnerId.Value = "0";
            txtPartnerName.Text = "";
            txtContactNumber.Text = "";
            txtCity.Text = "";
            ddlNativeBranch.SelectedValue = "";
            ClearFormMessage();
            SetFormMode(isEditing: false);
        }

        private void SetFormMode(bool isEditing)
        {
            litFormMode.Text = isEditing ? "Editing Partner" : "New Partner";
            pnlFormMode.CssClass = isEditing ? "form-mode-tag is-editing" : "form-mode-tag";

            btnSave.Visible = !isEditing;
            btnUpdate.Visible = isEditing;
            btnCancel.Visible = isEditing;
        }

        private void ShowFormMessage(string message)
        {
            litFormMessage.Text = message;
            pnlFormMessage.Visible = true;
        }

        private void ClearFormMessage()
        {
            litFormMessage.Text = "";
            pnlFormMessage.Visible = false;
        }

        private void ShowToast(string title, string text, bool isError = false)
        {
            litToastTitle.Text = title;
            litToastText.Text = text;
            pnlToast.Visible = true;
            pnlToast.CssClass = isError ? "toast-stack is-error" : "toast-stack";
        }
    }
}
