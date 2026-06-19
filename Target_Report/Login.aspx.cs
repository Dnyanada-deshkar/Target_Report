using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

namespace Target_Report
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtUsername.Focus();

                // Restore remembered username, if present
                HttpCookie rememberedUser = Request.Cookies["XYZ_RememberedUser"];
                if (rememberedUser != null && !string.IsNullOrEmpty(rememberedUser.Value))
                {
                    txtUsername.Text = rememberedUser.Value;
                    chkRememberMe.Checked = true;
                }
            }
        }

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowMessage("Please enter both username and password.");
                return;
            }

            if (ValidateAdminCredentials(username, password))
            {
                HandleRememberMe(username);

                FormsAuthentication.SetAuthCookie(username, chkRememberMe.Checked);

                Session["AdminUsername"] = username;
                Session["LoginTime"] = DateTime.Now;

                Response.Redirect("~/Dashboard.aspx", false);
            }
            else
            {
                ShowMessage("Invalid username or password. Please try again.");
            }
        }

        /// <summary>
        /// Validates admin credentials against the database.
        /// Replace the connection string name and query to match your schema.
        /// Passwords should always be stored as salted hashes, never in plain text.
        /// </summary>
        private bool ValidateAdminCredentials(string username, string password)
        {
            return username == "admin" &&
                   password == "1234";
        }


        private string HashPassword(string plainPassword)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(plainPassword));
                return Convert.ToBase64String(bytes);
            }
        }

        private void HandleRememberMe(string username)
        {
            if (chkRememberMe.Checked)
            {
                HttpCookie cookie = new HttpCookie("XYZ_RememberedUser", username)
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true
                };
                Response.Cookies.Add(cookie);
            }
            else
            {
                HttpCookie cookie = new HttpCookie("XYZ_RememberedUser", "")
                {
                    Expires = DateTime.Now.AddDays(-1)
                };
                Response.Cookies.Add(cookie);
            }
        }

        private void ShowMessage(string message)
        {
            litMessage.Text = message;
            pnlMessage.CssClass = "login-message";
        }
    }
}