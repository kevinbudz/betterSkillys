using Shared.resources;
using System;
using System.Collections.Generic;
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
    internal class Oasis : ISetPiece
    {
        private static readonly ChestLoot chest = new ChestLoot(
            new TierLoot(5, ItemType.Weapon, 0.3),
            new TierLoot(6, ItemType.Weapon, 0.2),
            new TierLoot(7, ItemType.Weapon, 0.1),
            new TierLoot(4, ItemType.Armor, 0.3),
            new TierLoot(5, ItemType.Armor, 0.2),
            new TierLoot(6, ItemType.Armor, 0.1),
            new TierLoot(2, ItemType.Ability, 0.3),
            new TierLoot(3, ItemType.Ability, 0.2),
            new TierLoot(1, ItemType.Ring, 0.25),
            new TierLoot(2, ItemType.Ring, 0.15),
            new TierLoot(1, ItemType.Potion, 0.5)
        );

        private static readonly string Floor = "Light Grass";
        private static readonly string Tree = "Palm Tree";
        private static readonly string Water = "Shallow Water";


        public override int Size => 30;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var outerRadius = 13;
            var waterRadius = 10;
            var islandRadius = 3;
            var border = new List<IntPoint>();
            var t = new int[Size, Size];

            for (var y = 0; y < Size; y++)      //Outer
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - Size / 2.0;
                    var dy = y - Size / 2.0;
                    var r = Math.Sqrt(dx * dx + dy * dy);

                    if (r <= outerRadius)
                        t[x, y] = 1;
                }

            for (var y = 0; y < Size; y++)      //Water
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - Size / 2.0;
                    var dy = y - Size / 2.0;
                    var r = Math.Sqrt(dx * dx + dy * dy);

                    if (r <= waterRadius)
                    {
                        t[x, y] = 2;

                        if (waterRadius - r < 1)
                            border.Add(new IntPoint(x, y));
                    }
                }

            for (var y = 0; y < Size; y++)      //Island
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - Size / 2.0;
                    var dy = y - Size / 2.0;
                    var r = Math.Sqrt(dx * dx + dy * dy);

                    if (r <= islandRadius)
                    {
                        t[x, y] = 1;

                        if (islandRadius - r < 1)
                            border.Add(new IntPoint(x, y));
                    }
                }

            var trees = new HashSet<IntPoint>();

            while (trees.Count < border.Count * 0.5)
                trees.Add(border[Random.Shared.Next(0, border.Count)]);

            foreach (var i in trees)
                t[i.X, i.Y] = 3;

            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < Size; x++)
                for (var y = 0; y < Size; y++)
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
                        tile.TileId = dat.IdToTileType[Water];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[Tree];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];
                        tile.ObjCfg = "size:" + (Random.Shared.Next() % 2 == 0 ? 120 : 140);

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }

            var giant = Entity.Resolve(world.GameServer, "Oasis Giant");
            giant.Move(pos.X + 15.5f, pos.Y + 15.5f);
            world.EnterWorld(giant);

            var container = new Container(world.GameServer, 0x0501, null, false);
            var items = chest.CalculateItems(world.GameServer, Random.Shared, 5, 8).ToArray();

            for (var i = 0; i < items.Length; i++)
                container.Inventory[i] = items[i];

            container.Move(pos.X + 15.5f, pos.Y + 15.5f);
            world.EnterWorld(container);
        }
    }
}
