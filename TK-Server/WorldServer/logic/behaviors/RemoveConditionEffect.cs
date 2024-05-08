using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class RemoveConditionalEffect : Behavior
    {
        private readonly ConditionEffectIndex _effect;

        public RemoveConditionalEffect(ConditionEffectIndex effect) => _effect = effect;

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => host.RemoveCondition(_effect);

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
