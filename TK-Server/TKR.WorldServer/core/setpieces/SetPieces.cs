using TKR.Shared.resources;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TKR.WorldServer.core.worlds;
using TKR.WorldServer.core.setpieces;
using TKR.WorldServer.core.terrain;
using TKR.WorldServer.core.structures;

namespace TKR.WorldServer.core.setpieces
{
    public static class SetPieces
    {
        private static readonly List<Tuple<ISetPiece, int, int, TerrainType[]>> Sets = new List<Tuple<ISetPiece, int, int, TerrainType[]>>()
        {
        };
        private static Tuple<ISetPiece, int, int, TerrainType[]> MakeSetPiece(ISetPiece piece, int min, int max, params TerrainType[] terrains) => Tuple.Create(piece, min, max, terrains);

        public static void ApplySetPieces(World world)
        {
            var map = world.Map;
            var w = map.Width;
            var h = map.Height;
            var rects = new HashSet<Rect>();

            foreach (var dat in Sets)
            {
                var size = dat.Item1.Size;
                var count = Random.Shared.Next(dat.Item2, dat.Item3);

                for (var i = 0; i < count; i++)
                {
                    Rect rect;

                    var pt = new IntPoint();
                    var max = 1024;

                    do
                    {
                        pt.X = Random.Shared.Next(0, w);
                        pt.Y = Random.Shared.Next(0, h);
                        rect = new Rect() { x = pt.X, y = pt.Y, w = size, h = size };
                        max--;
                    }
                    while ((Array.IndexOf(dat.Item4, map[pt.X, pt.Y].Terrain) == -1 || rects.Any(_ => Rect.Intersects(rect, _))) && max > 0);

                    if (max <= 0)
                        continue;

                    dat.Item1.RenderSetPiece(world, pt);
                    rects.Add(rect);
                }
            }
        }

        public static int[,] ReflectHorizontal(int[,] mat)
        {
            var M = mat.GetLength(0);
            var N = mat.GetLength(1);
            var ret = new int[M, N];

            for (var x = 0; x < M; x++)
                for (var y = 0; y < N; y++)
                    ret[M - x - 1, y] = mat[x, y];

            return ret;
        }

        public static int[,] ReflectVertical(int[,] mat)
        {
            var M = mat.GetLength(0);
            var N = mat.GetLength(1);
            var ret = new int[M, N];

            for (var x = 0; x < M; x++)
                for (var y = 0; y < N; y++)
                    ret[x, N - y - 1] = mat[x, y];

            return ret;
        }

        public static void RenderFromData(World world, IntPoint pos, byte[] data)
        {
            var ms = new MemoryStream(data);
            var sp = new Wmap(world);

            sp.Load(ms, 0);
            sp.ProjectOntoWorld(world, pos);
        }

        public static int[,] RotateCW(int[,] mat)
        {
            var m = mat.GetLength(0);
            var n = mat.GetLength(1);
            var ret = new int[n, m];

            for (var r = 0; r < m; r++)
                for (var c = 0; c < n; c++)
                    ret[c, m - 1 - r] = mat[r, c];
            return ret;
        }
    }

    public struct Rect
    {
        public int h;
        public int w;
        public int x;
        public int y;

        public static bool Intersects(Rect r1, Rect r2) => !(r2.x > r1.x + r1.w || r2.x + r2.w < r1.x || r2.y > r1.y + r1.h || r2.y + r2.h < r1.y);
        public static bool ContainsPoint(Rect r1, float x, float y) => x > r1.x && x < r1.x + r1.w && y > r1.y && y < r1.y + r1.h;
    }
}
