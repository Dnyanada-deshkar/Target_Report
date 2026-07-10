using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class SalesExecutiveMaster : System.Web.UI.Page
    {
        private string ConnString =>
            ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            pnlToast.Visible = false;
            if (!IsPostBack)
            {
                LoadBranches();

                ddlPageSize.SelectedValue = "10";

                LoadGrid();

                litFormMode.Text = "New Executive";
                hdnExecutiveID.Value = "0";
            }
        }

        private void LoadBranches()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetBranches", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();

                ddlBranch.DataSource = cmd.ExecuteReader();
                ddlBranch.DataTextField = "BranchName";
                ddlBranch.DataValueField = "BranchName";
                ddlBranch.DataBind();

                ddlBranch.Items.Insert(
                    0,
                    new ListItem("-- Select Branch --", "0"));
            }
        }

        private void LoadGrid()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_SalesExecutive_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SearchText", txtSearch.Text.Trim());

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvExecutive.PageSize =
                    Convert.ToInt32(ddlPageSize.SelectedValue);

                gvExecutive.DataSource = dt;
                gvExecutive.DataBind();
            }
        }

        private void ClearForm()
        {
            
            hdnExecutiveID.Value = "0";

            txtExecutiveName.Text = "";
            txtContactNumber.Text = "";

            ddlBranch.SelectedIndex = 0;

            litFormMode.Text = "New Executive";

            btnSave.Text = "Save Executive";
        }

        private void ShowToast(
            string title,
            string message,
            bool isError = false)
        {
            litToastTitle.Text = title;
            litToastText.Text = message;

            pnlToast.Visible = true;

            pnlToast.CssClass =
                isError
                ? "toast-stack is-error"
                : "toast-stack";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_SalesExecutive_Save", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@ExecutiveID",
                    Convert.ToInt32(hdnExecutiveID.Value));

                cmd.Parameters.AddWithValue(
                    "@ExecutiveName",
                    txtExecutiveName.Text.Trim());

                cmd.Parameters.AddWithValue(
                    "@ContactNumber",
                    txtContactNumber.Text.Trim());

                cmd.Parameters.AddWithValue(
                    "@NativeBranch",
                    ddlBranch.SelectedValue);

                SqlParameter msg =
                    new SqlParameter("@Message", SqlDbType.VarChar, 200);

                msg.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(msg);

                con.Open();

                cmd.ExecuteNonQuery();

                string result =
                    Convert.ToString(msg.Value);

                if (result != "SUCCESS")
                {
                    ShowToast(
                        "Validation",
                        result,
                        true);

                    return;
                }
            }

            if (hdnExecutiveID.Value == "0")
            {
                ShowToast(
                    "Success",
                    "Sales Executive added successfully.");
            }
            else
            {
                ShowToast(
                    "Success",
                    "Sales Executive updated successfully.");
            }

            ClearForm();

            LoadGrid();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            gvExecutive.PageIndex = 0;

            LoadGrid();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvExecutive.PageIndex = 0;

            LoadGrid();
        }

        protected void gvExecutive_PageIndexChanging(
            object sender,
            GridViewPageEventArgs e)
        {
            gvExecutive.PageIndex = e.NewPageIndex;

            LoadGrid();
        }
        protected void gvExecutive_RowCommand(
    object sender,
    GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditExecutive")
            {
                int executiveId =
                    Convert.ToInt32(e.CommandArgument);

                LoadExecutive(executiveId);
            }

            if (e.CommandName == "DeleteExecutive")
            {
                DeleteExecutive(
                    Convert.ToInt32(e.CommandArgument));
            }
        }

        private void LoadExecutive(int executiveId)
        {
            
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_SalesExecutive_GetByID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@ExecutiveID",
                    executiveId);

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    hdnExecutiveID.Value =
                        dr["ExecutiveID"].ToString();

                    txtExecutiveName.Text =
                        dr["ExecutiveName"].ToString();

                    txtContactNumber.Text =
                        dr["ContactNumber"].ToString();

                    ListItem item =
                        ddlBranch.Items.FindByValue(
                            dr["NativeBranch"].ToString());

                    if (item != null)
                    {
                        ddlBranch.ClearSelection();
                        item.Selected = true;
                    }

                    litFormMode.Text = "Edit Executive";

                    btnSave.Text = "Update Executive";
                }
            }
        }

        private void DeleteExecutive(int executiveId)
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_SalesExecutive_Delete", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@ExecutiveID",
                    executiveId);

                SqlParameter msg =
                    new SqlParameter("@Message", SqlDbType.VarChar, 200);

                msg.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(msg);

                con.Open();

                cmd.ExecuteNonQuery();

                string result =
                    Convert.ToString(msg.Value);

                if (result != "SUCCESS")
                {
                    ShowToast(
                        "Delete Failed",
                        result,
                        true);

                    return;
                }
            }

            ShowToast(
                "Success",
                "Sales Executive deleted successfully.");

            ClearForm();

            LoadGrid();
        }

        protected void gvExecutive_RowDataBound(
            object sender,
            GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            LinkButton btnDelete =
                e.Row.FindControl("lnkDelete") as LinkButton;

            if (btnDelete != null)
            {
                btnDelete.OnClientClick =
                    "return confirm('Are you sure you want to delete this Sales Executive?');";
            }
        }

        protected void gvExecutive_PreRender(
            object sender,
            EventArgs e)
        {
            if (gvExecutive.Rows.Count > 0)
            {
                gvExecutive.UseAccessibleHeader = true;

                gvExecutive.HeaderRow.TableSection =
                    TableRowSection.TableHeader;
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            int executiveId =
                Convert.ToInt32(btn.CommandArgument);

            LoadExecutive(executiveId);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            int executiveId =
                Convert.ToInt32(btn.CommandArgument);

            DeleteExecutive(executiveId);
        }
    }
}