using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class BrandMaster : System.Web.UI.Page
    {
        private string ConnString =>
            ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            pnlToast.Visible = false;
            if (!IsPostBack)
            {
                ddlPageSize.SelectedValue = "10";

                LoadGrid();

                litFormMode.Text = "New Brand";

                hdnBrandID.Value = "0";
            }
        }

        private void LoadGrid()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_Brand_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@SearchText",
                    txtSearch.Text.Trim());

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvBrand.PageSize =
                    Convert.ToInt32(ddlPageSize.SelectedValue);

                gvBrand.DataSource = dt;
                gvBrand.DataBind();
            }
        }

        private void ClearForm()
        {
            hdnBrandID.Value = "0";

            txtBrandName.Text = "";

            litFormMode.Text = "New Brand";

            btnSave.Text = "Save Brand";
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
            using (SqlCommand cmd = new SqlCommand("USP_Brand_Save", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@BrandID",
                    Convert.ToInt32(hdnBrandID.Value));

                cmd.Parameters.AddWithValue(
                    "@BrandName",
                    txtBrandName.Text.Trim());

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

            if (hdnBrandID.Value == "0")
            {
                ShowToast(
                    "Success",
                    "Brand added successfully.");
            }
            else
            {
                ShowToast(
                    "Success",
                    "Brand updated successfully.");
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
            gvBrand.PageIndex = 0;

            LoadGrid();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvBrand.PageIndex = 0;

            LoadGrid();
        }

        protected void gvBrand_PageIndexChanging(
            object sender,
            GridViewPageEventArgs e)
        {
            gvBrand.PageIndex = e.NewPageIndex;

            LoadGrid();
        }

        protected void gvBrand_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditBrand")
            {
                LoadBrand(
                    Convert.ToInt32(e.CommandArgument));
            }

            if (e.CommandName == "DeleteBrand")
            {
                DeleteBrand(
                    Convert.ToInt32(e.CommandArgument));
            }
        }

        private void LoadBrand(int brandId)
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_Brand_GetByID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@BrandID",
                    brandId);

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    hdnBrandID.Value =
                        dr["BrandID"].ToString();

                    txtBrandName.Text =
                        dr["BrandName"].ToString();

                    litFormMode.Text =
                        "Edit Brand";

                    btnSave.Text =
                        "Update Brand";
                }
            }
        }

        private void DeleteBrand(int brandId)
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_Brand_Delete", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@BrandID",
                    brandId);

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
                "Brand deleted successfully.");

            //ClearForm();

            //LoadGrid();
            return;
        }

        protected void gvBrand_RowDataBound(
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
                    "return confirm('Are you sure you want to delete this Brand?');";
            }
        }

        protected void gvBrand_PreRender(
            object sender,
            EventArgs e)
        {
            if (gvBrand.Rows.Count > 0)
            {
                gvBrand.UseAccessibleHeader = true;

                gvBrand.HeaderRow.TableSection =
                    TableRowSection.TableHeader;
            }
        }
    }
}