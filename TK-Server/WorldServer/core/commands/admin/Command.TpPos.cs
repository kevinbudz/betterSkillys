using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class TpPos : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "tppos";

            protected override bool Process(Player player, TickTime time, string args)
            {
                string[] coordinates = args.Split(' ');
                if (coordinates.Length != 2)
                {
                    player.SendError("Invalid coordinates!");
                    return false;
                }

                if (!int.TryParse(coordinates[0], out int x) ||
                    !int.TryParse(coordinates[1], out int y))
                {
                    player.SendError("Invalid coordinates!");
                    return false;
                }

                player.SetNewbiePeriod();
                player.TeleportPosition(time, x + 0.5f, y + 0.5f, true);
                return true;
            }
        }
    }
}
