using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
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
                pnlToast.Visible = false;

                txtFollowDate.Attributes["min"] =
                    DateTime.Today.ToString("yyyy-MM-dd");

                LoadPartners();
                BindTodaySales();
                BindCurrentMonthSales();

                if (Session["ToastTitle"] != null)
                {
                    ShowToast(
                        Session["ToastTitle"].ToString(),
                        Session["ToastText"].ToString(),
                        Session["ToastType"].ToString());

                    Session.Remove("ToastTitle");
                    Session.Remove("ToastText");
                    Session.Remove("ToastType");
                }
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



        protected void ddlPartner_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            txtRemark.Text = "";
            txtFollowDate.Text = "";

            if (ddlPartner.SelectedValue == "0")
            {
                txtTargetBalance.Text = "";
                txtPartnerNameFollow.Text = "";
                txtContactNumber.Text = "";
                return;
            }

            LoadPartnerTarget();
            LoadPartnerContact();

            txtDailySale.Focus();
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
        private void LoadPartnerContact()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetPartnerContact", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@PartnerID", ddlPartner.SelectedValue);

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtPartnerNameFollow.Text = dr["PartnerName"].ToString();
                    txtContactNumber.Text = dr["ContactNumber"].ToString();
                }
            }
        }


        protected void cvDailySale_ServerValidate(object source, ServerValidateEventArgs args)
        {
            decimal v;
            args.IsValid = decimal.TryParse(args.Value, out v) && v > 0;
        }


        protected void btnSave_Click(object sender, EventArgs e)
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
            ddlPartner.SelectedIndex = 0;
            txtTargetBalance.Text = "";
            txtPartnerNameFollow.Text = "";
            txtContactNumber.Text = "";
            txtRemark.Text = "";
            txtFollowDate.Text = "";

            ddlPartner.Focus();

            ShowToast(
                "Success",
                "Daily sales saved successfully.",
                "success");
        }
        protected void btnSaveFollowup_Click(object sender, EventArgs e)
        {  

            if (ddlPartner.SelectedValue == "0")
            {
                ShowToast(
                    "Warning",
                    "Please select partner.",
                    "warning");

                return;
            }

            DateTime followDate;

            if (!DateTime.TryParse(txtFollowDate.Text, out followDate))
            {
                ShowToast(
                    "Warning",
                    "Please select follow-up date.",
                    "warning");
                return;
            }

            if (followDate.Date < DateTime.Today)
            {
                ShowToast(
                    "Warning",
                        "Past follow-up date is not allowed.",
                    "warning");
                return;
            }
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_SavePartnerFollowUp", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@PartnerID", ddlPartner.SelectedValue);
                cmd.Parameters.AddWithValue("@Remark", txtRemark.Text.Trim());
                cmd.Parameters.AddWithValue("@FollowUpDate", Convert.ToDateTime(txtFollowDate.Text));

                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtRemark.Text = "";
            txtFollowDate.Text = "";
            ddlPartner.SelectedIndex = 0;
            txtTargetBalance.Text = "";
            txtPartnerNameFollow.Text = "";
            txtContactNumber.Text = "";

            Session["ToastTitle"] = "Success";
            Session["ToastText"] = "Follow-up saved successfully.";
            Session["ToastType"] = "success";

            Response.Redirect("~/DailySalesEntry.aspx", false);
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
            using (SqlCommand cmd = new SqlCommand("USP_GetCurrentDaySales", con))
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

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                string search = txtSearch.Text.Trim().ToLower();

                var rows = dt.AsEnumerable()
                             .Where(r => r["PartnerName"].ToString().ToLower().Contains(search));

                if (rows.Any())
                    gvMonthSales.DataSource = rows.CopyToDataTable();
                else
                    gvMonthSales.DataSource = null;

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
                ShowToast("Error", "Invalid sale amount.", "error");
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
        private void ShowToast(string title, string text, string type = "success")
        {
            litToastTitle.Text = title;
            litToastText.Text = text;

            pnlToast.Visible = true;

            switch (type.ToLower())
            {
                case "warning":
                    pnlToast.CssClass = "toast-stack toast-warning";
                    break;

                case "error":
                    pnlToast.CssClass = "toast-stack toast-error";
                    break;

                case "info":
                    pnlToast.CssClass = "toast-stack toast-info";
                    break;

                default:
                    pnlToast.CssClass = "toast-stack toast-success";
                    break;
            }

            ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "HideToast",
                    @"
                    setTimeout(function () {
                        var t=document.getElementById('" + pnlToast.ClientID + @"');
                        if(t) t.style.display='none';
                    },3000);
                    ",
                    true);

        }


    }
}