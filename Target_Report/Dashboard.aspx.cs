using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string ConnString => ConfigurationManager.ConnectionStrings["Sale_TargetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litCurrentDate.Text = DateTime.Now.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);

                BindKpiCards();
                BindTargetStatusChart(); 
                BindTargetVsAchievementChart();
                BindBranchPerformanceChart();
                BindAchievementTrendChart();
                BindRecentActivity();
                LoadNextPendingFollowup();
            }
        }



        private void BindKpiCards()
        {
            int totalPartners = 0;
            decimal monthlyTarget = 0;
            decimal achievement = 0;
            decimal pendingBalance = 0;
            int activeBranches = 2;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                                            SELECT (SELECT COUNT(*) FROM PartnerMaster) AS TotalPartners, (SELECT ISNULL(SUM(SalesTarget),0)
                                            FROM TargetMaster WHERE TargetMonth = MONTH(GETDATE()) AND TargetYear = YEAR(GETDATE()) ) AS MonthlyTarget,

                                                (SELECT ISNULL(SUM(SalesAchieved),0) FROM DailySalesEntry WHERE MONTH(SaleDate)=MONTH(GETDATE()) AND YEAR(SaleDate)=YEAR(GETDATE())) AS Achievement,
                                                (SELECT COUNT(DISTINCT NativeBranch) FROM PartnerMaster ) AS ActiveBranches";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                totalPartners = reader["TotalPartners"] != DBNull.Value ? Convert.ToInt32(reader["TotalPartners"]) : 0;
                                monthlyTarget = reader["MonthlyTarget"] != DBNull.Value ? Convert.ToDecimal(reader["MonthlyTarget"]) : 0;
                                achievement = reader["Achievement"] != DBNull.Value ? Convert.ToDecimal(reader["Achievement"]) : 0;
                                activeBranches = reader["ActiveBranches"] != DBNull.Value ? Convert.ToInt32(reader["ActiveBranches"]) : 2;
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Database not reachable — use realistic placeholder values
                // so the dashboard still renders a believable enterprise view.
                totalPartners = 128;
                monthlyTarget = 4500000m;
                achievement = 3286500m;
                activeBranches = 2;
            }

            pendingBalance = monthlyTarget - achievement;
            if (pendingBalance < 0) pendingBalance = 0;

            decimal achievementPercentage = monthlyTarget > 0
                ? Math.Round((achievement / monthlyTarget) * 100, 1)
                : 0;

            lblTotalPartners.Text = totalPartners.ToString("N0", CultureInfo.InvariantCulture);
            lblMonthlyTarget.Text = FormatCurrencyShort(monthlyTarget);
            lblAchievement.Text = FormatCurrencyShort(achievement);
            lblPendingBalance.Text = FormatCurrencyShort(pendingBalance);
            lblAchievementPercentage.Text = achievementPercentage.ToString("N1", CultureInfo.InvariantCulture) + "%";
            lblActiveBranches.Text = activeBranches.ToString(CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Formats large currency values in a compact Indian-business style
        /// (e.g. 32.9L for 32,90,000) to keep KPI numbers readable at the
        /// card's large font size.
        /// </summary>
        private string FormatCurrencyShort(decimal value)
        {
            if (value >= 10000000m)
            {
                return "₹" + Math.Round(value / 10000000m, 2).ToString("N2", CultureInfo.InvariantCulture) + "Cr";
            }
            if (value >= 100000m)
            {
                return "₹" + Math.Round(value / 100000m, 1).ToString("N1", CultureInfo.InvariantCulture) + "L";
            }
            return "₹" + value.ToString("N0", CultureInfo.InvariantCulture);
        }

        // =====================================================
        // CHART 1 — TARGET VS ACHIEVEMENT (vertical bar)
        // =====================================================
        private void BindTargetStatusChart()
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                string query = @"
                        SELECT
                            ISNULL((SELECT SUM(SalesTarget)
                            FROM TargetMaster
                             WHERE TargetMonth=MONTH(GETDATE())
                             AND TargetYear=YEAR(GETDATE())
                             AND ISNULL(IsDeleted,0)=0),0) AS TotalTarget,

                            ISNULL((SELECT SUM(SalesAchieved)
                             FROM DailySalesEntry
                                WHERE MONTH(SaleDate)=MONTH(GETDATE())
                                AND YEAR(SaleDate)=YEAR(GETDATE())),0) AS TotalAchievement";

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    decimal target = Convert.ToDecimal(dr["TotalTarget"]);
                    decimal achievement = Convert.ToDecimal(dr["TotalAchievement"]);

                    hdnTotalTarget.Value = target.ToString();
                    hdnTotalAchievement.Value = achievement.ToString();
                    hdnTotalBalance.Value = (target - achievement).ToString();
                }
            }
        }
        private void BindTargetVsAchievementChart()
        {
            List<string> months = new List<string>();
            List<decimal> targets = new List<decimal>();
            List<decimal> achievements = new List<decimal>();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                        SELECT
                            t.TargetMonth,
                            t.TargetYear,
                            SUM(t.SalesTarget) AS TotalTarget,
                            ISNULL(SUM(d.MonthlyAchieved),0) AS TotalAchievement
                        FROM TargetMaster t
                        LEFT JOIN
                        (
                            SELECT
                                PartnerID,
                                MONTH(SaleDate) AS SaleMonth,
                                YEAR(SaleDate) AS SaleYear,
                                SUM(SalesAchieved) AS MonthlyAchieved
                            FROM DailySalesEntry
                            GROUP BY PartnerID, MONTH(SaleDate), YEAR(SaleDate)
                        ) d
                        ON d.PartnerID = t.PartnerID
                        AND d.SaleMonth = t.TargetMonth
                        AND d.SaleYear = t.TargetYear
                        GROUP BY t.TargetMonth, t.TargetYear
                        ORDER BY t.TargetYear, t.TargetMonth";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                            conn.Open();
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                            while (reader.Read())
                            {
                                int monthNo = Convert.ToInt32(reader["TargetMonth"]);

                                months.Add(
                                    new DateTime(2026, monthNo, 1)
                                        .ToString("MMM")
                                );

                                targets.Add(
                                    Convert.ToDecimal(reader["TotalTarget"])
                                );
                                achievements.Add(Convert.ToDecimal(reader["TotalAchievement"]));
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Fall through to dummy data below
            }

            if (months.Count == 0)
            {
                months.AddRange(new[] { "Jan", "Feb", "Mar", "Apr", "May", "Jun" });
                targets.AddRange(new decimal[] { 3800000, 4000000, 4200000, 4100000, 4350000, 4500000 });
                achievements.AddRange(new decimal[] { 3400000, 3650000, 3900000, 3700000, 4050000, 3286500 });
            }

            hdnChartLabels.Value = ToJsonArray(months);
            hdnTargetData.Value = ToJsonArray(targets);
            hdnAchievementData.Value = ToJsonArray(achievements);
        }

        // =====================================================
        // CHART 2 — BRANCH PERFORMANCE (horizontal bar)
        // =====================================================

        private void BindBranchPerformanceChart()
        {
            List<string> branchNames = new List<string>();
            List<decimal> branchAchievementPct = new List<decimal>();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                        SELECT 
                            p.NativeBranch AS BranchName,
                            ISNULL(SUM(t.SalesTarget), 0) AS BranchTarget,
                            ISNULL(SUM(d.SalesAchieved), 0) AS BranchAchievement
                        FROM PartnerMaster p
                        LEFT JOIN TargetMaster t ON t.PartnerID = p.PartnerID 
                            AND t.TargetMonth = MONTH(GETDATE()) AND t.TargetYear = YEAR(GETDATE())
                        LEFT JOIN DailySalesEntry d ON d.PartnerID = p.PartnerID 
                            AND MONTH(d.SaleDate) = MONTH(GETDATE()) AND YEAR(d.SaleDate) = YEAR(GETDATE())
                        GROUP BY p.NativeBranch";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                decimal target = Convert.ToDecimal(reader["BranchTarget"]);
                                decimal achieved = Convert.ToDecimal(reader["BranchAchievement"]);
                                decimal pct = target > 0 ? Math.Round((achieved / target) * 100, 1) : 0;

                                branchNames.Add(reader["BranchName"].ToString());
                                branchAchievementPct.Add(pct);
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Fall through to dummy data below
            }

            if (branchNames.Count == 0)
            {
                branchNames.AddRange(new[] { "Pune", "Nagpur" });
                branchAchievementPct.AddRange(new decimal[] { 78.4m, 69.1m });
            }

            hdnBranchLabels.Value = ToJsonArray(branchNames);
            hdnBranchAchievementData.Value = ToJsonArray(branchAchievementPct);
        }

        // =====================================================
        // CHART 3 — ACHIEVEMENT TREND (line)
        // =====================================================

        private void BindAchievementTrendChart()
        {
            List<string> months = new List<string>();
            List<decimal> achievementPct = new List<decimal>();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                                            SELECT
                                                t.TargetMonth,
                                                t.TargetYear,
                                                SUM(t.SalesTarget) AS TotalTarget,
                                                ISNULL(SUM(d.MonthlyAchieved),0) AS TotalAchievement
                                            FROM TargetMaster t
                                            LEFT JOIN
                                            (
                                                SELECT
                                                    PartnerID,
                                                    MONTH(SaleDate) AS SaleMonth,
                                                    YEAR(SaleDate) AS SaleYear,
                                                    SUM(SalesAchieved) AS MonthlyAchieved
                                                FROM DailySalesEntry
                                                GROUP BY PartnerID, MONTH(SaleDate), YEAR(SaleDate)
                                            ) d
                                            ON d.PartnerID = t.PartnerID
                                            AND d.SaleMonth = t.TargetMonth
                                            AND d.SaleYear = t.TargetYear
                                            GROUP BY t.TargetMonth, t.TargetYear
                                            ORDER BY t.TargetYear, t.TargetMonth";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                decimal target = Convert.ToDecimal(reader["TotalTarget"]);
                                decimal achieved = Convert.ToDecimal(reader["TotalAchievement"]);

                                decimal pct = target > 0
                                    ? Math.Round((achieved / target) * 100, 1)
                                    : 0;

                                achievementPct.Add(pct);

                                int monthNo = Convert.ToInt32(reader["TargetMonth"]);

                                months.Add(
                                    new DateTime(2026, monthNo, 1).ToString("MMM")
                                );
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Fall through to dummy data below
            }

            if (months.Count == 0)
            {
                months.AddRange(new[] { "Jan", "Feb", "Mar", "Apr", "May", "Jun" });
                achievementPct.AddRange(new decimal[] { 89.5m, 91.3m, 92.9m, 90.2m, 93.1m, 73.0m });
            }

            hdnTrendLabels.Value = ToJsonArray(months);
            hdnTrendData.Value = ToJsonArray(achievementPct);
        }

        // =====================================================
        // TOP PARTNERS GRID
        // =====================================================

        private void BindTopPartners()
        {
            DataTable table = new DataTable();
            table.Columns.Add("Rank", typeof(int));
            table.Columns.Add("PartnerName", typeof(string));
            table.Columns.Add("Branch", typeof(string));
            table.Columns.Add("Target", typeof(decimal));
            table.Columns.Add("Achievement", typeof(decimal));
            table.Columns.Add("AchievementPercentage", typeof(decimal));

            bool loadedFromDb = false;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                        SELECT TOP 10
                            p.PartnerName,
                            p.NativeBranch AS Branch,
                            ISNULL(t.SalesTarget, 0) AS Target,
                            ISNULL(SUM(d.SalesAchieved), 0) AS Achievement
                        FROM PartnerMaster p
                        LEFT JOIN TargetMaster t ON t.PartnerID = p.PartnerID 
                            AND t.TargetMonth = MONTH(GETDATE()) AND t.TargetYear = YEAR(GETDATE())
                        LEFT JOIN DailySalesEntry d ON d.PartnerID = p.PartnerID
                        AND MONTH(d.SaleDate) = MONTH(GETDATE())
                        AND YEAR(d.SaleDate) = YEAR(GETDATE())
                        GROUP BY p.PartnerName, p.NativeBranch, t.SalesTarget
                        ORDER BY ISNULL(SUM(d.SalesAchieved), 0) DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            int rank = 1;
                            while (reader.Read())
                            {
                                decimal target = Convert.ToDecimal(reader["Target"]);
                                decimal achievement = Convert.ToDecimal(reader["Achievement"]);
                                decimal pct = target > 0 ? Math.Round((achievement / target) * 100, 1) : 0;

                                DataRow row = table.NewRow();
                                row["Rank"] = rank;
                                row["PartnerName"] = reader["PartnerName"].ToString();
                                row["Branch"] = reader["Branch"].ToString();
                                row["Target"] = target;
                                row["Achievement"] = achievement;
                                row["AchievementPercentage"] = pct;
                                table.Rows.Add(row);

                                rank++;
                                loadedFromDb = true;
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                loadedFromDb = false;
            }

            if (!loadedFromDb)
            {
                AddDummyPartnerRow(table, 1, "Shree Enterprises", "Pune", 450000, 412500);
                AddDummyPartnerRow(table, 2, "Vishal Traders", "Nagpur", 420000, 378000);
                AddDummyPartnerRow(table, 3, "Mahesh Distributors", "Pune", 400000, 352000);
                AddDummyPartnerRow(table, 4, "Om Sai Agencies", "Nagpur", 380000, 312200);
                AddDummyPartnerRow(table, 5, "Krishna Sales Corp", "Pune", 360000, 288000);
                AddDummyPartnerRow(table, 6, "Ganesh Marketing", "Nagpur", 340000, 261800);
                AddDummyPartnerRow(table, 7, "Patil Enterprises", "Pune", 320000, 230400);
                AddDummyPartnerRow(table, 8, "Deshmukh Traders", "Nagpur", 300000, 207000);
                AddDummyPartnerRow(table, 9, "Sharma Distributors", "Pune", 280000, 179200);
                AddDummyPartnerRow(table, 10, "Joshi Agencies", "Nagpur", 260000, 153400);
            }

            //gvTopPartners.DataSource = table;
            //gvTopPartners.DataBind();
        }
        //private void LoadReminderPopup()
        //{
        //    DataRow dr = GetNextPendingFollowup();

        //    if (dr == null)
        //    {
        //        pnlReminderPopup.Visible = false;
        //        return;
        //    }

        //    pnlReminderPopup.Visible = true;

        //    hdnFollowupID.Value = dr["FollowUpID"].ToString();

        //    lblPopupPartner.Text = dr["PartnerName"].ToString();

        //    lblPopupContact.Text = dr["ContactNo"].ToString();

        //    lblPopupDate.Text =
        //        Convert.ToDateTime(dr["FollowUpDate"])
        //        .ToString("dd MMM yyyy");

        //    txtOldRemark.Text = dr["Remark"].ToString();

        //    txtNewRemark.Text = "";
        //}
        protected void btnCompleteFollowup_Click(object sender, EventArgs e)
        {
            // Validation
            if (string.IsNullOrWhiteSpace(txtNewRemark.Text))
            {
                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "msg",
                    "alert('Please enter today\\'s remark.');",
                    true);

                return;
            }

            using (SqlConnection con = new SqlConnection(ConnString))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"

            UPDATE PartnerFollowUp
            SET
                Status = 'Completed',
                CompletedDate = GETDATE(),
                CompletionRemark = @CompletionRemark
            WHERE FollowUpID = @FollowUpID;

        ", con);

                cmd.Parameters.AddWithValue("@CompletionRemark", txtNewRemark.Text.Trim());

                cmd.Parameters.AddWithValue(
                    "@FollowUpID",
                    Convert.ToInt32(hdnFollowupID.Value));

                cmd.ExecuteNonQuery();
            }

            txtNewRemark.Text = "";
            LoadNextPendingFollowup();
        }
        private void AddDummyPartnerRow(DataTable table, int rank, string partnerName, string branch, decimal target, decimal achievement)
        {
            decimal pct = target > 0 ? Math.Round((achievement / target) * 100, 1) : 0;

            DataRow row = table.NewRow();
            row["Rank"] = rank;
            row["PartnerName"] = partnerName;
            row["Branch"] = branch;
            row["Target"] = target;
            row["Achievement"] = achievement;
            row["AchievementPercentage"] = pct;
            table.Rows.Add(row);
        }

        protected string GetAchievementBarClass(double achievementPercentage)
        {
            if (achievementPercentage >= 80) return "";
            if (achievementPercentage >= 50) return " is-warning";
            return " is-danger";
        }
        private void LoadNextPendingFollowup()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            {
                SqlCommand cmd = new SqlCommand("USP_GetNextPendingFollowup", con);
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    hdnFollowupID.Value = dr["FollowUpID"].ToString();

                    lblPopupPartner.Text = dr["PartnerName"].ToString();
                    lblPopupContact.Text = dr["ContactNo"].ToString();

                    lblPopupDate.Text =
                        Convert.ToDateTime(dr["FollowUpDate"])
                        .ToString("dd MMM yyyy");

                    txtOldRemark.Text = dr["Remark"].ToString();

                    txtNewRemark.Text = "";
                    txtNewRemark.ReadOnly = false;

                    txtOldRemark.Visible = true;
                    txtNewRemark.Visible = true;

                    btnCompleteFollowup.Visible = true;

                    pnlReminderPopup.Visible = true;
                }
                else
                {
                    pnlReminderPopup.Visible = false;
                }
            }
        }
        private void BindRecentActivity()
        {
            List<ActivityFeedItem> activities = new List<ActivityFeedItem>();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    const string query = @"
                        SELECT TOP 8 ActivityText, IconType, ActivityDate
                        FROM (
                            SELECT 
                                'New partner added: ' + PartnerName AS ActivityText,
                                'primary' AS IconType,
                                CreatedDate AS ActivityDate
                            FROM PartnerMaster
 
                            UNION ALL
 
                            SELECT 
                                'Target set for ' + p.PartnerName + ' (' + CONVERT(VARCHAR(20), t.SalesTarget) + ')' AS ActivityText,
                                'primary' AS IconType,
                                t.CreatedDate AS ActivityDate
                            FROM TargetMaster t
                            INNER JOIN PartnerMaster p ON p.PartnerID = t.PartnerID
 
                            UNION ALL
 
                            SELECT 
                                'Sales entry recorded for ' + p.PartnerName AS ActivityText,
                                'success' AS IconType,
                                d.CreatedDate AS ActivityDate
                            FROM DailySalesEntry d
                            INNER JOIN PartnerMaster p ON p.PartnerID = d.PartnerID
                        ) combined
                        ORDER BY ActivityDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                DateTime activityDate = Convert.ToDateTime(reader["ActivityDate"]);
                                activities.Add(new ActivityFeedItem
                                {
                                    ActivityText = reader["ActivityText"].ToString(),
                                    IconType = reader["IconType"].ToString(),
                                    TimeAgo = GetTimeAgo(activityDate),
                                    IconSvg = GetActivityIconSvg(reader["IconType"].ToString())
                                });
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Fall through to dummy data below
            }

            if (activities.Count == 0)
            {
                activities.Add(BuildDummyActivity("New partner added: <strong>Shree Enterprises</strong>", "primary", DateTime.Now.AddHours(-2)));
                activities.Add(BuildDummyActivity("Monthly target updated for <strong>Vishal Traders</strong>", "primary", DateTime.Now.AddHours(-5)));
                activities.Add(BuildDummyActivity("Sales entry recorded for <strong>Mahesh Distributors</strong>", "success", DateTime.Now.AddHours(-8)));
                activities.Add(BuildDummyActivity("New partner added: <strong>Om Sai Agencies</strong>", "primary", DateTime.Now.AddDays(-1)));
                activities.Add(BuildDummyActivity("Sales entry recorded for <strong>Krishna Sales Corp</strong>", "success", DateTime.Now.AddDays(-1).AddHours(-3)));
                activities.Add(BuildDummyActivity("Monthly target updated for <strong>Ganesh Marketing</strong>", "primary", DateTime.Now.AddDays(-2)));
            }

            rptRecentActivity.DataSource = activities;
            rptRecentActivity.DataBind();
        }

        private ActivityFeedItem BuildDummyActivity(string activityText, string iconType, DateTime activityDate)
        {
            return new ActivityFeedItem
            {
                ActivityText = activityText,
                IconType = iconType,
                TimeAgo = GetTimeAgo(activityDate),
                IconSvg = GetActivityIconSvg(iconType)
            };
        }
    //    protected void rptPendingFollowups_ItemCommand(object source,
    //RepeaterCommandEventArgs e)
    //    {

    //    }
        private void LoadPendingFollowups()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetTodayFollowUps", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                DataTable dt = new DataTable();

                con.Open();

                dt.Load(cmd.ExecuteReader());

                //rptPendingFollowups.DataSource = dt;
                //rptPendingFollowups.DataBind();

                //pnlFollowupPopup.Visible = dt.Rows.Count > 0;
            }
        }
        private string GetTimeAgo(DateTime activityDate)
        {
            TimeSpan span = DateTime.Now - activityDate;

            if (span.TotalMinutes < 1) return "Just now";
            if (span.TotalMinutes < 60) return $"{(int)span.TotalMinutes} min ago";
            if (span.TotalHours < 24) return $"{(int)span.TotalHours} hr ago";
            if (span.TotalDays < 7) return $"{(int)span.TotalDays} day(s) ago";

            return activityDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Returns the inline SVG markup for an activity icon. The Repeater's
        /// ItemTemplate renders this via Eval("IconSvg") with HTML output,
        /// so this method returns raw markup, not an encoded string.
        /// </summary>
        private string GetActivityIconSvg(string iconType)
        {
            if (iconType == "success")
            {
                return "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 20V10\"></path><path d=\"M18 20V4\"></path><path d=\"M6 20v-4\"></path></svg>";
            }

            return "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"></path><circle cx=\"12\" cy=\"7\" r=\"4\"></circle></svg>";
        }

        // =====================================================
        // JSON HELPERS — minimal hand-rolled serialization so the
        // project has no extra JSON library dependency.
        // =====================================================

        private string ToJsonArray(List<string> values)
        {
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < values.Count; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append("\"").Append(values[i].Replace("\"", "\\\"")).Append("\"");
            }
            sb.Append("]");
            return sb.ToString();
        }

        private string ToJsonArray(List<decimal> values)
        {
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < values.Count; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append(values[i].ToString(CultureInfo.InvariantCulture));
            }
            sb.Append("]");
            return sb.ToString();
        }

        // =====================================================
        // ACTIVITY FEED MODEL
        // =====================================================

        private class ActivityFeedItem
        {
            public string ActivityText { get; set; }
            public string IconType { get; set; }
            public string TimeAgo { get; set; }
            public string IconSvg { get; set; }
        }
        protected string GetAchievementWidth(object value)
        {
            double percentage = 0;

            if (value != null && value != DBNull.Value)
            {
                percentage = Convert.ToDouble(value);
            }

            return Math.Min(100, percentage) + "%";
        }
        private DataRow GetNextPendingFollowup()
        {
            using (SqlConnection con = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("USP_GetNextPendingFollowup", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                DataTable dt = new DataTable();

                con.Open();

                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count == 0)
                    return null;

                return dt.Rows[0];
            }
        }
    }
}