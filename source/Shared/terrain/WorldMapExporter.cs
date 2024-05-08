using Ionic.Zlib;
using System;
using System.Collections.Generic;
using System.IO;

namespace Shared.terrain
{
    public class WorldMapExporter
    {
        public static void Export(TerrainTile[,] tiles, string path) => File.WriteAllBytes(path, Export(tiles));

        public static byte[] Export(TerrainTile[,] tiles)
        {
            var dict = new List<TerrainTile>();
            var w = tiles.GetLength(0);
            var h = tiles.GetLength(1);
            var dat = new byte[w * h * 3];
            var idx = 0;

            for (var y = 0; y < h; y++)
                for (var x = 0; x < w; x++)
                {
                    var tile = tiles[x, y];
                    var i = (short)dict.IndexOf(tile);

                    if (i == -1)
                    {
                        i = (short)dict.Count;
                        dict.Add(tile);
                    }

                    dat[idx] = (byte)(i & 0xff);
                    dat[idx + 1] = (byte)(i >> 8);
                    dat[idx + 2] = tile.Elevation;
                    idx += 3;
                }

            var ms = new MemoryStream();

            using (var wtr = new BinaryWriter(ms))
            {
                wtr.Write((short)dict.Count);

                foreach (var i in dict)
                {
                    wtr.Write(i.TileId);
                    wtr.Write(i.TileObj ?? "");
                    wtr.Write(i.Name ?? "");
                    wtr.Write((byte)i.Terrain);
                    wtr.Write((byte)i.Region);
                }
                wtr.Write(w);
                wtr.Write(h);
                wtr.Write(dat);
            }

            var buff = ZlibStream.CompressBuffer(ms.ToArray());
            var ret = new byte[buff.Length + 1];

            Buffer.BlockCopy(buff, 0, ret, 1, buff.Length);

            ret[0] = 2;

            return ret;
        }
    }
}
