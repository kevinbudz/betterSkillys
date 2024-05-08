using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class ConditionEffectBehavior : Behavior
    {
        private readonly bool perm;
        private int duration;
        private ConditionEffectIndex effect;

        public ConditionEffectBehavior(ConditionEffectIndex effect, bool perm = false, int duration = -1)
        {
            this.effect = effect;
            this.perm = perm;
            this.duration = duration;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            host.ApplyConditionEffect(effect, duration);
        }

        protected override void OnStateExit(Entity host, TickTime time, ref object state)
        {
            if (!perm)
                host.RemoveCondition(effect);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
