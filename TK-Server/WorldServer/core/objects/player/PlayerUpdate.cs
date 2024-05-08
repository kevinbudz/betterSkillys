using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;
using WorldServer.core.structures;
using WorldServer.core.terrain;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects.player
{
    public sealed class PlayerUpdate
    {
        public const int VISIBILITY_CIRCUMFERENCE_SQR = (VISIBILITY_RADIUS - 2) * (VISIBILITY_RADIUS - 2);
        public const int VISIBILITY_RADIUS = 15;
        public const int VISIBILITY_RADIUS_SQR = VISIBILITY_RADIUS * VISIBILITY_RADIUS;

        public Player Player { get; private set; }
        public int TickId { get; private set; }
        public int TickTime { get; private set; }
        public World World { get; private set; }
        private HashSet<IntPoint> ActiveTiles = new HashSet<IntPoint>();
        private UpdatedHashSet NewObjects { get; set; }
        private HashSet<WmapTile> NewStaticObjects = new HashSet<WmapTile>();
        private Dictionary<int, byte> SeenTiles = new Dictionary<int, byte>();
        private readonly Dictionary<Entity, Dictionary<StatDataType, object>> StatsUpdates = new Dictionary<Entity, Dictionary<StatDataType, object>>();
        private bool NeedsUpdateTiles = true;

        public PlayerUpdate(Player player)
        {
            Player = player;
            World = player.World;
            NewObjects = new UpdatedHashSet(this);
        }

        public void GetDrops(Update update)
        {
            var drops = new List<int>();
            var staticDrops = new List<int>();

            foreach (var staticTile in NewStaticObjects)
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

            foreach (var entity in NewObjects)
            {
                if (entity == Player.Quest)
                    continue;

                if (entity.Dead)
                {
                    drops.Add(entity.Id);
                    update.Drops.Add(entity.Id);
                    continue;
                }

                if (entity is Player && (entity as Player).CanBeSeenBy(Player))
                    continue;

                if (entity is Player || ActiveTiles.Contains(new IntPoint((int)entity.X, (int)entity.Y)))
                    continue;

                drops.Add(entity.Id);
                update.Drops.Add(entity.Id);
            }

            if (drops.Count != 0)
                NewObjects.RemoveWhere(_ => drops.Contains(_.Id));
            if (staticDrops.Count != 0)
                _ = NewStaticObjects.RemoveWhere(_ => staticDrops.Contains(_.ObjId));
        }

        public void HandleStatChanges(object entity, StatChangedEventArgs statChange)
        {
            if (!(entity is Entity e) || e.Id != Player.Id && statChange.UpdateSelfOnly)
                return;

            if (e.Id == Player.Id && statChange.Stat == StatDataType.None)
                return;

            lock (StatsUpdates)
            {
                if (!StatsUpdates.ContainsKey(e))
                    StatsUpdates[e] = new Dictionary<StatDataType, object>();

                if (statChange.Stat != StatDataType.None)
                    StatsUpdates[e][statChange.Stat] = statChange.Value;
            }
        }

        public void UpdateTiles() => NeedsUpdateTiles = true;

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
            if (NeedsUpdateTiles)
            {
                GetNewTiles(update);
                NeedsUpdateTiles = false;
            }
            GetNewObjects(update);
            GetDrops(update);

            if (update.Tiles.Count == 0 && update.NewObjs.Count == 0 && update.Drops.Count == 0)
                return;
            Player.Client.SendPacket(update);
        }

        public void GetNewTiles(Update update)
        {
            ActiveTiles.Clear();
            var cachedTiles = DetermineSight();
            foreach (var point in cachedTiles)
            {
                var playerX = point.X + (int)Player.X;
                var playerY = point.Y + (int)Player.Y;

                _ = ActiveTiles.Add(new IntPoint(playerX, playerY));

                var tile = World.Map[playerX, playerY];

                var hash = playerX << 16 | playerY;
                _ = SeenTiles.TryGetValue(hash, out var updateCount);

                if (tile == null || tile.TileId == 0xFF || updateCount >= tile.UpdateCount)
                    continue;

                SeenTiles[hash] = tile.UpdateCount;

                var tileData = new TileData(playerX, playerY, tile.TileId);
                update.Tiles.Add(tileData);
            }
            Player.FameCounter.TileSent(update.Tiles.Count); // adds the new amount to the tiles been sent
        }

        public HashSet<IntPoint> DetermineSight()
        {
            var hashSet = new HashSet<IntPoint>();
            switch (World.Blocking)
            {
                case 0:
                    return SightPoints;
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
            var px = (int)Player.X;
            var py = (int)Player.Y;

            foreach (var point in CircleCircumferenceSightPoints)
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
            var px = (int)Player.X;
            var py = (int)Player.Y;

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
            if (!SightPoints.Contains(point))
                return;
            _ = points.Add(point);

            var t = World.Map[x, y];
            if (!(t.ObjType != 0 && t.ObjDesc != null && t.ObjDesc.BlocksSight))
                foreach (var p in SurroundingPoints)
                    StepPath(points, pathMap, x + p.X, y + p.Y, px, py);
        }

        public void GetNewObjects(Update update)
        {
            var x = Player.X;
            var y = Player.Y;

            foreach (var point in ActiveTiles) //static objects
            {
                var pointX = point.X;
                var pointY = point.Y;

                var tile = World.Map[pointX, pointY];
                if (tile == null)
                    continue;

                if (tile.ObjId != 0 && tile.ObjType != 0 && NewStaticObjects.Add(tile))
                    update.NewObjs.Add(tile.ToObjectDef(pointX, pointY));
            }

            var players = World.GetPlayers();

            var count = 0;
            foreach (var player in players)
            {
                if ((player.AccountId == Player.AccountId || player.Client.Account != null && player.CanBeSeenBy(Player)) && NewObjects.Add(player))
                {
                    update.NewObjs.Add(player.ToDefinition(player.AccountId != Player.AccountId));
                    count++;

                    if (count > 12) // 12 players per tick max
                        break;
                }
            }

            foreach (var entity in World.PlayersCollision.HitTest(x, y, VISIBILITY_RADIUS))
                if ((entity is Decoy || entity is Pet) && NewObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());

            var intPoint = new IntPoint(0, 0);
            foreach (var entity in World.EnemiesCollision.HitTest(x, y, VISIBILITY_RADIUS))
            {
                if (entity.Dead || entity is Container)
                    continue;

                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (ActiveTiles.Contains(intPoint) && NewObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entry in World.Containers)
            {
                var entity = entry.Value;
                var owners = entity.BagOwners;
                if (owners.Length > 0 && Array.IndexOf(owners, Player.AccountId) == -1)
                    continue;

                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;
                if (ActiveTiles.Contains(intPoint) && NewObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entity in World.Portals.Values)
            {
                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (ActiveTiles.Contains(intPoint) && NewObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            foreach (var entity in World.SellableObjects.Values)
            {
                intPoint.X = (int)entity.X;
                intPoint.Y = (int)entity.Y;

                if (ActiveTiles.Contains(intPoint) && NewObjects.Add(entity))
                    update.NewObjs.Add(entity.ToDefinition());
            }

            if (Player.Quest != null && NewObjects.Add(Player.Quest))
                update.NewObjs.Add(Player.Quest.ToDefinition());
        }

        private void HandleNewTick()
        {
            var newTick = new NewTickMessage(TickId, TickTime);

            lock (StatsUpdates)
            {
                newTick.Statuses = StatsUpdates.Select(_ => new ObjectStats()
                {
                    Id = _.Key.Id,
                    X = _.Key.X,
                    Y = _.Key.Y,
                    Stats = _.Value.ToArray()
                }).ToList();
                StatsUpdates.Clear();
            }

            Player.Client.SendPacket(newTick);
            Player.AwaitMove(TickId);
        }

        public void Dispose()
        {
            SeenTiles = null;
            ActiveTiles.Clear();
            NewStaticObjects.Clear();
            StatsUpdates.Clear();
            NewObjects.Dispose();
        }

        private static readonly IntPoint[] SurroundingPoints = new IntPoint[5]
        {
            new IntPoint(0, 0),
            new IntPoint(1, 0),
            new IntPoint(0, 1),
            new IntPoint(-1, 0),
            new IntPoint(0, -1)
        };

        private static HashSet<IntPoint> CircleCircumferenceSightPoints = CircleCircumferenceSightPoints ?? (CircleCircumferenceSightPoints = Cache(true));
        private static HashSet<IntPoint> SightPoints = SightPoints ?? (SightPoints = Cache());

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
