using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class SkullShrine : ISetPiece
    {
        private static readonly string Grass = "Blue Grass";
        private static readonly string PillarA = "Blue Pillar";
        private static readonly string PillarB = "Broken Blue Pillar";
        private static readonly string Stone = "Cracked Purple Stone";
        private static readonly string Tile = "Castle Stone Floor Tile";
        private static readonly string TileDark = "Castle Stone Floor Tile Dark";

        public override int Size => 33;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[33, 33];

            for (var x = 0; x < 33; x++)                    //Grassing
                for (var y = 0; y < 33; y++)
                    if (Math.Abs(x - Size / 2) / (Size / 2.0) + rand.NextDouble() * 0.3 < 0.95 && Math.Abs(y - Size / 2) / (Size / 2.0) + rand.NextDouble() * 0.3 < 0.95)
                        t[x, y] = 1;

            for (var x = 12; x < 21; x++)                   //Outer
                for (var y = 4; y < 29; y++)
                    t[x, y] = 2;

            t = SetPieces.RotateCW(t);

            for (var x = 12; x < 21; x++)
                for (var y = 4; y < 29; y++)
                    t[x, y] = 2;

            for (var x = 13; x < 20; x++)                   //Inner
                for (var y = 5; y < 28; y++)
                    t[x, y] = 4;

            t = SetPieces.RotateCW(t);

            for (var x = 13; x < 20; x++)
                for (var y = 5; y < 28; y++)
                    t[x, y] = 4;

            for (var i = 0; i < 4; i++)                     //Ext
            {
                for (var x = 13; x < 20; x++)
                    for (var y = 5; y < 7; y++)
                        t[x, y] = 3;

                t = SetPieces.RotateCW(t);
            }

            for (var i = 0; i < 4; i++)                     //Pillars
            {
                t[13, 7] = rand.Next() % 3 == 0 ? 6 : 5;
                t[19, 7] = rand.Next() % 3 == 0 ? 6 : 5;
                t[13, 10] = rand.Next() % 3 == 0 ? 6 : 5;
                t[19, 10] = rand.Next() % 3 == 0 ? 6 : 5;
                t = SetPieces.RotateCW(t);
            }

            var noise = new Noise(Environment.TickCount); //Perlin noise

            for (var x = 0; x < 33; x++)
                for (var y = 0; y < 33; y++)
                    if (noise.GetNoise(x / 33f * 8, y / 33f * 8, .5f) < 0.2)
                        t[x, y] = 0;

            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < 33; x++)                    //Rendering
                for (var y = 0; y < 33; y++)
                {
                    if (t[x, y] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Grass];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[TileDark];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Tile];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 4)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Stone];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 5)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Stone];
                        tile.ObjType = dat.IdToObjectType[PillarA];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 6)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Stone];
                        tile.ObjType = dat.IdToObjectType[PillarB];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                }

            var skull = Entity.Resolve(world.GameServer, "Skull Shrine");          //Skulls!
            skull.Move(pos.X + Size / 2f, pos.Y + Size / 2f);
            world.EnterWorld(skull);
        }
    }
}
