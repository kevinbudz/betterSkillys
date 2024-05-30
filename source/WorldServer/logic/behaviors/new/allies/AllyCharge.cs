using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.utils;
using WorldServer.core.worlds;
using System.Linq;

namespace WorldServer.logic.behaviors
{
    internal class AllyCharge : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly float range;
        private readonly float speed;
        private Entity entity;

        public AllyCharge(double speed, double acquireRange = 10, double range = 6, Entity entity = null)
        {
            this.speed = (float)speed;
            this.acquireRange = (float)acquireRange;
            this.range = (float)range;
            this.entity = entity;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var entities = host.GetNearestEntities(10, 0, false);
            entity = entities.First();
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;
            if (entity == null)
                return;
            Vector2 vect;
            vect = new Vector2(entity.X - host.X, entity.Y - host.Y);
            if (vect.Length() > range)
            {
                vect.X -= Random.Next(-2, 2) / 2f;
                vect.Y -= Random.Next(-2, 2) / 2f;
                vect.Normalize();

                var dist = host.GetSpeed(speed) * time.BehaviourTickTime;
                host.ValidateAndMove(host.X + vect.X * dist, host.Y + vect.Y * dist);
            }
            else
                return;
        }
    }
}
