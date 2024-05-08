using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class Tower : ISetPiece
    {
        private static readonly string Floor = "Rock";
        private static readonly string Wall = "Grey Wall";
        private static int[,] quarter;

        static Tower()
        {
            var s =
"............XX\n" +
"........XXXXXX\n" +
"......XXXXXXXX\n" +
".....XXXX=====\n" +
"....XXX=======\n" +
"...XXX========\n" +
"..XXX=========\n" +
"..XX==========\n" +
".XXX==========\n" +
".XX===========\n" +
".XX===========\n" +
".XX===========\n" +
"XXX===========\n" +
"XXX===========";
            var a = s.Split('\n');

            quarter = new int[14, 14];

            for (var y = 0; y < 14; y++)
                for (var x = 0; x < 14; x++)
                    quarter[x, y] = a[y][x] == 'X' ? 1 : a[y][x] == '=' ? 2 : 0;
        }

        public override int Size => 27;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[27, 27];
            var q = (int[,])quarter.Clone();

            for (var y = 0; y < 14; y++)        //Top left
                for (var x = 0; x < 14; x++)
                    t[x, y] = q[x, y];

            q = SetPieces.ReflectHorizontal(q);           //Top right

            for (var y = 0; y < 14; y++)
                for (var x = 0; x < 14; x++)
                    t[13 + x, y] = q[x, y];

            q = SetPieces.ReflectVertical(q);           //Bottom right

            for (var y = 0; y < 14; y++)
                for (var x = 0; x < 14; x++)
                    t[13 + x, 13 + y] = q[x, y];

            q = SetPieces.ReflectHorizontal(q);           //Bottom left

            for (var y = 0; y < 14; y++)
                for (var x = 0; x < 14; x++)
                    t[x, 13 + y] = q[x, y];

            for (var y = 1; y < 4; y++)             //Opening
                for (var x = 8; x < 19; x++)
                    t[x, y] = 2;

            t[12, 0] = t[13, 0] = t[14, 0] = 2;

            var r = Random.Shared.Next(0, 4);                //Rotation

            for (var i = 0; i < r; i++)
                t = SetPieces.RotateCW(t);

            t[13, 13] = 3;

            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < 27; x++)            //Rendering
                for (var y = 0; y < 27; y++)
                {
                    if (t[x, y] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = dat.IdToObjectType[Wall];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y];
                        tile.TileId = dat.IdToTileType[Floor];
                        tile.ObjType = 0;
                        tile.UpdateCount++;

                        var ghostKing = Entity.Resolve(world.GameServer, 0x0928);
                        ghostKing.Move(pos.X + x, pos.Y + y);
                        world.EnterWorld(ghostKing);
                    }
                }
        }
    }
}
