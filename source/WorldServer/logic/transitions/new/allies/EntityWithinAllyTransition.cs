using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class EntityWithinAllyTransition : Transition
    {
        //State storage: none

        private readonly double _dist;

        public EntityWithinAllyTransition(double dist,string targetState)
            : base(targetState)
        {
            _dist = dist;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            return host.GetNearestEntity(_dist, false, e => (e is Enemy en && en.AllyOwnerId == -1 && !en.HasConditionEffect(ConditionEffectIndex.Invincible))) != null;
        }
    }
}
