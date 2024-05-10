using Shared;
using System;
using System.Collections.Generic;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.structures;

namespace WorldServer.core.setpieces
{
    internal class Grove : ISetPiece
    {
        private static readonly string Floor = "Light Grass";
        private static readonly string Tree = "Cherry Tree";

        public override int Size => 25;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var radius = Random.Shared.Next(Size - 5, Size + 1) / 2;
            var border = new List<IntPoint>();
            var t = new int[Size, Size];

            for (var y = 0; y < Size; y++)
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - Size / 2.0;
                    var dy = y - Size / 2.0;
                    var r = Math.Sqrt(dx * dx + dy * dy);

                    if (r <= radius)
                    {
                        t[x, y] = 1;

                        if (radius - r < 1.5)
                            border.Add(new IntPoint(x, y));
                    }
                }

            var trees = new HashSet<IntPoint>();

            while (trees.Count < border.Count * 0.5)
                trees.Add(Random.Shared.NextLength(border));

            foreach (var i in trees)
                t[i.X, i.Y] = 2;

            var dat = world.GameServer.Resources.GameData;

            for (var x = 0; x < Size; x++)
                for (var y = 0; y < Size; y++)
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
                        tile.ObjType = dat.IdToObjectType[Tree];
                        tile.ObjDesc = dat.ObjectDescs[tile.ObjType];
                        tile.ObjCfg = "size:" + (Random.Shared.Next() % 2 == 0 ? 120 : 140);

                        if (tile.ObjId == 0)
                            tile.ObjId = world.GetNextEntityId();

                        tile.UpdateCount++;
                    }
                }

            var ent = Entity.Resolve(world.GameServer, "Ent Ancient");
            ent.Size = 140  ;
            ent.Move(pos.X + Size / 2 + 1, pos.Y + Size / 2 + 1);
            world.EnterWorld(ent);
        }
    }
}
