using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class LichyTemple : ISetPiece
    {
        private static readonly string Floor = "Blue Floor";
        private static readonly string PillarA = "Blue Pillar";
        private static readonly string PillarB = "Broken Blue Pillar";
        private static readonly string WallA = "Blue Wall";
        private static readonly string WallB = "Destructible Blue Wall";

        public override int Size => 26;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[25, 26];

            for (var x = 2; x < 23; x++)    //Floor
                for (var y = 1; y < 24; y++)
                    t[x, y] = Random.Shared.Next() % 10 == 0 ? 0 : 1;

            for (var y = 1; y < 24; y++)    //Perimeters
                t[2, y] = t[22, y] = 2;

            for (var x = 2; x < 23; x++)
                t[x, 23] = 2;

            for (var x = 0; x < 3; x++)
                for (var y = 0; y < 3; y++)
                    t[x + 1, y] = t[x + 21, y] = 2;

            for (var x = 0; x < 5; x++)
                for (var y = 0; y < 5; y++)
                {
                    if (x == 0 && y == 0 || x == 0 && y == 4 || x == 4 && y == 0 || x == 4 && y == 4)
                        continue;

                    t[x, y + 21] = t[x + 20, y + 21] = 2;
                }

            for (var y = 0; y < 6; y++)     //Pillars
                t[9, 4 + 3 * y] = t[15, 4 + 3 * y] = 4;

            for (var x = 0; x < 25; x++)    //Corruption
                for (var y = 0; y < 26; y++)
                {
                    if (t[x, y] == 1 || t[x, y] == 0)
                        continue;

                    var p = Random.Shared.NextDouble();

                    if (p < 0.1)
                        t[x, y] = 1;
                    else if (p < 0.4)
                        t[x, y]++;
                }

            var r = Random.Shared.Next(0, 4);

            for (var i = 0; i < r; i++)     //Rotation
                t = SetPieces.RotateCW(t);

            var w = t.GetLength(0);
            var h = t.GetLength(1);
            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < w; x++)    //Rendering
                for (var y = 0; y < h; y++)
                {
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
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[WallA];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.UpdateCount++;

                        var wall = Entity.Resolve(world.GameServer, dat.IdToObjectType[WallB]);
                        wall.Move(x + pos.X + 0.5f, y + pos.Y + 0.5f);
                        world.EnterWorld(wall);
                    }
                    else if (t[x, y] == 4)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[PillarA];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 5)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[PillarB];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                }

            //Boss
            var lich = Entity.Resolve(world.GameServer, "Lich");
            lich.Move(pos.X + Size / 2, pos.Y + Size / 2);
            world.EnterWorld(lich);
        }
    }
}
