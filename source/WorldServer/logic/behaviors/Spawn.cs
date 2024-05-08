using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class Spawn : Behavior
    {
        private readonly ushort _children;
        private readonly bool _givesNoXp;
        private readonly int _initialSpawn;
        private readonly int _maxChildren;
        private readonly bool _spawnedByBehav;
        private Cooldown _coolDown;

        public Spawn(string children, int maxChildren = 5, double initialSpawn = 0.5, Cooldown coolDown = new Cooldown(), bool givesNoXp = true, bool spawnedByBheav = true)
        {
            _children = GetObjType(children);
            _maxChildren = maxChildren;
            _initialSpawn = (int)(maxChildren * initialSpawn);
            _coolDown = coolDown.Normalize(0);
            _givesNoXp = givesNoXp;
            _spawnedByBehav = spawnedByBheav;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = new SpawnState() { CurrentNumber = _initialSpawn, RemainingTime = _coolDown.Next(Random) };

            for (var i = 0; i < _initialSpawn; i++)
            {
                var entity = Entity.Resolve(host.GameServer, _children);
                entity.Move(host.X, host.Y);

                var enemyHost = host as Enemy;
                var enemyEntity = entity as Enemy;

                enemyEntity.SpawnedByBehavior = _spawnedByBehav;

                entity.GivesNoXp = _givesNoXp;

                if (enemyHost != null && !entity.GivesNoXp)
                    entity.GivesNoXp = enemyHost.GivesNoXp;

                if (enemyHost != null && enemyEntity != null)
                {
                    enemyEntity.ParentEntity = host as Enemy;
                    enemyEntity.Terrain = enemyHost.Terrain;

                    if (enemyHost.Spawned)
                    {
                        enemyEntity.Spawned = true;
                        enemyEntity.ApplyPermanentConditionEffect(ConditionEffectIndex.Invisible);
                    }
                }

                host.World.EnterWorld(entity);
                (state as SpawnState).CurrentNumber++;
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (!(state is SpawnState spawn))
                return;

            if (spawn.RemainingTime <= 0 && spawn.CurrentNumber < _maxChildren)
            {
                var entity = Entity.Resolve(host.GameServer, _children);
                entity.Move(host.X, host.Y);
                entity.SpawnedByBehavior = _spawnedByBehav;
                entity.GivesNoXp = _givesNoXp;

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

                spawn.RemainingTime = _coolDown.Next(Random);
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
