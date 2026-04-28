using System.Collections.Generic;

namespace IOSMSystem.Models
{
    public class SafeStep
    {
        public int    StepNo     { get; set; }
        public string Process    { get; set; }
        public string WorkBefore { get; set; }
        public string WorkAfter  { get; set; }
    }

    public class BankersResult
    {
        public bool           IsSafe       { get; set; }
        public string         SafeSequence { get; set; }
        public List<SafeStep> Steps        { get; set; }
        public int[][]        NeedMatrix   { get; set; }
        public string         ErrorMessage { get; set; }
    }

    public static class BankersAlgorithm
    {
        public static BankersResult Run(int[] totalResources, int[][] allocation, int[][] max, int n, int m)
        {
            // Validate: need = max - allocation >= 0
            var need = new int[n][];
            for (int i = 0; i < n; i++)
            {
                need[i] = new int[m];
                for (int j = 0; j < m; j++)
                {
                    need[i][j] = max[i][j] - allocation[i][j];
                    if (need[i][j] < 0)
                        return new BankersResult
                        {
                            IsSafe = false,
                            Steps  = new List<SafeStep>(),
                            ErrorMessage = $"P{i}: Allocation[{j}] exceeds Max[{j}]."
                        };
                }
            }

            // Available = Total - sum of allocations
            var work = (int[])totalResources.Clone();
            for (int i = 0; i < n; i++)
                for (int j = 0; j < m; j++)
                    work[j] -= allocation[i][j];

            for (int j = 0; j < m; j++)
                if (work[j] < 0)
                    return new BankersResult
                    {
                        IsSafe = false,
                        Steps  = new List<SafeStep>(),
                        ErrorMessage = $"Total allocations exceed total resources for R{j}."
                    };

            var finish   = new bool[n];
            var sequence = new List<string>();
            var steps    = new List<SafeStep>();
            bool progress = true;

            while (progress)
            {
                progress = false;
                for (int i = 0; i < n; i++)
                {
                    if (finish[i]) continue;
                    bool canRun = true;
                    for (int j = 0; j < m; j++)
                        if (need[i][j] > work[j]) { canRun = false; break; }

                    if (canRun)
                    {
                        var before = (int[])work.Clone();
                        for (int j = 0; j < m; j++) work[j] += allocation[i][j];
                        finish[i] = true;
                        string pname = "P" + i;
                        sequence.Add(pname);
                        steps.Add(new SafeStep
                        {
                            StepNo     = steps.Count + 1,
                            Process    = pname,
                            WorkBefore = "[" + string.Join(", ", before) + "]",
                            WorkAfter  = "[" + string.Join(", ", work)   + "]"
                        });
                        progress = true;
                    }
                }
            }

            bool isSafe = true;
            for (int i = 0; i < n; i++) if (!finish[i]) { isSafe = false; break; }

            return new BankersResult
            {
                IsSafe       = isSafe,
                SafeSequence = isSafe ? string.Join(" → ", sequence) : "No safe sequence",
                Steps        = steps,
                NeedMatrix   = need
            };
        }
    }
}
