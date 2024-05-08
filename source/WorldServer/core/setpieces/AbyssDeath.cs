using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class AbyssDeath : ISetPiece
    {
        private byte[,] SetPiece = new byte[,]
        {
            {1, 1, 1},
            {1, 2, 1},
            {1, 1, 1},
        };

        public override int Size => 3;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var dat = world.GameServer.Resources.GameData;
            var p = new IntPoint
            {
                X = pos.X - Size / 2,
                Y = pos.Y - Size / 2
            };

            for (var x = 0; x < Size; x++)
                for (var y = 0; y < Size; y++)
                {
                    if (SetPiece[y, x] == 1)
                    {
                        var tile = world.Map[x + p.X, y + p.Y];
                        tile.TileId = dat.IdToTileType["Red Quad"];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                    }

                    if (SetPiece[y, x] == 2)
                    {
                        var tile = world.Map[x + p.X, y + p.Y];
                        tile.TileId = dat.IdToTileType["Red Quad"];
                        tile.ObjType = 0;
                        tile.UpdateCount++;

                        var en = Entity.Resolve(world.GameServer, "Realm Portal");
                        en.Move(x + p.X + 0.5f, y + p.Y + 0.5f);
                        world.EnterWorld(en);
                    }
                }
        }
    }
}
