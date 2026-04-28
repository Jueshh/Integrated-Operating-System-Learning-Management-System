using System;
using System.Collections.Generic;
using System.Linq;

namespace IOSMSystem.Models
{
    public class MemBlock
    {
        public int    BlockNo     { get; set; }
        public int    Size        { get; set; }
        public string ProcessName { get; set; }  // null = free
    }

    public class AllocResult
    {
        public string ProcessName   { get; set; }
        public int    ProcessSize   { get; set; }
        public int?   BlockNo       { get; set; }
        public int?   BlockSize     { get; set; }
        public int?   Fragmentation { get; set; }
        public bool   Allocated     { get; set; }
    }

    public class ContiguousResult
    {
        public List<MemBlock>   Memory      { get; set; }
        public List<AllocResult> Allocations { get; set; }
    }

    public class PageAlloc
    {
        public string    ProcessName    { get; set; }
        public int       ProcessSize    { get; set; }
        public int       PagesNeeded    { get; set; }
        public List<int> FramesAssigned { get; set; }
        public bool      Allocated      { get; set; }
    }

    public class PagingResult
    {
        public string[]      FrameContents { get; set; }  // null = free, else process name
        public List<PageAlloc> Allocations { get; set; }
        public int           PageSize      { get; set; }
        public int           TotalFrames   { get; set; }
    }

    public static class MemoryAlgorithms
    {
        public static ContiguousResult RunContiguous(int[] blockSizes, int[] processSizes, string strategy)
        {
            var blocks = blockSizes.Select((s, i) => new MemBlock
            {
                BlockNo = i + 1, Size = s, ProcessName = null
            }).ToList();

            var allocations = new List<AllocResult>();

            for (int pi = 0; pi < processSizes.Length; pi++)
            {
                int psize = processSizes[pi];
                string pname = "P" + (pi + 1);

                var free = blocks.Where(b => b.ProcessName == null && b.Size >= psize).ToList();

                if (!free.Any())
                {
                    allocations.Add(new AllocResult
                    {
                        ProcessName = pname, ProcessSize = psize,
                        Allocated = false
                    });
                    continue;
                }

                MemBlock chosen;
                if (strategy == "FirstFit")
                    chosen = free.First();
                else if (strategy == "BestFit")
                    chosen = free.OrderBy(b => b.Size).First();
                else
                    chosen = free.OrderByDescending(b => b.Size).First();

                chosen.ProcessName = pname;
                allocations.Add(new AllocResult
                {
                    ProcessName   = pname,
                    ProcessSize   = psize,
                    BlockNo       = chosen.BlockNo,
                    BlockSize     = chosen.Size,
                    Fragmentation = chosen.Size - psize,
                    Allocated     = true
                });
            }

            return new ContiguousResult { Memory = blocks, Allocations = allocations };
        }

        public static PagingResult RunPaging(int totalMemory, int pageSize, int[] processSizes)
        {
            int totalFrames = totalMemory / pageSize;
            var frameContents = new string[totalFrames];  // null = free

            var freeFrames = Enumerable.Range(0, totalFrames).ToList();
            var allocations = new List<PageAlloc>();

            for (int pi = 0; pi < processSizes.Length; pi++)
            {
                int psize = processSizes[pi];
                string pname = "P" + (pi + 1);
                int pages = (int)Math.Ceiling((double)psize / pageSize);

                if (freeFrames.Count < pages)
                {
                    allocations.Add(new PageAlloc
                    {
                        ProcessName = pname, ProcessSize = psize,
                        PagesNeeded = pages, FramesAssigned = new List<int>(),
                        Allocated = false
                    });
                    continue;
                }

                var assigned = freeFrames.Take(pages).ToList();
                freeFrames.RemoveRange(0, pages);
                foreach (int f in assigned) frameContents[f] = pname;

                allocations.Add(new PageAlloc
                {
                    ProcessName    = pname,
                    ProcessSize    = psize,
                    PagesNeeded    = pages,
                    FramesAssigned = assigned,
                    Allocated      = true
                });
            }

            return new PagingResult
            {
                FrameContents = frameContents,
                Allocations   = allocations,
                PageSize      = pageSize,
                TotalFrames   = totalFrames
            };
        }
    }
}
