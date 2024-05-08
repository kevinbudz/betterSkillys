using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class TransformOnDeath : Behavior
    {
        private int max;
        private int min;
        private readonly float probability;
        private readonly ushort target;

        public TransformOnDeath(string target, int min = 1, int max = 1, double probability = 1)
        {
            this.target = GetObjType(target);
            this.min = min;
            this.max = max;
            this.probability = (float)probability;
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
            if (Random.NextDouble() < probability)
            {
                if (Entity.Resolve(host.GameServer, target) is Portal && host.World.IdName.Contains("Arena"))
                    return;

                if (min > max)
                    max = min;//exception error

                var count = Random.Next(min, max + 1);

                for (var i = 0; i < count; i++)
                {
                    var entity = Entity.Resolve(host.GameServer, target);
                    entity.Move(host.X, host.Y);

                    if (host is Enemy && entity is Enemy && (host as Enemy).Spawned)
                    {
                        (entity as Enemy).Spawned = true;
                        (entity as Enemy).ApplyPermanentConditionEffect(ConditionEffectIndex.Invisible);
                    }

                    host.World.EnterWorld(entity);
                }
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
