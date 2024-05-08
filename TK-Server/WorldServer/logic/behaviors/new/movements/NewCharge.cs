using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors.@new.movements
{
    public sealed class NewCharge : Behavior
    {
        private readonly float Cooldown;
        private readonly float Speed;
        private readonly float Range;

        public NewCharge(float cooldown = 3.0f, float speed = 3.0f, float range = 20.0f)
        {
            Cooldown = cooldown;
            Speed = speed;
            Range = range;
        }

        protected override bool TickCoreOrdered(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new ChargeState() : (ChargeState)state;
            if (state == null)
                state = s;

            if (s.Charging)
            {
                Charge(host, s, time.BehaviourTickTime);
                return true;
            }

            s.CooldownLeft -= time.DeltaTime;
            if (s.CooldownLeft > 0.0f)
                return false;
            s.CooldownLeft = Cooldown;

            var target = host.World.FindPlayerTarget(host);
            if (target == null || host.DistTo(target) > Range)
                return false;

            s.Charging = true;
            s.TargetPos = new Position(target.X, target.Y);
            s.CurrentDist = host.SqDistTo(ref s.TargetPos);

            Charge(host, s, time.BehaviourTickTime);

            return true;
        }

        private void Charge(Entity host, ChargeState s, float dt)
        {
            if (!host.MoveToward(ref s.TargetPos, Speed * dt))
                s.Charging = false;
            else
            {
                var dist = host.SqDistTo(ref s.TargetPos);
                if (dist >= s.CurrentDist)
                    s.Charging = false;
                else if (dist < .1 * .1)
                    s.Charging = false;
                s.CurrentDist = dist;
            }
        }

        protected override void OnStateExit(Entity host, TickTime time, ref object state)
        {
            var s = state == null ? new ChargeState() : (ChargeState)state;
            s.Charging = false;
            s.CooldownLeft = 0.0f;
        }

        class ChargeState
        {
            public bool Charging;
            public float CooldownLeft;
            public Position TargetPos;
            public float CurrentDist;
        }
    }
}
