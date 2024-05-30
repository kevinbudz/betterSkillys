using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.utils;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class AllyFollow : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly int duration;
        private readonly float range;
        private readonly float speed;
        private Cooldown coolDown;
        private Entity player;

        public AllyFollow(double speed, double acquireRange = 10, double range = 6, Entity player = null)
        {
            this.speed = (float)speed;
            this.acquireRange = (float)acquireRange;
            this.range = (float)range;
            this.player = player;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            player = host.GetNearestEntity(20, null, true);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;
            if (player == null)
                return;

            Vector2 vect;
            vect = new Vector2(player.X - host.X, player.Y - host.Y);
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
