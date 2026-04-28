using System;
using System.Web.UI;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated || Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            int userId = (int)Session["UserId"];
            int cpu     = DataHelper.CountSimulations(userId, 1);
            int memory  = DataHelper.CountSimulations(userId, 2);
            int dead    = DataHelper.CountSimulations(userId, 3);

            lblTotal.Text    = (cpu + memory + dead).ToString();
            lblCpu.Text      = cpu.ToString();
            lblMemory.Text   = memory.ToString();
            lblDeadlock.Text = dead.ToString();

            var recent = DataHelper.GetSimulationsByUser(userId, top: 10);
            gvRecent.DataSource = recent;
            gvRecent.DataBind();
        }
    }
}
