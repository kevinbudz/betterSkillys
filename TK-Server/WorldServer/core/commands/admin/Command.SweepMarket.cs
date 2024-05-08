using Shared;
using Shared.database.market;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        public class SweepMarket : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "sweepmarket";

            protected override bool Process(Player player, TickTime time, string args)
            {
                DbMarketData.CleanMarket(player.GameServer.Database);
                player.SendInfo("Sweeped");
                return true;
            }
        }
    }
}
