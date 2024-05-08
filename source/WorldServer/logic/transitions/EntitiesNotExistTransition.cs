using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class EntitiesNotExistsTransition : Transition
    {
        //State storage: none

        private readonly double _dist;
        private readonly ushort[] _targets;

        public EntitiesNotExistsTransition(double dist, string targetState, params string[] targets)
            : base(targetState)
        {
            _dist = dist;

            if (targets.Length <= 0)
                return;

            _targets = targets.Select(Behavior.GetObjType).ToArray();
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (_targets == null)
                return false;

            return _targets.All(t => host.GetNearestEntity(_dist, t) == null);
        }
    }
}
