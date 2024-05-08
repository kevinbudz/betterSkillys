using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class NoEntityWithinTransition : Transition
    {
        //State storage: none

        private readonly int _dist;

        public NoEntityWithinTransition(int dist, string targetState)
            : base(targetState)
        {
            _dist = dist;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            return !host.AnyEnemyNearby(_dist) && !host.AnyPlayerNearby(_dist);
        }
    }
}
