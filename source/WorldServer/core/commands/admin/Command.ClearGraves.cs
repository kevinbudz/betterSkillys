using Shared;
using WorldServer.core.objects.containers;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class ClearGraves : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "cleargraves";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var total = 0;
                foreach (var entry in player.World.StaticObjects)
                {
                    var entity = entry.Value;
                    if (entity is Container || entity.ObjectDesc == null)
                        continue;

                    if (entity.ObjectDesc.IdName.StartsWith("Gravestone") && entity.DistTo(player) < 15d)
                    {
                        player.World.LeaveWorld(entity);
                        total++;
                    }
                }

                player.SendInfo($"{total} gravestone{(total > 1 ? "s" : "")} removed!");
                return true;
            }
        }
    }
}
