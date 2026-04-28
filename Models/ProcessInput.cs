using System;

namespace IOSMSystem.Models
{
    [Serializable]
    public class ProcessInput
    {
        public string PID      { get; set; }
        public int    Arrival  { get; set; }
        public int    Burst    { get; set; }
        public int    Priority { get; set; }
    }
}
