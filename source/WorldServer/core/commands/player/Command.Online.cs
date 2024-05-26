using Shared;
using Shared.isc.data;
using System.Linq;
using System.Text;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Online : Command
        {
            public override string CommandName => "online";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var playerSvr = player.GameServer.Configuration.serverInfo.name;
                var servers = player.GameServer.InterServerManager.GetServerList();
                var s = servers.Where(_ => _.type != ServerType.Account);
                var sb = new StringBuilder($"On '{s.Sum(_ => _.players)}', there are {string.Join(", ", s.Select(_ => _.name))} online.");
                player.SendInfo(sb.ToString());
                return true;
            }
        }
    }
}