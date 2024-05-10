using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;
using WorldServer.core.objects.player.data.container;
using WorldServer.core.structures;
using WorldServer.core.terrain;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    partial class Player
    {
        public const int VISIBILITY_CIRCUMFERENCE_SQR = (VISIBILITY_RADIUS - 2) * (VISIBILITY_RADIUS - 2);
        public const int VISIBILITY_RADIUS = 15;
        public const int VISIBILITY_RADIUS_SQR = VISIBILITY_RADIUS * VISIBILITY_RADIUS;

        public int TickId { get; private set; }
        public int TickTime { get; private set; }

        private UpdatedHashSet _newObjects;
        
        private readonly HashSet<IntPoint> _activeTiles = new HashSet<IntPoint>();
        private readonly HashSet<WmapTile> _newStaticObjects = new HashSet<WmapTile>();
        private readonly Dictionary<int, byte> _seenTiles = new Dictionary<int, byte>();
        private readonly Dictionary<Entity, Dictionary<StatDataType, object>> _statsUpdates = new Dictionary<Entity, Dictionary<StatDataType, object>>();
        
        private bool _needsUpdateTiles = true;
        
        public void InitializeUpdate()
        {
            _newObjects = new UpdatedHashSet(this);
        }

        public void GetDrops(Update update)
        {
            var drops = new List<int>();
            var staticDrops = new List<int>();

            foreach (var staticTile in _newStaticObjects)
            {
                var x = staticTile.X;
                var y = staticTile.Y;
                if (x * x + y * y > VISIBILITY_RADIUS_SQR || staticTile.ObjType == 0)
                    if (staticTile.ObjId != 0)
                    {
                        update.Drops.Add(staticTile.ObjId);
                        staticDrops.Add(staticTile.ObjId);
                    }
            }

            foreach (var entity in _newObjects)
            {
                if (entity == Quest)
                    continue;

                if (entity.Dead)
                {
                    drops.Add(entity.Id);
                    update.Drops.Add(entity.Id);
                    continue;
                }

                if (entity is Player && (entity as Player).CanBeSeenBy(this))
                    continue;

                if (entity is Player || _activeTiles.Contains(new IntPoint((int)entity.X, (int)entity.Y)))
                    continue;

                drops.Add(entity.Id);
                update.Drops.Add(entity.Id);
            }

            if (drops.Count != 0)
                _newObjects.RemoveWhere(_ => drops.Contains(_.Id));
            if (staticDrops.Count != 0)
                _ = _newStaticObjects.RemoveWhere(_ => staticDrops.Contains(_.ObjId));
        }

        public void HandleStatChanges(object entity, StatChangedEventArgs statChange)
        {
            if (!(entity is Entity e) || e.Id != Id && statChange.UpdateSelfOnly)
                return;

            if (e.Id == Id && statChange.Stat == StatDataType.None)
                return;

            lock (_statsUpdates)
            {
                if (!_statsUpdates.ContainsKey(e))
                    _statsUpdates[e] = new Dictionary<StatDataType, object>();

                if (statChange.Stat != StatDataType.None)
                    _statsUpdates[e][statChange.Stat] = statChange.Value;
            }
        }

        public void UpdateTiles() => _needsUpdateTiles = true;

        public void UpdateState(int dt)
        {
            TickId++;
            TickTime = dt;

            HandleUpdate();
            HandleNewTick();
        }

        private void HandleUpdate()
        {
            var update = new Update();
            if (_needsUpdateTiles)
            {
                GetNewTiles(update);
                _needsUpdateTiles = false;
            }
            GetNewObjects(update);
            GetDrops(update);

            if (update.Tiles.Count == 0 && update.NewObjs.Count == 0 && update.Drops.Count == 0)
                return;
            Client.SendPacket(update);
        }

        public void GetNewTiles(Update update)
        {
            _activeTiles.Clear();
            var cachedTiles = DetermineSight();
            foreach (var point in cachedTiles)
            {
                var playerX = point.X + (int)X;
                var playerY = point.Y + (int)Y;

                _ = _activeTiles.Add(new IntPoint(playerX, playerY));

                var tile = World.Map[playerX, playerY];

                var hash = playerX << 16 | playerY;
                _ = _seenTiles.TryGetValue(hash, out var updateCount);

                if (tile == null || tile.TileId == 0xFF || updateCount >= tile.UpdateCount)
                    continue;

                _seenTiles[hash] = tile.UpdateCount;

                var tileData = new TileData(playerX, playerY, tile.TileId);
                update.Tiles.Add(tileData);
            }
            FameCounter.TileSent(update.Tiles.Count); // adds the new amount to the tiles been sent
        }

        public HashSet<IntPoint> DetermineSight()
        {
            var hashSet = new HashSet<IntPoint>();
            switch (World.Blocking)
            {
                case 0:
                    return _sightPoints;
                case 1:
                    CalculateLineOfSight(hashSet);
                    break;
                case 2:
                    CalculatePath(hashSet);
                    break;
            }
            return hashSet;
        }

        public void CalculateLineOfSight(HashSet<IntPoint> points)
        {
            var px = (int)X;
            var py = (int)Y;

            foreach (var point in _circleCircumferenceSightPoints)
                DrawLine(px, py, px + point.X, py + point.Y, (x, y) =>
                {
                    _ = points.Add(new IntPoint(x - px, y - py));

                    if (World.Map.Contains(x, y))
                    {
                        var t = World.Map[x, y];
                        return t.ObjType != 0 && t.ObjDesc != null && t.ObjDesc.BlocksSight;
                    }
                    return false;
                });
        }

        public void CalculatePath(HashSet<IntPoint> points)
        {
            var px = (int)X;
            var py = (int)Y;

            var pathMap = new bool[World.Map.Width, World.Map.Height];
            StepPath(points, pathMap, px, py, px, py);
        }

        private void StepPath(HashSet<IntPoint> points, bool[,] pathMap, int x, int y, int px, int py)
        {
            if (!World.Map.Contains(x, y))
                return;

            if (pathMap[x, y])
                return;
            pathMap[x, y] = true;

            var point = new IntPoint(x - px, y - py);
            if (!_sightPoints.Contains(point))
                return;
            _ = points.Add(point);

            var t = World.Map[x, y];
            if (!(t.ObjType != 0 && t.ObjDesc != null && t.ObjDesc.BlocksSight))
                foreach (var p in _surroundingPoints)
                    StepPath(points, pathMap, x + p.X, y + p.Y, px, py);
        }

        public void GetNewObjects(Update update)
        {
            var x = X;
            var y = Y;

            foreach (var point in _activeTiles) //static objects
            {
                var pointX = point.X;
                var pointY = point.Y;

                var tile = World.Map[pointX, pointY];
                if (tile == null)
                    continue;

                if (tile.ObjId != 0 && tile.ObjType != 0 && _newStaticObjects.Add(tile))
                    update.NewObjs.Add(tile.ToObjectDef(pointX, pointY));
            }

            var players = World.GetPlayers();

            var count = 0;
            foreach (var player in players)
            {
                if ((player.AccountId == AccountId || player.Client.Account != null && player.CanBeSeenBy(this)) && _newObjects.Add(player))
                {
                    update.NewObjs.Add(player.ToDefinition(player.AccountId != AccountId));
                    count++;

                    if (count > 12) // 12 players per tick max
                        break;
                }
            }

            foreach (var entity in World.PlayersCollision.HitTest(x, y, VISIBILITY_RADIUS))
                if ((entity is Decoy || entity is Pet) && _newObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());

            var intPoint = new IntPoint(0, 0);
            foreach (var entity in World.EnemiesCollision.HitTest(x, y, VISIBILITY_RADIUS))
            {
                if (entity.Dead || entity is Container)
                    continue;

                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (_activeTiles.Contains(intPoint) && _newObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entry in World.Containers)
            {
                var entity = entry.Value;
                var owners = entity.BagOwners;
                if (owners.Length > 0 && Array.IndexOf(owners, AccountId) == -1)
                    continue;

                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;
                if (_activeTiles.Contains(intPoint) && _newObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entity in World.Portals.Values)
            {
                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (_activeTiles.Contains(intPoint) && _newObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entity in World.SellableObjects.Values)
            {
                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (_activeTiles.Contains(intPoint) && _newObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            if (Quest != null && _newObjects.Add(Quest))
                update.NewObjs.Add(Quest.ToDefinition());
        }

        private void HandleNewTick()
        {
            var newTick = new NewTickMessage(TickId, TickTime);

            lock (_statsUpdates)
            {
                newTick.Statuses = _statsUpdates.Select(_ => new ObjectStats()
                {
                    Id = _.Key.Id,
                    X = _.Key.X,
                    Y = _.Key.Y,
                    Stats = _.Value.ToArray()
                }).ToList();
                _statsUpdates.Clear();
            }

            Client.SendPacket(newTick);
            AwaitMove(TickId);
        }

        public void CleanupPlayerUpdate()
        {
            _seenTiles.Clear();
            _activeTiles.Clear();
            _newStaticObjects.Clear();
            _statsUpdates.Clear();
            _newObjects.Dispose();
        }

        private static readonly IntPoint[] _surroundingPoints = new IntPoint[5]
        {
            new IntPoint(0, 0),
            new IntPoint(1, 0),
            new IntPoint(0, 1),
            new IntPoint(-1, 0),
            new IntPoint(0, -1)
        };

        private static readonly HashSet<IntPoint> _circleCircumferenceSightPoints = _circleCircumferenceSightPoints ??= Cache(true);
        private static readonly HashSet<IntPoint> _sightPoints = _sightPoints ??= Cache();

        private static HashSet<IntPoint> Cache(bool circumferenceCheck = false)
        {
            var ret = new HashSet<IntPoint>();
            for (var x = -VISIBILITY_RADIUS; x <= VISIBILITY_RADIUS; x++)
                for (var y = -VISIBILITY_RADIUS; y <= VISIBILITY_RADIUS; y++)
                {
                    var flag = x * x + y * y <= VISIBILITY_RADIUS_SQR;
                    if (circumferenceCheck)
                        flag &= x * x + y * y > VISIBILITY_CIRCUMFERENCE_SQR;
                    if (flag)
                        _ = ret.Add(new IntPoint(x, y));
                }

            return ret;
        }

        public static void DrawLine(int x, int y, int x2, int y2, Func<int, int, bool> func)
        {
            var w = x2 - x;
            var h = y2 - y;
            var dx1 = 0;
            var dy1 = 0;
            var dx2 = 0;
            var dy2 = 0;
            if (w < 0)
                dx1 = -1;
            else if (w > 0)
                dx1 = 1;
            if (h < 0)
                dy1 = -1;
            else if (h > 0)
                dy1 = 1;
            if (w < 0)
                dx2 = -1;
            else if (w > 0)
                dx2 = 1;

            var longest = Math.Abs(w);
            var shortest = Math.Abs(h);
            if (!(longest > shortest))
            {
                longest = Math.Abs(h);
                shortest = Math.Abs(w);
                if (h < 0)
                    dy2 = -1;
                else if (h > 0)
                    dy2 = 1;
                dx2 = 0;
            }

            var numerator = longest >> 1;
            for (var i = 0; i <= longest; i++)
            {
                if (func(x, y))
                    break;

                numerator += shortest;
                if (!(numerator < longest))
                {
                    numerator -= longest;
                    x += dx1;
                    y += dy1;
                }
                else
                {
                    x += dx2;
                    y += dy2;
                }
            }
        }
    }
}
