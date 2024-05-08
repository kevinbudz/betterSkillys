using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class GroupNotExistTransition : Transition
    {
        //State storage: none

        private readonly double _dist;
        private readonly string _group;

        public GroupNotExistTransition(double dist, string targetState, string group)
            : base(targetState)
        {
            _dist = dist;
            _group = group;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (string.IsNullOrWhiteSpace(_group))
                return false;

            return host.GetNearestEntityByGroup(_dist, _group) == null;
        }
    }
}
