using System;
using System.Web.UI;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirm  = txtConfirm.Text;

            if (username.Length < 3)
            {
                ShowError("Username must be at least 3 characters."); return;
            }
            if (password.Length < 12)
            {
                ShowError("Password must be at least 12 characters."); return;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[A-Z]"))
            {
                ShowError("Password must contain at least one uppercase letter."); return;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[a-z]"))
            {
                ShowError("Password must contain at least one lowercase letter."); return;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[0-9]"))
            {
                ShowError("Password must contain at least one number."); return;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[^a-zA-Z0-9]"))
            {
                ShowError("Password must contain at least one symbol (e.g. !@#$%)."); return;
            }
            if (password != confirm)
            {
                ShowError("Passwords do not match."); return;
            }
            if (DataHelper.UsernameExists(username))
            {
                ShowError("Username is already taken."); return;
            }

            DataHelper.CreateUser(username, DataHelper.HashPassword(password));
            Response.Redirect("~/Pages/Login.aspx?registered=1");
        }

        private void ShowError(string msg)
        {
            lblError.Text    = msg;
            lblError.Visible = true;
        }
    }
}
