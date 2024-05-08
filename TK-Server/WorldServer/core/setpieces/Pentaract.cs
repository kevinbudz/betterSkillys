using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class Pentaract : ISetPiece
    {
        private static readonly byte[,] Circle = new byte[,]
        {
            { 0, 0, 1, 1, 1, 0, 0 },
            { 0, 1, 1, 1, 1, 1, 0 },
            { 1, 1, 1, 1, 1, 1, 1 },
            { 1, 1, 1, 1, 1, 1, 1 },
            { 1, 1, 1, 1, 1, 1, 1 },
            { 0, 1, 1, 1, 1, 1, 0 },
            { 0, 0, 1, 1, 1, 0, 0 },
        };

        private static readonly string Floor = "Scorch Blend";

        public override int Size => 41;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[41, 41];

            for (var i = 0; i < 5; i++)
            {
                var angle = 360 / 5 * i * (float)Math.PI / 180;
                var x_ = (int)(Math.Cos(angle) * 15 + 20 - 3);
                var y_ = (int)(Math.Sin(angle) * 15 + 20 - 3);

                for (var x = 0; x < 7; x++)
                    for (var y = 0; y < 7; y++)
                    {
                        t[x_ + x, y_ + y] = Circle[x, y];
                    }

                t[x_ + 3, y_ + 3] = 2;
            }

            t[20, 20] = 3;

            var data = world.GameServer.Resources.GameData;

            for (var x = 0; x < 40; x++)
                for (var y = 0; y < 40; y++)
                    if (t[x, y] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = data.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = data.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;

                        var penta = Entity.Resolve(world.GameServer, 0x0d5e);
                        penta.Move(pos.X + x + .5f, pos.Y + y + .5f);
                        world.EnterWorld(penta);
                    }
                    else if (t[x, y] == 3)
                    {
                        var penta = Entity.Resolve(world.GameServer, "Pentaract");
                        penta.Move(pos.X + x + .5f, pos.Y + y + .5f);
                        world.EnterWorld(penta);
                    }
        }
    }
}
