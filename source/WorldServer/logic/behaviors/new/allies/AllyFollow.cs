using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.utils;
using WorldServer.core.worlds;
using System.Collections.Generic;

namespace WorldServer.logic.behaviors
{
    internal class AllyFollow : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly float range;
        private readonly float speed;

        public AllyFollow(double speed, double acquireRange = 10, double range = 6)
        {
            this.speed = (float)speed;
            this.acquireRange = (float)acquireRange;
            this.range = (float)range;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            var player = host.World.Players.GetValueOrDefault(host.AllyOwnerId);
            if (player == null)
                return;
            var vect = new Vector2(player.X - host.X, player.Y - host.Y);
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
