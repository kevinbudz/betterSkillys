using System.Linq;
using Shared;
using Shared.utils;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Kick : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "kick";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var client = player.GameServer.ConnectionManager.Clients
                    .Keys.Where(_ => _.Account.Name.EqualsIgnoreCase(args) && !_.Account.Hidden)
                    .SingleOrDefault();
                if (client != default)
                {
                    client.Disconnect("KickCommand");
                    player.SendInfo("Player disconnected!");
                    return true;
                }

                player.SendError($"Player '{args}' could not be found!");
                return false;
            }
        }
    }
}
