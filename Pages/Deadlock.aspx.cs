using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using IOSMSystem.Models;

namespace IOSMSystem
{
    public partial class Deadlock : Page
    {
        private int N => int.TryParse(hdnN.Value, out int n) ? Math.Max(1, Math.Min(10, n)) : 5;
        private int M => int.TryParse(hdnM.Value, out int m) ? Math.Max(1, Math.Min(6, m)) : 3;

        protected void Page_Init(object sender, EventArgs e)
        {
            // Read n,m from posted form (available before ViewState loads)
            int n = 5, m = 3;
            if (Request.Form[hdnN.UniqueID] != null)
                int.TryParse(Request.Form[hdnN.UniqueID], out n);
            if (Request.Form[hdnM.UniqueID] != null)
                int.TryParse(Request.Form[hdnM.UniqueID], out m);
            n = Math.Max(1, Math.Min(10, n));
            m = Math.Max(1, Math.Min(6, m));

            bool tablesVisible = Request.Form["pnlTablesVisible"] == "1"
                || (ViewState["TablesBuilt"] as bool? == true);

            if (tablesVisible || IsPostBack)
                BuildMatrixUI(n, m);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) { Response.Redirect("~/Pages/Login.aspx"); return; }
            if (!IsPostBack) LoadHistory();
        }

        private void BuildMatrixUI(int n, int m)
        {
            phAllocation.Controls.Add(MakeMatrixTable("alloc", n, m));
            phMax.Controls.Add(MakeMatrixTable("max", n, m));
            pnlTables.Visible = true;
            lblMLabel.Text = m.ToString();
        }

        private static Table MakeMatrixTable(string prefix, int n, int m)
        {
            var tbl = new Table { CssClass = "table table-bordered table-sm" };

            // Header row
            var hdr = new TableHeaderRow { TableSection = TableRowSection.TableHeader };
            hdr.Cells.Add(new TableHeaderCell { Text = "Process", CssClass = "table-light" });
            for (int j = 0; j < m; j++)
                hdr.Cells.Add(new TableHeaderCell { Text = "R" + j, CssClass = "table-light" });
            tbl.Rows.Add(hdr);

            // Data rows
            for (int i = 0; i < n; i++)
            {
                var row = new TableRow();
                row.Cells.Add(new TableCell { Text = "P" + i });
                for (int j = 0; j < m; j++)
                {
                    var cell = new TableCell();
                    var tb = new TextBox
                    {
                        ID = prefix + "_" + i + "_" + j,
                        Text = "0",
                        CssClass = "form-control form-control-sm",
                        Width = Unit.Pixel(55)
                    };
                    cell.Controls.Add(tb);
                    row.Cells.Add(cell);
                }
                tbl.Rows.Add(row);
            }
            return tbl;
        }

        protected void btnBuild_Click(object sender, EventArgs e)
        {
            int n = 5, m = 3;
            int.TryParse(txtN.Text, out n);
            int.TryParse(txtM.Text, out m);
            hdnN.Value = Math.Max(1, Math.Min(10, n)).ToString();
            hdnM.Value = Math.Max(1, Math.Min(6, m)).ToString();
            ViewState["TablesBuilt"] = true;

            // Controls were already added in Page_Init with old values; rebuild for new values
            phAllocation.Controls.Clear();
            phMax.Controls.Clear();
            BuildMatrixUI(N, M);
        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            int n = N, m = M;

            // Parse total resources
            var totalParts = txtTotal.Text.Trim().Split(new[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (totalParts.Length != m)
            {
                lblError.Text = $"Enter exactly {m} total resource values.";
                lblError.Visible = true; return;
            }
            var total = new int[m];
            for (int j = 0; j < m; j++)
                if (!int.TryParse(totalParts[j], out total[j]) || total[j] < 0)
                {
                    lblError.Text = "Total resources must be non-negative integers.";
                    lblError.Visible = true; return;
                }

            // Read allocation and max matrices
            var allocation = ReadMatrix("alloc", n, m);
            var max = ReadMatrix("max", n, m);

            var result = BankersAlgorithm.Run(total, ToJagged(allocation, n, m), ToJagged(max, n, m), n, m);

            if (result.ErrorMessage != null)
            {
                lblError.Text = result.ErrorMessage;
                lblError.Visible = true;
                pnlResults.Visible = false;
                return;
            }

            // Verdict
            if (result.IsSafe)
                litVerdict.Text = $"<div class=\"alert alert-success\"><strong>SAFE STATE</strong> - Safe sequence: {result.SafeSequence}</div>";
            else
                litVerdict.Text = "<div class=\"alert alert-danger\"><strong>UNSAFE STATE</strong> - Deadlock may occur.</div>";

            litNeed.Text = RenderNeedMatrix(result.NeedMatrix, n, m);

            gvSteps.DataSource = result.Steps;
            gvSteps.DataBind();
            pnlResults.Visible = true;
            lblSaved.Visible = false;

            ViewState["LastTotal"] = total;
            ViewState["LastAllocation"] = allocation;
            ViewState["LastMax"] = max;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserId"];
            string input = $"n={N},m={M},total={txtTotal.Text}";
            DataHelper.SaveSimulation(userId, 3, input);
            lblSaved.Visible = true;
            LoadHistory();
        }

        private void LoadHistory()
        {
            if (Session["UserId"] == null) return;
            int userId = (int)Session["UserId"];
            var history = DataHelper.GetSimulationsByUser(userId, 3, top: 10);
            if (history.Count > 0)
            {
                gvHistory.DataSource = history;
                gvHistory.DataBind();
                pnlHistory.Visible = true;
            }
        }

        private int[,] ReadMatrix(string prefix, int n, int m)
        {
            var matrix = new int[n, m];
            var ph = (prefix == "alloc") ? phAllocation : phMax;
            for (int i = 0; i < n; i++)
                for (int j = 0; j < m; j++)
                {
                    var tb = ph.FindControl(prefix + "_" + i + "_" + j) as TextBox;
                    if (tb != null) int.TryParse(tb.Text, out matrix[i, j]);
                }
            return matrix;
        }

        private static int[][] ToJagged(int[,] matrix, int n, int m)
        {
            var jagged = new int[n][];
            for (int i = 0; i < n; i++)
            {
                jagged[i] = new int[m];
                for (int j = 0; j < m; j++) jagged[i][j] = matrix[i, j];
            }
            return jagged;
        }

        private static string RenderNeedMatrix(int[][] need, int n, int m)
        {
            var sb = new StringBuilder();
            sb.Append("<table class=\"table table-bordered table-sm\">");
            sb.Append("<thead class=\"table-light\"><tr><th>Process</th>");
            for (int j = 0; j < m; j++) sb.AppendFormat("<th>R{0}</th>", j);
            sb.Append("</tr></thead><tbody>");
            for (int i = 0; i < n; i++)
            {
                sb.AppendFormat("<tr><td>P{0}</td>", i);
                for (int j = 0; j < m; j++)
                    sb.AppendFormat("<td>{0}</td>", need[i][j]);
                sb.Append("</tr>");
            }
            sb.Append("</tbody></table>");
            return sb.ToString();
        }
    }
}
