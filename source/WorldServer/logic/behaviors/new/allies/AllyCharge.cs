using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class AllyCharge : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly float range;
        private readonly float speed;

        public AllyCharge(double speed, double acquireRange = 10, double range = 6)
        {
            this.speed = (float)speed;
            this.acquireRange = (float)acquireRange;
            this.range = (float)range;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            var entity = host.GetNearestEntity(acquireRange, false, e => (e is Enemy en && en.AllyOwnerId == -1 && !en.HasConditionEffect(ConditionEffectIndex.Invincible))); // kihnda hacky to rpevent t argeting other npcs
            if (entity == null)
            {
                Status = CycleStatus.Completed;
                return;
            }
            Status = CycleStatus.InProgress;

            var vect = new Vector2(entity.X - host.X, entity.Y - host.Y);
            if (vect.Length() > range)
            {
                vect.X -= Random.Next(-2, 2) / 2f;
                vect.Y -= Random.Next(-2, 2) / 2f;
                vect.Normalize();

                var dist = host.GetSpeed(speed) * time.BehaviourTickTime;
                host.ValidateAndMove(host.X + vect.X * dist, host.Y + vect.Y * dist);
            }
        }
    }
}
