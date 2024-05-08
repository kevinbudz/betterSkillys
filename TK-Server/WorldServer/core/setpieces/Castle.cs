using Shared.resources;
using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.loot;
using WorldServer.core.objects;
using WorldServer.logic.loot;
using WorldServer.core.objects.containers;
using WorldServer.core.structures;

namespace WorldServer.core.setpieces
{
    internal class Castle : ISetPiece
    {
        private static readonly string Bridge = "Bridge";

        private static readonly ChestLoot chest = new ChestLoot(
            new TierLoot(6, ItemType.Weapon, 0.3),
            new TierLoot(7, ItemType.Weapon, 0.2),
            new TierLoot(8, ItemType.Weapon, 0.1),
            new TierLoot(5, ItemType.Armor, 0.3),
            new TierLoot(6, ItemType.Armor, 0.2),
            new TierLoot(7, ItemType.Armor, 0.1),
            new TierLoot(2, ItemType.Ability, 0.3),
            new TierLoot(3, ItemType.Ability, 0.2),
            new TierLoot(4, ItemType.Ability, 0.1),
            new TierLoot(2, ItemType.Ring, 0.25),
            new TierLoot(3, ItemType.Ring, 0.15),
            new TierLoot(1, ItemType.Potion, 0.5)
        );

        private static readonly string Floor = "Rock";

        private static readonly string WallA = "Grey Wall";

        private static readonly string WallB = "Destructible Grey Wall";

        private static readonly string WaterA = "Shallow Water";

        private static readonly string WaterB = "Dark Water";


        public override int Size => 40;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[31, 40];

            for (var x = 0; x < 13; x++)    //Moats
                for (var y = 0; y < 13; y++)
                {
                    if (x == 0 && (y < 3 || y > 9) || y == 0 && (x < 3 || x > 9) || x == 12 && (y < 3 || y > 9) || y == 12 && (x < 3 || x > 9))
                        continue;

                    t[x + 0, y + 0] = t[x + 18, y + 0] = 2;
                    t[x + 0, y + 27] = t[x + 18, y + 27] = 2;
                }

            for (var x = 3; x < 28; x++)
                for (var y = 3; y < 37; y++)
                    if (x < 6 || x > 24 || y < 6 || y > 33)
                        t[x, y] = 2;

            for (var x = 7; x < 24; x++)    //Floor
                for (var y = 7; y < 33; y++)
                    t[x, y] = Random.Shared.Next() % 3 == 0 ? 0 : 1;

            for (var x = 0; x < 7; x++)    //Perimeter
                for (var y = 0; y < 7; y++)
                {
                    if (x == 0 && y != 3 || y == 0 && x != 3 || x == 6 && y != 3 || y == 6 && x != 3)
                        continue;
                    t[x + 3, y + 3] = t[x + 21, y + 3] = 4;
                    t[x + 3, y + 30] = t[x + 21, y + 30] = 4;
                }

            for (var x = 6; x < 25; x++)
                t[x, 6] = t[x, 33] = 4;

            for (var y = 6; y < 34; y++)
                t[6, y] = t[24, y] = 4;

            for (var x = 13; x < 18; x++)    //Bridge
                for (var y = 3; y < 7; y++)
                    t[x, y] = 6;

            for (var x = 0; x < 31; x++)    //Corruption
                for (var y = 0; y < 40; y++)
                {
                    if (t[x, y] == 1 || t[x, y] == 0)
                        continue;

                    var p = Random.Shared.NextDouble();

                    if (t[x, y] == 6)
                    {
                        if (p < 0.4)
                            t[x, y] = 0;

                        continue;
                    }

                    if (p < 0.1)
                        t[x, y] = 1;
                    else if (p < 0.4)
                        t[x, y]++;
                }

            //Boss & Chest
            t[15, 27] = 7;
            t[15, 20] = 8;

            var r = Random.Shared.Next(0, 4);

            for (var i = 0; i < r; i++)     //Rotation
                t = SetPieces.RotateCW(t);

            var w = t.GetLength(0);
            var h = t.GetLength(1);
            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < w; x++)     //Rendering
                for (var y = 0; y < h; y++)
                    if (t[x, y] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[WaterA];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[WaterB];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 4)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[WallA];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 5)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.UpdateCount++;

                        var wall = Entity.Resolve(world.GameServer, dat.IdToObjectType[WallB]);
                        wall.Move(x + pos.X + 0.5f, y + pos.Y + 0.5f);
                        world.EnterWorld(wall);
                    }
                    else if (t[x, y] == 6)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Bridge];
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 7)
                    {
                        var container = new Container(world.GameServer, 0x0501, null, false);
                        var items = chest.CalculateItems(world.GameServer, Random.Shared, 5, 8).ToArray();

                        for (var i = 0; i < items.Length; i++)
                            container.Inventory[i] = items[i];

                        container.Move(pos.X + x + 0.5f, pos.Y + y + 0.5f);
                        world.EnterWorld(container);
                    }
                    else if (t[x, y] == 8)
                    {
                        var cyclops = Entity.Resolve(world.GameServer, "Cyclops God");
                        cyclops.Move(pos.X + x, pos.Y + y);
                        world.EnterWorld(cyclops);
                    }
        }
    }
}
