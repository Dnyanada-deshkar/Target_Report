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

        private void ShowToast(string title, string text, bool isError = false)
        {
            litToastTitle.Text = title;
            litToastText.Text = text;
            pnlToast.Visible = true;
            pnlToast.CssClass = isError ? "toast-stack is-error" : "toast-stack";
        }

       
    }
}