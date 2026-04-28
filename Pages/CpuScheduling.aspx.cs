using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class CpuScheduling : Page
    {
        private List<ProcessInput> Processes
        {
            get => ViewState["Processes"] as List<ProcessInput> ?? DefaultProcesses();
            set => ViewState["Processes"] = value;
        }

        private static List<ProcessInput> DefaultProcesses() => new List<ProcessInput>
        {
            new ProcessInput { PID = "P1", Arrival = 0, Burst = 5, Priority = 1 },
            new ProcessInput { PID = "P2", Arrival = 1, Burst = 3, Priority = 2 },
            new ProcessInput { PID = "P3", Arrival = 2, Burst = 7, Priority = 1 }
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) { Response.Redirect("~/Pages/Login.aspx"); return; }

            if (!IsPostBack)
            {
                Processes = DefaultProcesses();
                LoadHistory();
                BindRepeater();
            }
        }

        private void BindRepeater()
        {
            rptProcesses.DataSource = Processes;
            rptProcesses.DataBind();
        }

        private List<ProcessInput> ReadFromRepeater()
        {
            var list = new List<ProcessInput>();
            foreach (RepeaterItem item in rptProcesses.Items)
            {
                if (item.ItemType != ListItemType.Item && item.ItemType != ListItemType.AlternatingItem)
                    continue;
                int arrival = 0, burst = 1, priority = 1;
                int.TryParse(((TextBox)item.FindControl("txtArrival")).Text,  out arrival);
                int.TryParse(((TextBox)item.FindControl("txtBurst")).Text,    out burst);
                int.TryParse(((TextBox)item.FindControl("txtPriority")).Text, out priority);
                list.Add(new ProcessInput
                {
                    PID      = ((TextBox)item.FindControl("txtPID")).Text.Trim(),
                    Arrival  = arrival,
                    Burst    = Math.Max(1, burst),
                    Priority = Math.Max(1, priority)
                });
            }
            return list;
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            var current = ReadFromRepeater();
            current.Add(new ProcessInput
            {
                PID = "P" + (current.Count + 1), Arrival = 0, Burst = 1, Priority = 1
            });
            Processes = current;
            BindRepeater();
        }

        protected void rptProcesses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                var current = ReadFromRepeater();
                int idx = Convert.ToInt32(e.CommandArgument);
                if (current.Count > 1) current.RemoveAt(idx);
                Processes = current;
                BindRepeater();
            }
        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            var procs = ReadFromRepeater();
            Processes = procs;

            string algo = ddlAlgorithm.SelectedValue;
            ScheduleResult result;

            switch (algo)
            {
                case "SJF":      result = CpuAlgorithms.RunSJF(procs); break;
                case "RR":
                    int q = 2;
                    int.TryParse(txtQuantum.Text, out q);
                    result = CpuAlgorithms.RunRoundRobin(procs, Math.Max(1, q));
                    break;
                case "Priority": result = CpuAlgorithms.RunPriority(procs); break;
                default:         result = CpuAlgorithms.RunFCFS(procs); break;
            }

            ViewState["LastResult"] = result;
            ViewState["LastAlgo"]   = algo;

            litGantt.Text     = RenderGantt(result.Gantt);
            gvResults.DataSource = result.Rows;
            gvResults.DataBind();
            lblAvgTAT.Text    = result.AvgTurnaround.ToString("F2");
            lblAvgWT.Text     = result.AvgWaiting.ToString("F2");
            pnlResults.Visible = true;
            lblSaved.Visible   = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var result = ViewState["LastResult"] as ScheduleResult;
            var algo   = ViewState["LastAlgo"]  as string;
            if (result == null) return;

            int userId = (int)Session["UserId"];
            DataHelper.SaveSimulation(userId, 1, SerializeResult(result));

            lblSaved.Visible = true;
            LoadHistory();
        }

        private void LoadHistory()
        {
            if (Session["UserId"] == null) return;
            int userId  = (int)Session["UserId"];
            var history = DataHelper.GetSimulationsByUser(userId, 1, top: 10);
            if (history.Count > 0)
            {
                gvHistory.DataSource = history;
                gvHistory.DataBind();
                pnlHistory.Visible = true;
            }
        }

        private static string RenderGantt(System.Collections.Generic.List<GanttBlock> gantt)
        {
            if (gantt == null || gantt.Count == 0) return "";
            int total = gantt[gantt.Count - 1].End;
            if (total == 0) return "";

            var sb = new StringBuilder();
            sb.Append("<table class=\"table table-bordered table-sm text-center\" style=\"table-layout:fixed\">");
            sb.Append("<tr>");
            foreach (var b in gantt)
            {
                int pct = Math.Max(1, (b.End - b.Start) * 100 / total);
                sb.AppendFormat("<td style=\"width:{0}%\"><strong>{1}</strong><br/><small>{2}-{3}</small></td>",
                    pct, b.PID, b.Start, b.End);
            }
            sb.Append("</tr></table>");
            return sb.ToString();
        }

        private static string SerializeProcesses(List<ProcessInput> procs)
        {
            var parts = new List<string>();
            foreach (var p in procs)
                parts.Add($"{p.PID},{p.Arrival},{p.Burst},{p.Priority}");
            return string.Join(";", parts);
        }

        private static string SerializeResult(ScheduleResult r)
        {
            var sb = new StringBuilder();
            foreach (var row in r.Rows)
                sb.AppendFormat("{0}:{1}:{2}:{3}:{4}|", row.PID, row.Arrival, row.Burst, row.Finish, row.Waiting);
            sb.AppendFormat("AvgTAT={0},AvgWT={1}", r.AvgTurnaround, r.AvgWaiting);
            return sb.ToString();
        }
    }
}
