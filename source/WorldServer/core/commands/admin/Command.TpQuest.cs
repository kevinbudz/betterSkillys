using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class TpQuest : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "tq";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (player.Quest == null)
                {
                    player.SendError("Player does not have a quest!");
                    return false;
                }

                if (!player.CanTeleport())
                {
                    player.SendError($"Teleport is on cooldown");
                    return true;
                }

                player.ResetNewbiePeriod();

                var x = player.Quest.X;
                var y = player.Quest.Y;

                if (player.Quest.ObjectDesc.IdName.Contains("Hermit"))
                    y += 6;

                player.TeleportPosition(time, x, y);
                player.SendInfo($"Teleported to Quest Location: ({x}, {y})");
                return true;
            }
        }
    }
}
