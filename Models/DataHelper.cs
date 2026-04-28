using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Helpers;

namespace IOSMSystem.Models
{
    public static class DataHelper
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["iolsms_db"].ConnectionString;

        // Password Helpers
        public static string HashPassword(string password)            => Crypto.HashPassword(password);
        public static bool   VerifyPassword(string hash, string pwd)  => Crypto.VerifyHashedPassword(hash, pwd);

        // User Operations
        public static User GetUserByUsername(string username)
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT * FROM users WHERE Username = @u", conn);
                cmd.Parameters.AddWithValue("@u", username);
                using (var r = cmd.ExecuteReader())
                    if (r.Read()) return MapUser(r);
            }
            return null;
        }

        public static bool UsernameExists(string username) => ScalarBool(
            "SELECT COUNT(1) FROM users WHERE Username = @p", username);

        public static void CreateUser(string username, string passwordHash)
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                var cmd = new SqlCommand(
                    "INSERT INTO users (UserID, Username, Password) VALUES ((SELECT ISNULL(MAX(UserID),f)+1 FROM users), @u, @p)", conn);
                cmd.Parameters.AddWithValue("@u", username);
                cmd.Parameters.AddWithValue("@p", passwordHash);
                cmd.ExecuteNonQuery();
            }
        }

        // Simulation Operations
        public static int SaveSimulation(int userId, int moduleType, string outputData)
        {
            if (outputData != null && outputData.Length > 255)
                outputData = outputData.Substring(0, 255);

            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                int simId = (int)new SqlCommand(
                    "SELECT ISNULL(MAX(SimulationID),0)+1 FROM simulations", conn).ExecuteScalar();

                var cmd = new SqlCommand(
                    "INSERT INTO simulations (SimulationID, UserID, ModuleType) VALUES (@sid, @uid, @mt)", conn);
                cmd.Parameters.AddWithValue("@sid", simId);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@mt",  moduleType);
                cmd.ExecuteNonQuery();

                int resId = (int)new SqlCommand(
                    "SELECT ISNULL(MAX(ResultID),0)+1 FROM results", conn).ExecuteScalar();

                var cmd2 = new SqlCommand(
                    "INSERT INTO results (ResultID, SimulationID, DataOutput) VALUES (@rid, @sid, @out)", conn);
                cmd2.Parameters.AddWithValue("@rid", resId);
                cmd2.Parameters.AddWithValue("@sid", simId);
                cmd2.Parameters.AddWithValue("@out", outputData ?? "");
                cmd2.ExecuteNonQuery();
                return simId;
            }
        }

        public static List<Simulation> GetSimulationsByUser(int userId,
            int? moduleType = null, int top = 20)
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string where = moduleType.HasValue ? "AND ModuleType = @mt " : "";
                var cmd = new SqlCommand(
                    $"SELECT TOP {top} * FROM simulations WHERE UserID = @uid {where}ORDER BY SimulationID DESC",
                    conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                if (moduleType.HasValue)
                    cmd.Parameters.AddWithValue("@mt", moduleType.Value);

                var list = new List<Simulation>();
                using (var r = cmd.ExecuteReader())
                    while (r.Read()) list.Add(MapSim(r));
                return list;
            }
        }

        public static int CountSimulations(int userId, int? moduleType = null)
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string sql = moduleType.HasValue
                    ? "SELECT COUNT(1) FROM simulations WHERE UserID = @uid AND ModuleType = @mt"
                    : "SELECT COUNT(1) FROM simulations WHERE UserID = @uid";
                var cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                if (moduleType.HasValue)
                    cmd.Parameters.AddWithValue("@mt", moduleType.Value);
                return (int)cmd.ExecuteScalar();
            }
        }

        // Private Mappers
        private static User MapUser(IDataReader data) => new User
        {
            UserID   = (int)data["UserID"],
            Username = data["Username"].ToString(),
            Password = data["Password"].ToString()
        };

        private static Simulation MapSim(IDataReader r) => new Simulation
        {
            SimulationID = (int)r["SimulationID"],
            UserID       = r["UserID"]     == System.DBNull.Value ? 0 : (int)r["UserID"],
            ModuleType   = r["ModuleType"] == System.DBNull.Value ? 0 : (int)r["ModuleType"]
        };

        private static bool ScalarBool(string sql, string param)
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                var cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@p", param);
                return (int)cmd.ExecuteScalar() > 0;
            }
        }
    }
}
