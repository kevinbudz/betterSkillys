using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class SwirlingMistDeathParticles : Behavior
    {
        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var entity = Entity.Resolve(host.GameServer, "SwirlingMist Particles");
            entity.Move(host.X, host.Y);

            host.World.StartNewTimer(1000, (w, t) => w.LeaveWorld(entity));
            host.World.EnterWorld(entity);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
