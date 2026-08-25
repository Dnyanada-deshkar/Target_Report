using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Target_Report
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                HighlightActiveNavLink();
                LoadSignedInUser();
            }

            ApplyRoleBasedNavigation();
        }

        
        private void HighlightActiveNavLink()
        {
            string currentPage = System.IO.Path.GetFileName(Request.Path);

            if (string.Equals(currentPage, "Dashboard.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkNavDashboard.CssClass = "sidebar-nav-link is-active";
            }
            else if (string.Equals(currentPage, "PartnerMaster.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkNavPartnerMaster.CssClass = "sidebar-nav-link is-active";
            }
            else if (string.Equals(currentPage, "DailySalesEntry.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkNavSalesEntry.CssClass = "sidebar-nav-link is-active";
            }
            else if (string.Equals(currentPage, "Reports.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkNavReports.CssClass = "sidebar-nav-link is-active";
            }
            else if (string.Equals(currentPage, "BrandMaster.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkBrandMaster.CssClass = "sidebar-nav-link is-active";
            }
        }

        /// <summary>
        /// Populates the topbar user block from the authenticated session.
        /// Replace with real session/identity lookups once authentication
        /// is wired through FormsAuthentication / the Login page.
        /// </summary>
        private void LoadSignedInUser()
        {
            string role = Session["UserRole"] as string;

            if (role == "Admin")
            {
                string username = Session["AdminUsername"] as string;

                litUserName.Text =
                    string.IsNullOrEmpty(username)
                        ? "admin"
                        : username;

                litUserInitials.Text =
                    GetInitials(litUserName.Text);
            }
            else if (role == "Executive")
            {
                string executiveName =
                    Session["ExecutiveName"] as string;

                litUserName.Text =
                    string.IsNullOrEmpty(executiveName)
                        ? "Executive"
                        : executiveName;

                litUserInitials.Text =
                    GetInitials(litUserName.Text);
            }
        }

        private void ApplyRoleBasedNavigation()
        {
            string role = Session["UserRole"] as string;

            bool isAdmin = role == "Admin";
            bool isExecutive = role == "Executive";
            pnlMastersSection.Visible = isAdmin;

            // ============================================
            // COMMON MODULES
            // ============================================

            lnkNavDashboard.Visible = true;
            lnkNavSalesEntry.Visible = true;
            lnkNavReports.Visible = true;

            // ADMIN ONLY MODULES

            lnkNavPartnerMaster.Visible = isAdmin;
            lnkBrandMaster.Visible = isAdmin;
            lnkNavSalesExecutiveMaster.Visible = isAdmin;

            // ROLE DISPLAY IN TOP BAR

            if (isAdmin)
            {
                litUserRole.Text = "Director";
            }
            else if (isExecutive)
            {
                litUserRole.Text = "Sales Executive";
            }
        }
             




        private string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "AD";

            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
            {
                return parts[0].Length >= 2 ? parts[0].Substring(0, 2).ToUpper() : parts[0].ToUpper();
            }

            return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Default.aspx");
        }
    }
}