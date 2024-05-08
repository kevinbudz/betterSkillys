using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class MoveTo : CycleBehavior
    {
        private readonly float _speed;
        private readonly float _x;
        private readonly float _y;

        public MoveTo(float speed, float x, float y)
        {
            _speed = speed;
            _x = x;
            _y = y;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            Status = CycleStatus.InProgress;

            var path = new Vector2(_x - host.X, _y - host.Y);
            var dist = host.GetSpeed(_speed) * time.BehaviourTickTime;

            if (path.Length() <= dist)
            {
                Status = CycleStatus.Completed;
                host.ValidateAndMove(_x, _y);
            }
            else
            {
                path.Normalize();
                host.ValidateAndMove(host.X + path.X * dist, host.Y + path.Y * dist);
            }
        }
    }
}
