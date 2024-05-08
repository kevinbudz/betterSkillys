using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class ReturnToSpawn : CycleBehavior
    {
        private readonly float _returnWithinRadius;
        private readonly float _speed;

        public ReturnToSpawn(double speed, double returnWithinRadius = 1)
        {
            _speed = (float)speed;
            _returnWithinRadius = (float)returnWithinRadius;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (!(host is Enemy)) return;

            if (host.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                return;

            var spawn = (host as Enemy).SpawnPoint;
            var vect = new Vector2(spawn.X, spawn.Y) - new Vector2(host.X, host.Y);

            if (vect.Length() > _returnWithinRadius)
            {
                Status = CycleStatus.InProgress;
                vect.Normalize();
                vect *= host.GetSpeed(_speed) * time.BehaviourTickTime;
                host.ValidateAndMove(host.X + vect.X, host.Y + vect.Y);
            }
            else
                Status = CycleStatus.Completed;
        }
    }
}
