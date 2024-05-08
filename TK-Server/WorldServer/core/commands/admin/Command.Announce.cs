using System;
using Shared;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.worlds;
using WorldServer.logic.loot;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Announce : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "announce";

            protected override bool Process(Player player, TickTime time, string args)
            {
                player.GameServer.ChatManager.Announce(player, args);
                return true;
            }
        }

        internal class ServerAnnounce : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "sannounce";

            protected override bool Process(Player player, TickTime time, string args)
            {
                player.GameServer.ChatManager.ServerAnnounce(args);
                return true;
            }
        }
    }
}
