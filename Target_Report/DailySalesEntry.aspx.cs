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
        // ─────────────────────────────────────────────────────────────────────
        //  Connection string — matches the rest of the project
        // ─────────────────────────────────────────────────────────────────────
        private string ConnString =>
            ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        // ─────────────────────────────────────────────────────────────────────
        //  PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateYearDropdown();
                SetDefaultMonthYear();
                LoadPartners();
                LoadTargetData();
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        //  DROPDOWN POPULATION
        // ─────────────────────────────────────────────────────────────────────

        private void PopulateYearDropdown()
        {
            int current = DateTime.Today.Year;
            ddlYear.Items.Clear();
            for (int y = current - 2; y <= current + 2; y++)
                ddlYear.Items.Add(new ListItem(y.ToString(), y.ToString()));
        }

        private void SetDefaultMonthYear()
        {
            ddlMonth.SelectedValue = DateTime.Today.Month.ToString();
            ddlYear.SelectedValue = DateTime.Today.Year.ToString();
        }

        private void LoadPartners()
        {
            const string sql = @"
                SELECT PartnerID, PartnerName
                FROM   PartnerMaster
                ORDER  BY PartnerName ASC";

            using (var conn = new SqlConnection(ConnString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                conn.Open();
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                ddlPartner.Items.Clear();
                ddlPartner.Items.Add(new ListItem("— Select Partner —", "0"));

                foreach (DataRow row in dt.Rows)
                    ddlPartner.Items.Add(
                        new ListItem(row["PartnerName"].ToString(),
                                     row["PartnerID"].ToString()));
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        //  CORE: LOAD TARGET DATA
        //  Called on every dropdown change and after each save.
        // ─────────────────────────────────────────────────────────────────────

        private void LoadTargetData()
        {
            // Reset all conditional panels
            pnlKpiSection.Visible = false;
            pnlNoTarget.Visible = false;
            pnlAlreadyAchieved.Visible = false;
            pnlEntryForm.Visible = false;

            hdnTargetId.Value = "0";
            hdnCurrentBalance.Value = "0";

            int partnerID = int.Parse(ddlPartner.SelectedValue);
            if (partnerID == 0) return;   // no partner selected yet

            int month = int.Parse(ddlMonth.SelectedValue);
            int year = int.Parse(ddlYear.SelectedValue);

            const string sql = @"
                SELECT TargetID, SalesTarget, TargetBalance
                FROM   TargetMaster
                WHERE  PartnerID   = @PartnerID
                  AND  TargetMonth = @Month
                  AND  TargetYear  = @Year
                  AND  IsDeleted   = 0";

            DataTable dt;
            using (var conn = new SqlConnection(ConnString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@PartnerID", partnerID);
                cmd.Parameters.AddWithValue("@Month", month);
                cmd.Parameters.AddWithValue("@Year", year);

                conn.Open();
                dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
            }

            if (dt.Rows.Count == 0)
            {
                pnlNoTarget.Visible = true;
                return;
            }

            DataRow r = dt.Rows[0];

            int targetID = Convert.ToInt32(r["TargetID"]);
            decimal salesTarget = Convert.ToDecimal(r["SalesTarget"]);
            decimal balance = Convert.ToDecimal(r["TargetBalance"]);

            // Store for postback use
            hdnTargetId.Value = targetID.ToString();
            hdnCurrentBalance.Value = balance.ToString("F2", CultureInfo.InvariantCulture);

            // KPI calculations
            decimal achievement = salesTarget - balance;
            decimal achievementPct = salesTarget > 0
                ? Math.Round((achievement / salesTarget) * 100m, 1)
                : 0m;

            // Populate KPI cards
            lblKpiTarget.Text = FormatINRDisplay(salesTarget);
            lblKpiBalance.Text = FormatINRDisplay(balance);
            lblKpiAchievement.Text = FormatINRDisplay(achievement);
            lblKpiAchievePct.Text = achievementPct.ToString("N1", CultureInfo.InvariantCulture) + "%";
            litAchievePct.Text = achievementPct.ToString("N1", CultureInfo.InvariantCulture) + "%";
            litProgressPct.Text = achievementPct.ToString("N1", CultureInfo.InvariantCulture) + "%";

            pnlKpiSection.Visible = true;

            // Populate read-only entry fields
            txtSalesTarget.Text = FormatINRDisplay(salesTarget);
            txtCurrentBalance.Text = FormatINRDisplay(balance);
            txtDailySale.Text = string.Empty;
            txtNewBalance.Text = string.Empty;

            // Show achieved banner or entry form
            if (balance <= 0)
            {
                pnlAlreadyAchieved.Visible = true;
            }
            else
            {
                // Derive partner name for form mode label
                string partnerName = ddlPartner.SelectedItem != null
                    ? ddlPartner.SelectedItem.Text
                    : string.Empty;
                string monthName = ddlMonth.SelectedItem != null
                    ? ddlMonth.SelectedItem.Text
                    : string.Empty;

                litFormMode.Text = partnerName + " · " + monthName + " " + year;
                pnlEntryForm.Visible = true;
                ClearFormMessage();
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        //  DROPDOWN CHANGE EVENTS
        // ─────────────────────────────────────────────────────────────────────

        protected void ddlPartner_SelectedIndexChanged(object sender, EventArgs e)
            => LoadTargetData();

        protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
            => LoadTargetData();

        protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
            => LoadTargetData();

        // ─────────────────────────────────────────────────────────────────────
        //  CUSTOM VALIDATOR — amount > 0
        // ─────────────────────────────────────────────────────────────────────

        protected void cvDailySale_ServerValidate(object source, ServerValidateEventArgs args)
        {
            decimal v;
            args.IsValid = decimal.TryParse(args.Value, out v) && v > 0;
        }

        // ─────────────────────────────────────────────────────────────────────
        //  SAVE
        // ─────────────────────────────────────────────────────────────────────

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // ── 1. Validate TargetID ──────────────────────────────────────────
            int targetID = int.Parse(hdnTargetId.Value);
            if (targetID == 0)
            {
                ShowFormMessage("No valid target is selected. Please select a partner and period.");
                return;
            }

            // ── 2. Parse sale amount ──────────────────────────────────────────
            decimal dailySale;
            if (!decimal.TryParse(txtDailySale.Text.Trim(), out dailySale) || dailySale <= 0)
            {
                ShowFormMessage("Please enter a valid sale amount greater than zero.");
                return;
            }

            // ── 3. Re-fetch current balance from DB to avoid stale ViewState ──
            decimal currentBalance = FetchCurrentBalance(targetID);
            if (currentBalance < 0)
            {
                ShowFormMessage("Could not retrieve the current balance. Please try again.");
                return;
            }

            // ── 4. Guard: already achieved ────────────────────────────────────
            if (currentBalance == 0)
            {
                ShowToast("Target Already Achieved",
                    "The target balance is already zero. No further entries can be saved.", isError: true);
                LoadTargetData();
                return;
            }

            // ── 5. Calculate new balance (floor at 0 — never negative) ────────
            decimal newBalance = currentBalance - dailySale;
            if (newBalance < 0) newBalance = 0;

            // ── 6. Update TargetMaster ────────────────────────────────────────
            //       Only TargetBalance and ModifiedDate are touched.
            //       SalesTarget is NEVER modified.
            const string updateSql = @"
                UPDATE TargetMaster
                SET    TargetBalance = @NewBalance,
                       ModifiedDate  = GETDATE()
                WHERE  TargetID      = @TargetID
                  AND  IsDeleted     = 0";

            using (var conn = new SqlConnection(ConnString))
            using (var cmd = new SqlCommand(updateSql, conn))
            {
                cmd.Parameters.AddWithValue("@NewBalance", newBalance);
                cmd.Parameters.AddWithValue("@TargetID", targetID);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows == 0)
                {
                    ShowFormMessage("Update failed — the target record could not be found or has been deleted.");
                    return;
                }
            }

            // ── 7. Success ────────────────────────────────────────────────────
            string partnerName = ddlPartner.SelectedItem != null
                ? ddlPartner.SelectedItem.Text : "Partner";

            ShowToast("Daily Sale Saved",
                $"Sale of {FormatINRDisplay(dailySale)} recorded for {partnerName}. New balance: {FormatINRDisplay(newBalance)}.");

            // Refresh all KPIs and balances from DB
            LoadTargetData();
        }

        // ─────────────────────────────────────────────────────────────────────
        //  CLEAR
        // ─────────────────────────────────────────────────────────────────────

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtDailySale.Text = string.Empty;
            txtNewBalance.Text = string.Empty;
            ClearFormMessage();
        }

        // ─────────────────────────────────────────────────────────────────────
        //  DATA HELPERS
        // ─────────────────────────────────────────────────────────────────────

        /// <summary>
        /// Reads the current TargetBalance fresh from the database.
        /// Returns -1 if the record is not found.
        /// </summary>
        private decimal FetchCurrentBalance(int targetID)
        {
            const string sql = @"
                SELECT TargetBalance
                FROM   TargetMaster
                WHERE  TargetID  = @TargetID
                  AND  IsDeleted = 0";

            using (var conn = new SqlConnection(ConnString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@TargetID", targetID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value)
                    ? -1m
                    : Convert.ToDecimal(result);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        //  UI HELPERS
        // ─────────────────────────────────────────────────────────────────────

        /// <summary>
        /// Formats a decimal using hi-IN culture: 500000 -> ₹5,00,000
        /// </summary>
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

        private void ShowFormMessage(string message)
        {
            litFormMessage.Text = message;
            pnlFormMessage.Visible = true;
        }

        private void ClearFormMessage()
        {
            litFormMessage.Text = string.Empty;
            pnlFormMessage.Visible = false;
        }
    }
}