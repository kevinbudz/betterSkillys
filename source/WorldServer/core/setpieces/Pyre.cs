using System;
using System.Linq;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.logic.loot;

namespace WorldServer.core.setpieces
{
    internal class Pyre : ISetPiece
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

        private static readonly string Floor = "Scorch Blend";

        public override int Size => 30;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < Size; x++)
                for (var y = 0; y < Size; y++)
                {
                    var dx = x - Size / 2.0;
                    var dy = y - Size / 2.0;
                    var r = Math.Sqrt(dx * dx + dy * dy) + rand.NextDouble() * 4 - 2;

                    if (r <= 10)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                }

            var lord = Entity.Resolve(world.GameServer, "Phoenix Lord");
            lord.Move(pos.X + 15.5f, pos.Y + 15.5f);
            world.EnterWorld(lord);

            var container = new Container(world.GameServer, 0x0501, null, false);
            var items = chest.CalculateItems(world.GameServer, Random.Shared, 5, 8).ToArray();

            for (var i = 0; i < items.Length; i++)
                container.Inventory[i] = items[i];

            container.Move(pos.X + 15.5f, pos.Y + 15.5f);
            world.EnterWorld(container);
        }
    }
}
