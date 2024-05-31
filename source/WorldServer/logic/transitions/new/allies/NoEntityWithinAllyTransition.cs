using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class NoEntityWithinAllyTransition : Transition
    {
        //State storage: none

        private readonly double _dist;
        private readonly bool _players;

        public NoEntityWithinAllyTransition(double dist, bool players, string targetState)
            : base(targetState)
        {
            _dist = dist;
            _players = players;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (_players)
                return host.GetNearestEntity(_dist, null) == null;
            return host.GetNearestEntity(_dist, false, e => (e is Enemy en && en.AllyOwnerId == -1 && !en.HasConditionEffect(ConditionEffectIndex.Invincible))) == null;
        }
    }
}
