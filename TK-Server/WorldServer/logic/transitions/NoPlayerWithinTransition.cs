using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class NoPlayerWithinTransition : Transition
    {
        //State storage: none

        private readonly double dist;

        public NoPlayerWithinTransition(double dist, string targetState)
            : base(targetState)
        {
            this.dist = dist;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            return host.GetNearestEntity(dist, null) == null;
        }
    }
}
