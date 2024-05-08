using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class Orbit : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly float radius;
        private readonly float radiusVariance;
        private readonly float speed;
        private readonly float speedVariance;
        private bool? orbitClockwise;
        private ushort? target;

        public Orbit(double speed, double radius, double acquireRange = 10, string target = null, double speedVariance = 1.0, double radiusVariance = 1.0, bool? orbitClockwise = false)
        {
            this.speed = (float)speed;
            this.radius = (float)radius;
            this.acquireRange = (float)acquireRange;
            this.target = target == null ? null : GetObjType(target);
            this.speedVariance = (float)speedVariance;
            this.radiusVariance = (float)radiusVariance;
            this.orbitClockwise = orbitClockwise;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            int orbitDir;

            if (orbitClockwise == null)
                orbitDir = Random.Next(1, 3) == 1 ? 1 : -1;
            else
                orbitDir = (bool)orbitClockwise ? 1 : -1;

            state = new OrbitState()
            {
                Speed = speed + speedVariance * (float)(Random.NextDouble() * 2 - 1),
                Radius = radius + radiusVariance * (float)(Random.NextDouble() * 2 - 1),
                Direction = orbitDir
            };
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var s = (OrbitState)state;

            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            var entity = host.AttackTarget ?? host.GetNearestEntity(acquireRange, target);

            if (entity != null)
            {
                var angle = host.Y == entity.Y && host.X == entity.X
                    ? Math.Atan2(host.Y - entity.Y + (Random.NextDouble() * 2 - 1), host.X - entity.X + (Random.NextDouble() * 2 - 1))
                    : Math.Atan2(host.Y - entity.Y, host.X - entity.X);
                var angularSpd = s.Direction * host.GetSpeed(s.Speed) / s.Radius;

                angle += angularSpd * time.DeltaTime;

                var x = entity.X + Math.Cos(angle) * s.Radius;
                var y = entity.Y + Math.Sin(angle) * s.Radius;
                var vect = new Vector2((float)x, (float)y) - new Vector2(host.X, host.Y);
                vect.Normalize();
                vect *= host.GetSpeed(s.Speed) * time.DeltaTime;

                host.ValidateAndMove(host.X + vect.X, host.Y + vect.Y);

                Status = CycleStatus.InProgress;
            }

            state = s;
        }

        private class OrbitState
        {
            public int Direction;
            public float Radius;
            public float Speed;
        }
    }
}
