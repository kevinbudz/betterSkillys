using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NLog;
using Shared.resources;
using WorldServer.core.setpieces;
using WorldServer.core.structures;
using WorldServer.core.terrain;
using WorldServer.core.worlds;

namespace WorldServer.core.worlds
{
    partial class SetPieces
    {

        struct Rect
        {
            public int x;
            public int y;
            public int w;
            public int h;

            public static bool Intersects(Rect r1, Rect r2)
            {
                return !(r2.x > r1.x + r1.w ||
                         r2.x + r2.w < r1.x ||
                         r2.y > r1.y + r1.h ||
                         r2.y + r2.h < r1.y);
            }
        }

        static Tuple<ISetPiece, int, int, TerrainType[]> SetPiece(ISetPiece piece, int min, int max, params TerrainType[] terrains)
        {
            return Tuple.Create(piece, min, max, terrains);
        }

        static readonly List<Tuple<ISetPiece, int, int, TerrainType[]>> setPieces = new List<Tuple<ISetPiece, int, int, TerrainType[]>>()
        {
            //SetPiece(new Building(), 50, 50, TerrainType.LowForest, TerrainType.LowPlains, TerrainType.MidForest),
            //SetPiece(new Graveyard(), 5, 10, TerrainType.LowSand, TerrainType.LowPlains),
            //SetPiece(new Castle(), 3, 5, TerrainType.HighForest, TerrainType.HighPlains),
            //SetPiece(new Tower(), 5, 10, TerrainType.HighForest, TerrainType.HighPlains),
            SetPiece(new TempleA(), 5, 15, TerrainType.MidForest, TerrainType.MidPlains),
            SetPiece(new TempleB(), 5, 15, TerrainType.MidForest, TerrainType.MidPlains),
            SetPiece(new Oasis(), 0, 5, TerrainType.LowSand, TerrainType.MidSand),
            SetPiece(new Pyre(), 0, 5, TerrainType.MidSand, TerrainType.HighSand),
            SetPiece(new LavaFissure(), 3, 5, TerrainType.Mountains),
            SetPiece(new Crystal(), 1, 1, TerrainType.Mountains),
            SetPiece(new KageKami(), 2, 3, TerrainType.HighForest, TerrainType.HighPlains)
        };

        public static int[,] RotateCW(int[,] mat)
        {
            int M = mat.GetLength(0);
            int N = mat.GetLength(1);
            int[,] ret = new int[N, M];
            for (int r = 0; r < M; r++)
            {
                for (int c = 0; c < N; c++)
                {
                    ret[c, M - 1 - r] = mat[r, c];
                }
            }
            return ret;
        }

        public static int[,] ReflectVertical(int[,] mat)
        {
            int M = mat.GetLength(0);
            int N = mat.GetLength(1);
            int[,] ret = new int[M, N];
            for (int x = 0; x < M; x++)
                for (int y = 0; y < N; y++)
                    ret[x, N - y - 1] = mat[x, y];
            return ret;
        }
        public static int[,] ReflectHorizontal(int[,] mat)
        {
            int M = mat.GetLength(0);
            int N = mat.GetLength(1);
            int[,] ret = new int[M, N];
            for (int x = 0; x < M; x++)
                for (int y = 0; y < N; y++)
                    ret[M - x - 1, y] = mat[x, y];
            return ret;
        }

        static int DistSqr(IntPoint a, IntPoint b)
        {
            return (a.X - b.X) * (a.X - b.X) + (a.Y - b.Y) * (a.Y - b.Y);
        }

        public static void ApplySetPieces(World world)
        {
            //log.InfoFormat("Applying setpieces to: '{0}'. [ID: {1}]", world.DisplayName, world.Id);

            var map = world.Map;
            int w = map.Width, h = map.Height;

            Random rand = new Random();
            HashSet<Rect> rects = new HashSet<Rect>();
            foreach (var dat in setPieces)
            {
                int size = dat.Item1.Size;
                int count = rand.Next(dat.Item2, dat.Item3);
                for (int i = 0; i < count; i++)
                {
                    IntPoint pt = new IntPoint();
                    Rect rect;

                    int max = 50;
                    do
                    {
                        pt.X = rand.Next(0, w);
                        pt.Y = rand.Next(0, h);
                        rect = new Rect() { x = pt.X, y = pt.Y, w = size, h = size };
                        max--;
                    } while ((Array.IndexOf(dat.Item4, map[pt.X, pt.Y].Terrain) == -1 ||
                             rects.Any(_ => Rect.Intersects(rect, _))) &&
                             max > 0);
                    if (max <= 0) continue;
                    dat.Item1.RenderSetPiece(world, pt);
                    rects.Add(rect);
                }
            }

            //log.InfoFormat("Applied setpieces to: '{0}'. [ID: {1}]", world.DisplayName, world.Id);
        }

        public static void RenderFromData(World world, IntPoint pos, byte[] data)
        {
            var ms = new MemoryStream(data);
            var sp = new Wmap(world);

            sp.Load(ms, 0);
            sp.ProjectOntoWorld(world, pos);
        }
    }
}
