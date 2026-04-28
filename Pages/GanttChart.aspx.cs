using System;
using System.Web.UI;

namespace IOSMSystem
{
    public partial class GanttChart : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }
        }
    }
}
