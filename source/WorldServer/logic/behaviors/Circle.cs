using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class Circle : CycleBehavior
    {
        private readonly float acquireRange;
        private readonly float radius;
        private readonly float speed;
        private bool? orbitClockwise;

        private Position entPos;

        public Circle(double speed, double radius, double acquireRange = 10, bool? orbitClockwise = false)
        {
            this.speed = (float)speed;
            this.radius = (float)radius;
            this.acquireRange = (float)acquireRange;
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
                Speed = speed * (float)(Random.NextDouble() * 2 - 1),
                Radius = radius * (float)(Random.NextDouble() * 2 - 1),
                Direction = orbitDir
            };
            entPos = host.Position;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var s = (OrbitState)state;
            Status = CycleStatus.NotStarted;
            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;
            if (host != null)
            {
                var angle = host.Y == entPos.Y && host.X == entPos.X
                    ? Math.Atan2(host.Y - entPos.Y + (Random.NextDouble() * 2 - 1), host.X - entPos.X + (Random.NextDouble() * 2 - 1))
                    : Math.Atan2(host.Y - entPos.Y, host.X - entPos.X);
                var angularSpd = s.Direction * host.GetSpeed(s.Speed) / s.Radius;

                angle += angularSpd * time.DeltaTime;

                var x = entPos.X + Math.Cos(angle) * s.Radius;
                var y = entPos.Y + Math.Sin(angle) * s.Radius;
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
