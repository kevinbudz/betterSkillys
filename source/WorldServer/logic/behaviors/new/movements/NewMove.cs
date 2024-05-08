using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors.@new.movements
{
    public sealed class NewMove : Behavior
    {
        private readonly float Speed;
        private readonly float Distance;
        private readonly float Angle;
        private readonly float Cooldown;

        public NewMove(float speed = 1.0f, float distance = 3.0f, float angle = 0.0f, float cooldown = 10.0f)
        {
            Speed = speed;
            Distance = distance;
            Angle = angle * TO_RADIANS;
            Cooldown = cooldown;
        }

        protected override bool TickCoreOrdered(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new MoveState() : (MoveState)state;
            if (state == null)
                state = s;

            if (s.CooldownLeft <= 0)
            {
                s.TargetPos = host.PointAt(Angle, Distance);
                s.CooldownLeft = Cooldown;
                Console.WriteLine($"Set Position: {s.TargetPos}");
            }
            s.CooldownLeft -= time.DeltaTime;

            if (host.X == s.TargetPos.X && host.Y == s.TargetPos.Y)
                return false;

            Console.WriteLine($"MoveToward: {s.TargetPos}: Speed: {Speed * time.BehaviourTickTime}");

            if (!host.MoveToward(ref s.TargetPos, Speed * time.BehaviourTickTime))
            {
                s.TargetPos = new Position(host.X, host.Y);
                return false;
            }
            return true;
        }

        protected override void OnStateExit(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new MoveState() : (MoveState)state;
            s.CooldownLeft = 0.0f;
        }

        class MoveState
        {
            public float CooldownLeft;
            public Position TargetPos;
        }
    }
}
