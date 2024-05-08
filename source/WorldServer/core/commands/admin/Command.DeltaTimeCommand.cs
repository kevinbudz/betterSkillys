using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class DeltaTimeCommand : Command
        {
            public override string CommandName => "deltatime";

            protected override bool Process(Player player, TickTime time, string args)
            {
                player.DeltaTime = !player.DeltaTime;
                return true;
            }
        }
    }
}
