using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    public class OnDeathBehavior : Behavior
    {
        private readonly Behavior behavior;

        public OnDeathBehavior(Behavior behavior) => this.behavior = behavior;

        public override void OnDeath(Entity host, ref TickTime time)
        {
            behavior.OnStateEntry(host, time);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
