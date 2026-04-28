using System;
using System.Collections.Generic;
using System.Linq;

namespace IOSMSystem.Models
{
    [Serializable]
    public class GanttBlock
    {
        public string PID   { get; set; }
        public int    Start { get; set; }
        public int    End   { get; set; }
    }

    [Serializable]
    public class ProcessResult
    {
        public string PID        { get; set; }
        public int    Arrival    { get; set; }
        public int    Burst      { get; set; }
        public int    Start      { get; set; }
        public int    Finish     { get; set; }
        public int    Turnaround { get; set; }
        public int    Waiting    { get; set; }
    }

    [Serializable]
    public class ScheduleResult
    {
        public List<GanttBlock>    Gantt        { get; set; }
        public List<ProcessResult> Rows         { get; set; }
        public double              AvgTurnaround { get; set; }
        public double              AvgWaiting    { get; set; }
    }

    public static class CpuAlgorithms
    {
        public static ScheduleResult RunFCFS(List<ProcessInput> procs)
        {
            var sorted = procs.OrderBy(p => p.Arrival).ThenBy(p => p.PID).ToList();
            int time = 0;
            var gantt = new List<GanttBlock>();
            var rows  = new List<ProcessResult>();

            foreach (var p in sorted)
            {
                if (time < p.Arrival) time = p.Arrival;
                int start  = time;
                int finish = time + p.Burst;
                gantt.Add(new GanttBlock { PID = p.PID, Start = start, End = finish });
                rows.Add(new ProcessResult
                {
                    PID = p.PID, Arrival = p.Arrival, Burst = p.Burst,
                    Start = start, Finish = finish,
                    Turnaround = finish - p.Arrival,
                    Waiting    = start  - p.Arrival
                });
                time = finish;
            }
            return Build(gantt, rows);
        }

        public static ScheduleResult RunSJF(List<ProcessInput> procs)
        {
            var pending = procs.Select(p => new ProcessInput
            {
                PID = p.PID, Arrival = p.Arrival, Burst = p.Burst, Priority = p.Priority
            }).ToList();

            int time = 0;
            var gantt = new List<GanttBlock>();
            var rows  = new List<ProcessResult>();

            while (pending.Count > 0)
            {
                var available = pending.Where(x => x.Arrival <= time).ToList();
                if (!available.Any())
                {
                    time = pending.Min(x => x.Arrival);
                    continue;
                }
                var p     = available.OrderBy(x => x.Burst).ThenBy(x => x.Arrival).First();
                int start  = time;
                int finish = time + p.Burst;
                gantt.Add(new GanttBlock { PID = p.PID, Start = start, End = finish });
                rows.Add(new ProcessResult
                {
                    PID = p.PID, Arrival = p.Arrival, Burst = p.Burst,
                    Start = start, Finish = finish,
                    Turnaround = finish - p.Arrival,
                    Waiting    = start  - p.Arrival
                });
                time = finish;
                pending.Remove(p);
            }
            return Build(gantt, rows);
        }

        public static ScheduleResult RunRoundRobin(List<ProcessInput> procs, int quantum)
        {
            var queue = procs.OrderBy(p => p.Arrival)
                             .Select(p => new { p.PID, p.Arrival, p.Burst, Remaining = p.Burst })
                             .ToList();

            var remaining  = queue.Select(p => p.Burst).ToArray();
            var startTime  = new Dictionary<string, int>();
            var finishTime = new Dictionary<string, int>();

            var readyQueue = new Queue<int>();
            int time = 0, arrived = 0;
            var gantt = new List<GanttBlock>();

            // enqueue processes that have arrived
            while (arrived < queue.Count && queue[arrived].Arrival <= time)
                readyQueue.Enqueue(arrived++);

            if (readyQueue.Count == 0 && queue.Count > 0)
            {
                time = queue[0].Arrival;
                readyQueue.Enqueue(arrived++);
            }

            while (readyQueue.Count > 0)
            {
                int i   = readyQueue.Dequeue();
                int run = Math.Min(quantum, remaining[i]);

                if (!startTime.ContainsKey(queue[i].PID))
                    startTime[queue[i].PID] = time;

                gantt.Add(new GanttBlock { PID = queue[i].PID, Start = time, End = time + run });
                time        += run;
                remaining[i] -= run;

                // enqueue newly arrived
                while (arrived < queue.Count && queue[arrived].Arrival <= time)
                    readyQueue.Enqueue(arrived++);

                if (remaining[i] > 0)
                    readyQueue.Enqueue(i);
                else
                    finishTime[queue[i].PID] = time;
            }

            var rows = procs.Select(p => new ProcessResult
            {
                PID        = p.PID,
                Arrival    = p.Arrival,
                Burst      = p.Burst,
                Start      = startTime.ContainsKey(p.PID)  ? startTime[p.PID]  : 0,
                Finish     = finishTime.ContainsKey(p.PID) ? finishTime[p.PID] : 0,
                Turnaround = finishTime.ContainsKey(p.PID) ? finishTime[p.PID] - p.Arrival : 0,
                Waiting    = finishTime.ContainsKey(p.PID) ? finishTime[p.PID] - p.Arrival - p.Burst : 0
            }).ToList();

            return Build(gantt, rows);
        }

        public static ScheduleResult RunPriority(List<ProcessInput> procs)
        {
            var pending = procs.Select(p => new ProcessInput
            {
                PID = p.PID, Arrival = p.Arrival, Burst = p.Burst, Priority = p.Priority
            }).ToList();

            int time = 0;
            var gantt = new List<GanttBlock>();
            var rows  = new List<ProcessResult>();

            while (pending.Count > 0)
            {
                var available = pending.Where(x => x.Arrival <= time).ToList();
                if (!available.Any())
                {
                    time = pending.Min(x => x.Arrival);
                    continue;
                }
                var p     = available.OrderBy(x => x.Priority).ThenBy(x => x.Arrival).First();
                int start  = time;
                int finish = time + p.Burst;
                gantt.Add(new GanttBlock { PID = p.PID, Start = start, End = finish });
                rows.Add(new ProcessResult
                {
                    PID = p.PID, Arrival = p.Arrival, Burst = p.Burst,
                    Start = start, Finish = finish,
                    Turnaround = finish - p.Arrival,
                    Waiting    = start  - p.Arrival
                });
                time = finish;
                pending.Remove(p);
            }
            return Build(gantt, rows);
        }

        private static ScheduleResult Build(List<GanttBlock> gantt, List<ProcessResult> rows)
        {
            double avgTAT = rows.Count > 0 ? rows.Average(r => r.Turnaround) : 0;
            double avgWT  = rows.Count > 0 ? rows.Average(r => r.Waiting)    : 0;
            return new ScheduleResult
            {
                Gantt         = gantt,
                Rows          = rows,
                AvgTurnaround = Math.Round(avgTAT, 2),
                AvgWaiting    = Math.Round(avgWT,  2)
            };
        }
    }
}
