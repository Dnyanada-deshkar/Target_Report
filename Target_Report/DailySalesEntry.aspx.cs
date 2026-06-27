using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class DailySalesEntry : System.Web.UI.Page
    {
       
        private string ConnString =>
            ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPartners();

                BindTodaySales();
                BindCurrentMonthSales();
            }
        }

       


        private void LoadPartners()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetPartners", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();

                ddlPartner.DataSource = cmd.ExecuteReader();
                ddlPartner.DataTextField = "PartnerName";
                ddlPartner.DataValueField = "PartnerID";
                ddlPartner.DataBind();

                ddlPartner.Items.Insert(
                    0,
                    new ListItem("-- Select Partner --", "0"));
            }
        }

       

        protected void ddlPartner_SelectedIndexChanged(
    object sender,
    EventArgs e)
        {
            if (ddlPartner.SelectedValue == "0")
            {
                txtTargetBalance.Text = "";
                return;
            }

            LoadPartnerTarget();
        }

        private void LoadPartnerTarget()
        {
            using (SqlConnection con =
                new SqlConnection(ConnString))
            using (SqlCommand cmd =
                new SqlCommand("USP_GetPartnerTarget", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@PartnerID",
                    ddlPartner.SelectedValue);

                cmd.Parameters.AddWithValue(
                    "@TargetMonth",
                    DateTime.Now.Month);

                cmd.Parameters.AddWithValue(
                    "@TargetYear",
                    DateTime.Now.Year);

                con.Open();

                SqlDataReader dr =
                    cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtTargetBalance.Text =
                        Convert.ToDecimal(
                            dr["TargetBalance"])
                        .ToString("N2");
                }
            }
        }

      

        protected void cvDailySale_ServerValidate(object source, ServerValidateEventArgs args)
        {
            decimal v;
            args.IsValid = decimal.TryParse(args.Value, out v) && v > 0;
        }


        protected void btnSave_Click(
            object sender,
            EventArgs e)
        {
            decimal sale;

            if (!decimal.TryParse(
                txtDailySale.Text,
                out sale))
            {
                return;
            }

            using (SqlConnection con =
                new SqlConnection(ConnString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "USP_SaveDailySale",
                    con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue(
                    "@PartnerID",
                    ddlPartner.SelectedValue);

                cmd.Parameters.AddWithValue(
                    "@SalesAchieved",
                    sale);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadPartnerTarget();
            BindTodaySales();
            BindCurrentMonthSales();
            txtDailySale.Text = "";

            ShowToast(
                "Success",
                "Daily sale saved successfully.");
        }

      

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlPartner.SelectedIndex = 0;
            txtDailySale.Text = "";
            txtTargetBalance.Text = "";
        }

       
        private static string FormatINRDisplay(decimal value)
        {
            var culture = new CultureInfo("hi-IN");
            return "₹" + string.Format(culture, "{0:N0}", value);
        }

        private void BindTodaySales()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetTodaySales", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                DataTable dt = new DataTable();

                con.Open();

                dt.Load(cmd.ExecuteReader());

                gvTodaySales.DataSource = dt;
                gvTodaySales.DataBind();
            }
        }

        private void BindCurrentMonthSales()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetCurrentMonthSales", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Month", DateTime.Now.Month);
                cmd.Parameters.AddWithValue("@Year", DateTime.Now.Year);

                DataTable dt = new DataTable();

                con.Open();

                dt.Load(cmd.ExecuteReader());

                gvMonthSales.DataSource = dt;
                gvMonthSales.DataBind();
            }
        }
        protected void gvTodaySales_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTodaySales.EditIndex = e.NewEditIndex;
            BindTodaySales();
        }
        protected void gvTodaySales_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTodaySales.EditIndex = -1;
            BindTodaySales();
        }
        protected void gvTodaySales_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTodaySales.PageIndex = e.NewPageIndex;
            BindTodaySales();
        }
        protected void gvMonthSales_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMonthSales.PageIndex = e.NewPageIndex;
            BindCurrentMonthSales();
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetCurrentMonthSales", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Month", DateTime.Now.Month);
                cmd.Parameters.AddWithValue("@Year", DateTime.Now.Year);

                DataTable dt = new DataTable();

                con.Open();
                dt.Load(cmd.ExecuteReader());

                DataView dv = dt.DefaultView;
                dv.RowFilter = $"PartnerName LIKE '%{txtSearch.Text.Trim().Replace("'", "''")}%'";

                gvMonthSales.DataSource = dv;
                gvMonthSales.DataBind();
            }
        }
        protected void btnResetSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindCurrentMonthSales();
        }
        protected void gvTodaySales_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int saleID = Convert.ToInt32(gvTodaySales.DataKeys[e.RowIndex].Value);

            TextBox txtSale =
                (TextBox)gvTodaySales.Rows[e.RowIndex].Cells[3].Controls[0];

            decimal sale;

            if (!decimal.TryParse(txtSale.Text.Trim(), out sale))
            {
                ShowToast("Error", "Invalid sale amount.", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_UpdateDailySale", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SaleID", saleID);
                cmd.Parameters.AddWithValue("@SalesAchieved", sale);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvTodaySales.EditIndex = -1;

            LoadPartnerTarget();
            BindTodaySales();
            BindCurrentMonthSales();

            ShowToast("Success", "Daily sale updated successfully.");
        }

        protected void gvTodaySales_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int saleID = Convert.ToInt32(gvTodaySales.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_DeleteDailySale", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SaleID", saleID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadPartnerTarget();
            BindTodaySales();
            BindCurrentMonthSales();

            ShowToast("Success", "Daily sale deleted successfully.");
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