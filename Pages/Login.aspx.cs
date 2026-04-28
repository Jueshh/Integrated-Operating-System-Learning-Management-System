using System;
using System.Web.Security;
using System.Web.UI;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["registered"] == "1")
            {
                lblSuccess.Text    = "Account created. Please log in.";
                lblSuccess.Visible = true;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblError.Text    = "Please enter username and password.";
                lblError.Visible = true;
                return;
            }

            var user = DataHelper.GetUserByUsername(username);
            if (user == null || !DataHelper.VerifyPassword(user.Password, password))
            {
                lblError.Text    = "Invalid username or password.";
                lblError.Visible = true;
                return;
            }

            Session["UserId"]   = user.UserID;
            Session["Username"] = user.Username;
            FormsAuthentication.SetAuthCookie(user.Username, false);
            Response.Redirect("~/Pages/Dashboard.aspx");
        }
    }
}
