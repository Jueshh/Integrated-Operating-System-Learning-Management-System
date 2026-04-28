using System;
using System.Web.Security;
using System.Web.UI;

namespace IOSMSystem
{
    public partial class AppMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Context.User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
            lblUser.Text = Context.User.Identity.Name;

            string cssPath = ResolveUrl("~/Content/dark.css");
            long ticks = System.IO.File.GetLastWriteTimeUtc(Server.MapPath("~/Content/dark.css")).Ticks;
            litDarkCss.Text = "<link href=\"" + cssPath + "?v=" + ticks + "\" rel=\"stylesheet\" />";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Pages/Login.aspx");
        }
    }
}
