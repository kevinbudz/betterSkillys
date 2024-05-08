using Shared.resources;
using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.logic;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class SpawnGroup : Behavior
    {
        private readonly int maxChildren;
        private readonly double radius;
        private ushort[] children;
        private Cooldown coolDown;
        private int initialSpawn;

        public SpawnGroup(string group, int maxChildren = 5, double initialSpawn = 0.5, Cooldown coolDown = new Cooldown(), double radius = 0)
        {
            children = BehaviorDb.InitGameData.ObjectDescs.Values.Where(x => x.Group == group).Select(x => x.ObjectType).ToArray();

            this.maxChildren = maxChildren;
            this.initialSpawn = (int)(maxChildren * initialSpawn);
            this.coolDown = coolDown.Normalize(0);
            this.radius = radius;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = new SpawnState() { CurrentNumber = initialSpawn, RemainingTime = coolDown.Next(Random) };

            for (var i = 0; i < initialSpawn; i++)
            {
                var x = host.X + (float)(Random.NextDouble() * radius);
                var y = host.Y + (float)(Random.NextDouble() * radius);

                if (!host.World.IsPassable(x, y, true))
                    continue;

                var entity = Entity.Resolve(host.GameServer, children[Random.Next(children.Length)]);
                entity.Move(x, y);

                var enemyEntity = entity as Enemy;

                if (host is Enemy enemyHost && enemyEntity != null)
                {
                    enemyEntity.Terrain = enemyHost.Terrain;

                    if (enemyHost.Spawned)
                    {
                        enemyEntity.Spawned = true;
                        enemyEntity.ApplyPermanentConditionEffect(ConditionEffectIndex.Invisible);
                    }
                }

                host.World.EnterWorld(entity);
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var spawn = (SpawnState)state;

            if (spawn.RemainingTime <= 0 && spawn.CurrentNumber < maxChildren)
            {
                var x = host.X + (float)(Random.NextDouble() * radius);
                var y = host.Y + (float)(Random.NextDouble() * radius);

                if (!host.World.IsPassable(x, y, true))
                {
                    spawn.RemainingTime = coolDown.Next(Random);
                    spawn.CurrentNumber++;
                    return;
                }

                var entity = Entity.Resolve(host.GameServer, children[Random.Next(children.Length)]);
                entity.Move(x, y);

                var enemyEntity = entity as Enemy;

                if (host is Enemy enemyHost && enemyEntity != null)
                {
                    enemyEntity.Terrain = enemyHost.Terrain;

                    if (enemyHost.Spawned)
                    {
                        enemyEntity.Spawned = true;
                        enemyEntity.ApplyPermanentConditionEffect(ConditionEffectIndex.Invisible);
                    }
                }

                host.World.EnterWorld(entity);

                spawn.RemainingTime = coolDown.Next(Random);
                spawn.CurrentNumber++;
            }
            else
                spawn.RemainingTime -= time.ElapsedMsDelta;
        }

        private class SpawnState
        {
            public int CurrentNumber;
            public int RemainingTime;
        }
    }
}
