using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class StayCloseToSpawn : CycleBehavior
    {
        private readonly int range;
        private readonly float speed;

        public StayCloseToSpawn(double speed, int range = 5)
        {
            this.speed = (float)speed;
            this.range = range;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = new Vector2(host.X, host.Y);

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            if (!(state is Vector2))
            {
                state = new Vector2(host.X, host.Y);
                Status = CycleStatus.Completed;

                return;
            }

            var vect = (Vector2)state;

            if ((vect - new Vector2(host.X, host.Y)).Length() > range)
            {
                vect -= new Vector2(host.X, host.Y);
                vect.Normalize();

                var dist = host.GetSpeed(speed) * time.BehaviourTickTime;

                host.ValidateAndMove(host.X + vect.X * dist, host.Y + vect.Y * dist);

                Status = CycleStatus.InProgress;
            }
            else
                Status = CycleStatus.Completed;
        }
    }
}
