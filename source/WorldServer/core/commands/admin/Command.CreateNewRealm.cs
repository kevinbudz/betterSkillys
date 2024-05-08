using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class CreateNewRealmCommand : Command
        {
            public override string CommandName => "createrealm";
            public override RankingType RankRequirement => RankingType.Admin;

            protected override bool Process(Player player, TickTime time, string args)
            {
                player.GameServer.WorldManager.Nexus.PortalMonitor.CreateNewRealm();
                return true;
            }
        }
    }
}
