using System;
using System.Linq;
using System.Text;
using System.Web.UI;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class MemoryManagement : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) { Response.Redirect("~/Pages/Login.aspx"); return; }
            if (!IsPostBack) LoadHistory();
        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            string strategy = ddlStrategy.SelectedValue;
            lblError.Visible = false;

            int[] processSizes = ParseInts(txtProcesses.Text);
            if (processSizes.Length == 0)
            {
                lblError.Text = "Enter at least one process size.";
                lblError.Visible = true;
                return;
            }

            if (strategy == "Paging")
            {
                int totalMem = 64, pageSize = 4;
                int.TryParse(txtTotalMemory.Text, out totalMem);
                int.TryParse(txtPageSize.Text,    out pageSize);
                if (pageSize < 1) pageSize = 1;
                if (totalMem < pageSize) { lblError.Text = "Total memory must be >= page size."; lblError.Visible = true; return; }

                var result = MemoryAlgorithms.RunPaging(totalMem, pageSize, processSizes);
                ViewState["LastResult"]   = "paging";
                ViewState["LastInput"]    = $"{totalMem}|{pageSize}|{txtProcesses.Text}";
                ViewState["LastStrategy"] = strategy;

                litMap.Text = RenderFrameTable(result);
                gvResults.DataSource = result.Allocations.Select(a => new AllocResult {
                    ProcessName   = a.ProcessName,
                    ProcessSize   = a.ProcessSize,
                    BlockNo       = a.Allocated ? a.PagesNeeded : (int?)null,
                    BlockSize     = null,
                    Fragmentation = a.Allocated ? (a.PagesNeeded * pageSize - a.ProcessSize) : (int?)null,
                    Allocated     = a.Allocated
                }).ToList();
                gvResults.DataBind();
            }
            else
            {
                int[] blockSizes = ParseInts(txtBlocks.Text);
                if (blockSizes.Length == 0)
                {
                    lblError.Text = "Enter at least one block size.";
                    lblError.Visible = true;
                    return;
                }

                var result = MemoryAlgorithms.RunContiguous(blockSizes, processSizes, strategy);
                ViewState["LastResult"]   = "contiguous";
                ViewState["LastInput"]    = $"{txtBlocks.Text}|{txtProcesses.Text}";
                ViewState["LastStrategy"] = strategy;

                litMap.Text = RenderBlockTable(result);
                gvResults.DataSource = result.Allocations;
                gvResults.DataBind();
            }

            pnlResults.Visible = true;
            lblSaved.Visible   = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserId"];
            string strategy = ViewState["LastStrategy"] as string ?? ddlStrategy.SelectedValue;
            string input    = ViewState["LastInput"]    as string ?? "";
            DataHelper.SaveSimulation(userId, 2, strategy);
            lblSaved.Visible = true;
            LoadHistory();
        }

        private void LoadHistory()
        {
            if (Session["UserId"] == null) return;
            int userId  = (int)Session["UserId"];
            var history = DataHelper.GetSimulationsByUser(userId, 2, top: 10);
            if (history.Count > 0)
            {
                gvHistory.DataSource = history;
                gvHistory.DataBind();
                pnlHistory.Visible = true;
            }
        }

        private static int[] ParseInts(string text)
        {
            return text.Split(',')
                .Select(s => { int v; return int.TryParse(s.Trim(), out v) && v > 0 ? v : 0; })
                .Where(v => v > 0).ToArray();
        }

        private static string RenderBlockTable(ContiguousResult result)
        {
            var sb = new StringBuilder();
            sb.Append("<table class=\"table table-bordered table-sm text-center\">");
            sb.Append("<thead class=\"table-light\"><tr><th>Block #</th><th>Size (KB)</th><th>Allocated To</th></tr></thead><tbody>");
            foreach (var b in result.Memory)
            {
                string allocated = b.ProcessName ?? "Free";
                sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>",
                    b.BlockNo, b.Size, allocated);
            }
            sb.Append("</tbody></table>");
            return sb.ToString();
        }

        private static string RenderFrameTable(PagingResult result)
        {
            var sb = new StringBuilder();
            sb.Append("<table class=\"table table-bordered table-sm text-center\">");
            sb.Append("<thead class=\"table-light\"><tr>");
            for (int i = 0; i < result.TotalFrames; i++)
                sb.AppendFormat("<th>F{0}</th>", i);
            sb.Append("</tr></thead><tbody><tr>");
            for (int i = 0; i < result.TotalFrames; i++)
                sb.AppendFormat("<td>{0}</td>", result.FrameContents[i] ?? "Free");
            sb.Append("</tr></tbody></table>");
            return sb.ToString();
        }
    }
}
