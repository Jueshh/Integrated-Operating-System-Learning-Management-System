namespace IOSMSystem.Models
{
    public class Simulation
    {
        public int    SimulationID { get; set; }
        public int    UserID       { get; set; }
        public int    ModuleType   { get; set; }   // 1=CPU, 2=Memory, 3=Deadlock

        public string ModuleName =>
            ModuleType == 1 ? "CPU Scheduling" :
            ModuleType == 2 ? "Memory Management" :
            ModuleType == 3 ? "Deadlock" : ModuleType.ToString();
    }
}
