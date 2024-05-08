using Newtonsoft.Json;
using System.IO;
using Shared.isc.data;

namespace Shared
{
    public class DbInfo
    {
        public string auth { get; set; } = "";
        public string host { get; set; } = "127.0.0.1";
        public int index { get; set; } = 0;
        public int port { get; set; } = 6379;
    }

    public enum ServerType
    {
        Account,
        World,
        Consumer
    }

    public sealed class ServerInfo
    {
        public string address { get; set; } = "127.0.0.1";
        public bool adminOnly { get; set; } = false;
        public bool testing { get; set; } = false;
        public string bindAddress { get; set; } = "127.0.0.1";
        public string instanceId { get; set; } = "";
        public float latitude { get; set; } = 0;
        public float longitude { get; set; } = 0;
        public int maxPlayers { get; set; } = 0;
        public string name { get; set; } = "Test Server";
        public PlayerList playerList { get; set; } = new PlayerList();
        public int players { get; set; } = 0;
        public int port { get; set; } = 2050;
        public ServerType type { get; set; } = ServerType.Account;

        public bool IsJustStarted() => players == 0 && maxPlayers == 0;
    }

    public class ServerConfig
    {
        public DbInfo dbInfo { get; set; } = new DbInfo();
        public ServerInfo serverInfo { get; set; } = new ServerInfo();
        public ServerSettings serverSettings { get; set; } = new ServerSettings();
        public static ServerConfig ReadFile(string fileName)
        {
            using (var r = new StreamReader(fileName))
                return ReadJson(r.ReadToEnd());
        }

        public static ServerConfig ReadJson(string json) => JsonConvert.DeserializeObject<ServerConfig>(json);
    }
}
