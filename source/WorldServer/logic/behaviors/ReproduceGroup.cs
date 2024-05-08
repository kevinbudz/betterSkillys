using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.logic;
using WorldServer.utils;
using WorldServer.logic;
using WorldServer.core.worlds;
using WorldServer.core.structures;

namespace WorldServer.logic.behaviors
{
    internal class ReproduceGroup : Behavior
    {
        private readonly ushort[] _children;
        private readonly int _densityMax;
        private readonly double _densityRadius;
        private readonly string _group;
        private readonly TileRegion _region;
        private readonly double _regionRange;
        private Cooldown _coolDown;
        private List<IntPoint> _reproduceRegions;

        public ReproduceGroup(string group = null, double densityRadius = 10, int densityMax = 5, Cooldown coolDown = new Cooldown(), TileRegion region = TileRegion.None, double regionRange = 10)
        {
            _children = BehaviorDb.InitGameData.ObjectDescs.Values.Where(x => x.Group == group).Select(x => x.ObjectType).ToArray();
            _group = group;
            _densityRadius = densityRadius;
            _densityMax = densityMax;
            _coolDown = coolDown.Normalize(60000);
            _region = region;
            _regionRange = regionRange;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            base.OnStateEntry(host, time, ref state);

            if (_region == TileRegion.None)
                return;

            var map = host.World.Map;
            var w = map.Width;
            var h = map.Height;

            _reproduceRegions = new List<IntPoint>();

            for (var y = 0; y < h; y++)
                for (var x = 0; x < w; x++)
                {
                    if (map[x, y].Region != _region)
                        continue;

                    _reproduceRegions.Add(new IntPoint(x, y));
                }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = state == null ? _coolDown.Next(Random) : (int)state;

            if (cool <= 0)
            {
                var count = host.CountEntity(_densityRadius, _group);

                if (count < _densityMax)
                {
                    double targetX = host.X;
                    double targetY = host.Y;

                    if (_reproduceRegions != null && _reproduceRegions.Count > 0)
                    {
                        var sx = (int)host.X;
                        var sy = (int)host.Y;
                        var regions = _reproduceRegions.Where(p => Math.Abs(sx - host.X) <= _regionRange && Math.Abs(sy - host.Y) <= _regionRange).ToList();
                        var tile = regions[Random.Next(regions.Count)];

                        targetX = tile.X;
                        targetY = tile.Y;
                    }

                    if (!host.World.IsPassable(targetX, targetY, true))
                    {
                        state = _coolDown.Next(Random);
                        return;
                    }

                    var entity = Entity.Resolve(host.GameServer, _children[Random.Next(_children.Length)]);
                    entity.GivesNoXp = true;
                    entity.Move((float)targetX, (float)targetY);

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

                cool = _coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
