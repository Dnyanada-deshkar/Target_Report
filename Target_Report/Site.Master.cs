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
            if (Session["AdminUsername"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                HighlightActiveNavLink();
                LoadSignedInUser();
            }
        }

        /// <summary>
        /// Applies the "is-active" CSS class to the sidebar link matching
        /// the current page, so the shell visually reflects where the
        /// user is across Dashboard, Partner Master, etc.
        /// </summary>
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
            else if (string.Equals(currentPage, "TargetMaster.aspx", StringComparison.OrdinalIgnoreCase))
            {
                lnkNavTargetMaster.CssClass = "sidebar-nav-link is-active";
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
            string sessionUser = Session["AdminUsername"] as string;

            if (!string.IsNullOrEmpty(sessionUser))
            {
                litUserName.Text = sessionUser;
                litUserInitials.Text = GetInitials(sessionUser);
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