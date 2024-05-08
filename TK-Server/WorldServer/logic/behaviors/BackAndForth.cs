using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class BackAndForth : CycleBehavior
    {
        private readonly int distance;
        private readonly float speed;

        public BackAndForth(double speed, int distance = 5)
        {
            this.speed = (float)speed;
            this.distance = distance;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var dist = state == null ? distance : (float)state;

            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            var moveDist = host.GetSpeed(speed) * time.BehaviourTickTime;

            if (dist > 0)
            {
                Status = CycleStatus.InProgress;

                host.ValidateAndMove(host.X + moveDist, host.Y);
                dist -= moveDist;

                if (dist <= 0)
                {
                    dist = -distance;
                    Status = CycleStatus.Completed;
                }
            }
            else
            {
                Status = CycleStatus.InProgress;

                host.ValidateAndMove(host.X - moveDist, host.Y);
                dist += moveDist;

                if (dist >= 0)
                {
                    dist = distance;
                    Status = CycleStatus.Completed;
                }
            }

            state = dist;
        }
    }
}
