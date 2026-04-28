using System;

namespace IOSMSystem.Models
{
    public class Result
    {
        public int      ResultID     { get; set; }
        public int      SimulationID { get; set; }
        public string   DataOutput   { get; set; }
        public DateTime CreatedAt    { get; set; }
    }
}
