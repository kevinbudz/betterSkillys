using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class EntityHpLessTransition : Transition
    {
        //State storage: none

        private readonly double _dist;
        private readonly string _entity;
        private readonly double _threshold;

        public EntityHpLessTransition(double dist, string entity, double threshold, string targetState)
            : base(targetState)
        {
            _dist = dist;
            _entity = entity;
            _threshold = threshold;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            var entity = host.GetNearestEntityByName(_dist, _entity);

            if (entity == null)
                return false;
            if (entity is Enemy en)
                return en.Health / en.MaxHealth < _threshold;
            else
                return false;
        }
    }
}
