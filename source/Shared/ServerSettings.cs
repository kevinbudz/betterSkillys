using System;
using System.Linq;
using System.Reflection.Metadata.Ecma335;

namespace Shared
{
    public class ServerSettings
    {
        public bool supporterOnly { get; set; } = false;
        public double lootEvent { get; set; } = 0; // .5 gives 50%
        public double expEvent { get; set; } = 0;
        public double wkndBoost { get; set; } = 0.30;
        public string logFolder { get; set; } = "undefined";
        public int maxConnections { get; set; } = 0;
        public int maxPlayers { get; set; } = 0;
        public int maxRealms { get; set; } = 1;
        public string resourceFolder { get; set; } = "undefined";
        public int restartTime { get; set; } = 0;
        public string version { get; set; } = "undefined";
        public int[] whitelist { get; set; } = new int[] { };
    }
}
