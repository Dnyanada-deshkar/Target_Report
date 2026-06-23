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
    public partial class TargetMaster : System.Web.UI.Page
    {
        // ViewState keys
        private const string VS_SORT_EXPR = "SortExpression";
        private const string VS_SORT_DIR = "SortDirection";
        private const string VS_CURRENT_PAGE = "CurrentPage";
        private const string VS_DELETE_TARGET_ID = "PendingDeleteTargetId";

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
                ViewState[VS_SORT_EXPR] = "CreatedDate";
                ViewState[VS_SORT_DIR] = "DESC";
                ViewState[VS_CURRENT_PAGE] = 1;

                litTargetYear.Text = DateTime.Now.Year.ToString();

                LoadPartnerDropdown();
                ResetFormToAddMode();
                txtTargetMonth.Text = DateTime.Now.ToString("MMMM");
                BindGrid();
            }
        }

        // =====================================================
        // PARTNER DROPDOWN + AUTO-FILL
        // =====================================================

        private void LoadPartnerDropdown()
        {
            DataTable partners = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT PartnerID, PartnerName FROM PartnerMaster ORDER BY PartnerName";
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
            ddlPartner.Items.Insert(0, new ListItem("Select partner", ""));
        }

        /// <summary>
        /// Auto-fills Partner Contact, City, and Branch the moment a
        /// partner is selected. These three fields are always read-only
        /// and never persisted on the Targets table itself — Branch in
        /// particular is looked up live via this join every time, per
        /// the approved design (never stored on Targets).
        /// </summary>
        protected void ddlPartner_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulatePartnerAutoFillFields(ddlPartner.SelectedValue);
            ClearFormMessage();
        }

        private void PopulatePartnerAutoFillFields(string partnerId)
        {
            if (string.IsNullOrEmpty(partnerId))
            {
                txtPartnerContact.Text = "";
                txtCity.Text = "";
                txtBranch.Text = "";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                const string query = @"SELECT ContactNumber, City, NativeBranch FROM PartnerMaster WHERE PartnerID = @PartnerID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartnerID", Convert.ToInt32(partnerId));
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtPartnerContact.Text = reader["ContactNumber"].ToString();
                            txtCity.Text = reader["City"].ToString();
                            txtBranch.Text = reader["NativeBranch"].ToString();
                        }
                        else
                        {
                            txtPartnerContact.Text = "";
                            txtCity.Text = "";
                            txtBranch.Text = "";
                        }
                    }
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
            string monthFilterRaw = ddlMonthFilter.SelectedValue;
            string sortExpr = ViewState[VS_SORT_EXPR] as string ?? "CreatedDate";
            string sortDir = ViewState[VS_SORT_DIR] as string ?? "DESC";
            int currentPage = ViewState[VS_CURRENT_PAGE] != null ? (int)ViewState[VS_CURRENT_PAGE] : 1;
            int pageSize = int.Parse(ddlPageSize.SelectedValue);

            DataTable targets = new DataTable();
            int totalRecords = 0;

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_Target_GetList", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SearchText", searchText);
                    cmd.Parameters.AddWithValue("@BranchFilter", branchFilter ?? "");
                    cmd.Parameters.AddWithValue("@MonthFilter", string.IsNullOrEmpty(monthFilterRaw) ? (object)DBNull.Value : Convert.ToInt32(monthFilterRaw));
                    cmd.Parameters.AddWithValue("@SortExpression", sortExpr);
                    cmd.Parameters.AddWithValue("@SortDirection", sortDir);
                    cmd.Parameters.AddWithValue("@PageNumber", currentPage);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(targets);
                    }
                }
            }

            if (targets.Rows.Count > 0 && targets.Columns.Contains("TotalRecords"))
            {
                totalRecords = Convert.ToInt32(targets.Rows[0]["TotalRecords"]);
            }

            int totalPages = (int)Math.Ceiling(totalRecords / (double)pageSize);
            if (totalPages == 0) totalPages = 1;

            if (currentPage > totalPages)
            {
                currentPage = totalPages;
                ViewState[VS_CURRENT_PAGE] = currentPage;
                BindGrid();
                return;
            }

            gvTargets.DataSource = targets;
            gvTargets.DataBind();

            litResultCount.Text = totalRecords == 1 ? "1 target" : $"{totalRecords} targets";

            BindPaginationControls(currentPage, totalPages);
        }

        private void BindPaginationControls(int currentPage, int totalPages)
        {
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

        /// <summary>
        /// Called from the inline data-binding expression in
        /// TargetMaster.aspx (GetMonthName) — must remain protected,
        /// since ItemTemplate expressions compile against the page's
        /// public/protected surface, not its private members.
        /// </summary>
        protected string GetMonthName(int monthNumber)
        {
            if (monthNumber < 1 || monthNumber > 12) return "";
            return MonthNames[monthNumber];
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

        protected void ddlMonthFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState[VS_CURRENT_PAGE] = 1;
            BindGrid();
        }

        protected void gvTargets_Sorting(object sender, GridViewSortEventArgs e)
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

        protected void gvTargets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int targetId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditTarget")
            {
                LoadTargetIntoForm(targetId);
            }
            else if (e.CommandName == "DeleteTarget")
            {
                OpenDeleteConfirmation(targetId);
            }
        }

        private void LoadTargetIntoForm(int targetId)
        {
            DataRow target = GetTargetById(targetId);
            if (target == null)
            {
                ShowToast("Target not found", "This target may have already been removed.", isError: true);
                BindGrid();
                return;
            }

            hdnTargetId.Value = targetId.ToString();
            ddlPartner.SelectedValue = target["PartnerID"].ToString();
            txtPartnerContact.Text = target["PartnerContact"].ToString();
            txtCity.Text = target["City"].ToString();
            txtBranch.Text = target["Branch"].ToString();
            txtTargetMonth.Text =GetMonthName(Convert.ToInt32(target["TargetMonth"]));
            txtSalesTarget.Text = Convert.ToDecimal(target["SalesTarget"]).ToString("0.##");
            txtRemarks.Text = target["Remarks"] != DBNull.Value ? target["Remarks"].ToString() : "";

            SetFormMode(isEditing: true);
            ClearFormMessage();
        }

        private DataRow GetTargetById(int targetId)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("usp_Target_GetById", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TargetID", targetId);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                }
            }
        }

        private void OpenDeleteConfirmation(int targetId)
        {
            DataRow target = GetTargetById(targetId);
            if (target == null)
            {
                ShowToast("Target not found", "This target may have already been removed.", isError: true);
                BindGrid();
                return;
            }

            ViewState[VS_DELETE_TARGET_ID] = targetId;

            string monthName = GetMonthName(Convert.ToInt32(target["TargetMonth"]));
            litDeleteTargetLabel.Text = $"{target["PartnerName"]} — {monthName} {target["TargetYear"]}";

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
                int targetId = (int)ViewState[VS_DELETE_TARGET_ID];
                string targetLabel = litDeleteTargetLabel.Text;

                int resultCode;
                string resultMessage;
                SoftDeleteTarget(targetId, out resultCode, out resultMessage);

                if (resultCode == 0)
                {
                    ShowToast("Target deleted", $"The target for {targetLabel} has been removed.");
                }
                else
                {
                    ShowToast("Unable to delete target", resultMessage, isError: true);
                }

                // If the deleted target was open in the form, reset it
                if (hdnTargetId.Value == targetId.ToString())
                {
                    ResetFormToAddMode();
                }
            }

            ViewState[VS_DELETE_TARGET_ID] = null;
            pnlDeleteModalOverlay.CssClass = "modal-overlay is-hidden";

            BindGrid();
        }

        private void SoftDeleteTarget(int targetId, out int resultCode, out string resultMessage)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("usp_Target_SoftDelete", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TargetID", targetId);

                SqlParameter resultCodeParam = new SqlParameter("@ResultCode", SqlDbType.Int) { Direction = ParameterDirection.Output };
                SqlParameter resultMessageParam = new SqlParameter("@ResultMessage", SqlDbType.NVarChar, 200) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(resultCodeParam);
                cmd.Parameters.Add(resultMessageParam);

                conn.Open();
                cmd.ExecuteNonQuery();

                resultCode = resultCodeParam.Value != DBNull.Value ? Convert.ToInt32(resultCodeParam.Value) : -1;
                resultMessage = resultMessageParam.Value != DBNull.Value ? resultMessageParam.Value.ToString() : "Unable to delete target.";
            }
        }

        // =====================================================
        // FORM ACTIONS — Save / Update / Clear / Cancel
        // =====================================================

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int partnerId = Convert.ToInt32(ddlPartner.SelectedValue);
            int targetMonth = DateTime.Now.Month;
            int targetYear = DateTime.Now.Year;
            decimal purchasePotential = Convert.ToDecimal(txtPurchasePotential.Text.Trim());
            decimal salesTarget = Convert.ToDecimal(txtSalesTarget.Text.Trim());
            string remarks = txtRemarks.Text.Trim();

            int newTargetId;
            int resultCode;
            string resultMessage;

            InsertTarget( partnerId, targetMonth, targetYear, purchasePotential, salesTarget, remarks, out newTargetId, out resultCode, out resultMessage);
            if (resultCode == 0)
            {
                ShowToast("Target saved", $"The target for {ddlPartner.SelectedItem.Text} has been created.");
                ResetFormToAddMode();
                ViewState[VS_CURRENT_PAGE] = 1;
                BindGrid();
            }
            else
            {
                ShowFormMessage(resultMessage);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int targetId = Convert.ToInt32(hdnTargetId.Value);
            int partnerId = Convert.ToInt32(ddlPartner.SelectedValue);
            int targetMonth = DateTime.Now.Month;
            int targetYear = DateTime.Now.Year;
            decimal purchasePotential = Convert.ToDecimal(txtPurchasePotential.Text.Trim());
            decimal salesTarget = Convert.ToDecimal(txtSalesTarget.Text.Trim());
            string remarks = txtRemarks.Text.Trim();


            int resultCode;
            string resultMessage;

            UpdateTarget( targetId, partnerId, targetMonth, targetYear, purchasePotential, salesTarget, remarks, out resultCode, out resultMessage);

            if (resultCode == 0)
            {
                ShowToast("Target updated", $"Changes to {ddlPartner.SelectedItem.Text}'s target have been saved.");
                ResetFormToAddMode();
                BindGrid();
            }
            else
            {
                ShowFormMessage(resultMessage);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            // Clear wipes the fields but keeps current Add/Edit mode
            ddlPartner.SelectedValue = "";
            txtPartnerContact.Text = "";
            txtCity.Text = "";
            txtBranch.Text = "";
            txtTargetMonth.Text = DateTime.Now.ToString("MMMM");
            txtSalesTarget.Text = "";
            txtRemarks.Text = "";
            ClearFormMessage();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetFormToAddMode();
        }

        // =====================================================
        // DATA ACCESS — Insert / Update via stored procedures
        // =====================================================

        private void InsertTarget(int partnerId, int targetMonth, int targetYear, decimal purchasePotential, decimal salesTarget, string remarks,
                                   out int newTargetId, out int resultCode, out string resultMessage)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("usp_Target_Insert", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PartnerID", partnerId);
                cmd.Parameters.AddWithValue("@TargetMonth", targetMonth);
                cmd.Parameters.AddWithValue("@TargetYear", targetYear);
                cmd.Parameters.AddWithValue("@PurchasePotential", purchasePotential);
                cmd.Parameters.AddWithValue("@SalesTarget", salesTarget);
                cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);

                SqlParameter newIdParam = new SqlParameter("@NewTargetID", SqlDbType.Int) { Direction = ParameterDirection.Output };
                SqlParameter resultCodeParam = new SqlParameter("@ResultCode", SqlDbType.Int) { Direction = ParameterDirection.Output };
                SqlParameter resultMessageParam = new SqlParameter("@ResultMessage", SqlDbType.NVarChar, 200) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(newIdParam);
                cmd.Parameters.Add(resultCodeParam);
                cmd.Parameters.Add(resultMessageParam);

                conn.Open();
                cmd.ExecuteNonQuery();

                newTargetId = newIdParam.Value != DBNull.Value ? Convert.ToInt32(newIdParam.Value) : 0;
                resultCode = resultCodeParam.Value != DBNull.Value ? Convert.ToInt32(resultCodeParam.Value) : -1;
                resultMessage = resultMessageParam.Value != DBNull.Value ? resultMessageParam.Value.ToString() : "Unable to save target.";
            }
        }

        private void UpdateTarget(int targetId, int partnerId, int targetMonth, int targetYear, decimal purchasePotential,  decimal salesTarget, string remarks,
                                   out int resultCode, out string resultMessage)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("usp_Target_Update", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TargetID", targetId);
                cmd.Parameters.AddWithValue("@PartnerID", partnerId);
                cmd.Parameters.AddWithValue("@TargetMonth", targetMonth);
                cmd.Parameters.AddWithValue("@TargetYear", targetYear);
                cmd.Parameters.AddWithValue("@PurchasePotential", purchasePotential);    
                cmd.Parameters.AddWithValue("@SalesTarget", salesTarget);
                cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);

                SqlParameter resultCodeParam = new SqlParameter("@ResultCode", SqlDbType.Int) { Direction = ParameterDirection.Output };
                SqlParameter resultMessageParam = new SqlParameter("@ResultMessage", SqlDbType.NVarChar, 200) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(resultCodeParam);
                cmd.Parameters.Add(resultMessageParam);

                conn.Open();
                cmd.ExecuteNonQuery();

                resultCode = resultCodeParam.Value != DBNull.Value ? Convert.ToInt32(resultCodeParam.Value) : -1;
                resultMessage = resultMessageParam.Value != DBNull.Value ? resultMessageParam.Value.ToString() : "Unable to update target.";
            }
        }

        // =====================================================
        // FORM MODE HELPERS
        // =====================================================

        private void ResetFormToAddMode()
{
    hdnTargetId.Value = "0";
    ddlPartner.SelectedValue = "";
    txtPartnerContact.Text = "";
    txtCity.Text = "";
    txtBranch.Text = "";

    txtTargetMonth.Text = DateTime.Now.ToString("MMMM");

    txtSalesTarget.Text = "";
    txtRemarks.Text = "";

    ClearFormMessage();
    SetFormMode(isEditing: false);
}

        private void SetFormMode(bool isEditing)
        {
            litFormMode.Text = isEditing ? "Editing Target" : "New Target";
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

        protected void txtSalesTarget_TextChanged(object sender, EventArgs e)
        {
            decimal salesTarget = 0;

            decimal.TryParse(txtSalesTarget.Text, out salesTarget);

            txtAchievement.Text = "0";

            txtTargetBalance.Text = salesTarget.ToString("N2");
        }


    }
}