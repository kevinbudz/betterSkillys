using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors.@new.movements
{
    public sealed class NewFollow : Behavior
    {
        private readonly float AcquireRange;
        private readonly float Range;
        private readonly float Speed;
        private readonly float Duration;
        private readonly float Cooldown;
        private readonly bool Predictive;

        public NewFollow(float acquireRange = 10.0f, float range = 3.0f, float speed = 1.0f, float duration = 30.0f, float cooldown = 5.0f, bool predictive = false)
        {
            AcquireRange = acquireRange;
            Range = range;
            Speed = speed;
            Duration = duration;
            Cooldown = cooldown;
            Predictive = predictive;
        }

        protected override bool TickCoreOrdered(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new FollowState() : (FollowState)state;
            if (state == null)
                state = s;

            s.TimeLeft -= time.DeltaTime;
            if (s.TimeLeft < 0.0f)
                s.TimeLeft = 0.0f;

            if (!s.Following && s.TimeLeft > 0.0f)
                return false;

            if (Duration != 0.0f && s.Following && s.TimeLeft == 0.0f)
            {
                s.Following = false;
                s.TimeLeft = Cooldown;
                return false;
            }

            var target = host.World.FindPlayerTarget(host); //.FindPlayerTarget(Host);
            if (target == null)
            {
                if (s.Following)
                {
                    s.Following = false;
                    s.TimeLeft = Cooldown;
                }
                return false;
            }

            var dist = host.DistTo(target);
            if (dist > AcquireRange)
            {
                if (s.Following)
                {
                    s.Following = false;
                    s.TimeLeft = Cooldown;
                }
                return false;
            }

            if (!s.Following)
            {
                s.Following = true;
                s.TimeLeft = Duration;
            }

            if (dist < Range)
                return false;

            var targetX = target.X;
            var targetY = target.Y;
            if (Predictive)
            {
                const int PREDICT_NUM_TICKS = 4;
                targetX += PREDICT_NUM_TICKS * (target.X - target.PrevX);
                targetY += PREDICT_NUM_TICKS * (target.Y - target.PrevY);
            }

            return host.MoveToward(targetX, targetY, Speed * time.BehaviourTickTime);
        }

        protected override void OnStateExit(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new FollowState() : (FollowState)state;
            s.Following = false;
            s.TimeLeft = 0.0f;
        }

        class FollowState
        {
            public bool Following;
            public float TimeLeft;
        }
    }
}
