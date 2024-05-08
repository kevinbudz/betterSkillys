using Shared;
using System.Collections.Generic;
using WorldServer.core.net.datas;

namespace WorldServer.networking.packets.outgoing
{
    public struct TileData
    {
        public int X;
        public int Y;
        public int Tile;

        public TileData(int x, int y, int tile)
        {
            X = x;
            Y = y;
            Tile = tile;
        }
    }

    public class Update : OutgoingMessage
    {
        public List<TileData> Tiles { get; set; } = new List<TileData>();
        public List<ObjectDef> NewObjs { get; set; } = new List<ObjectDef>();
        public List<int> Drops { get; set; } = new List<int>();
        public override MessageId MessageId => MessageId.UPDATE;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write((short)Tiles.Count);
            foreach (var i in Tiles)
            {
                wtr.Write((short)i.X);
                wtr.Write((short)i.Y);
                wtr.Write(i.Tile);
            }
            wtr.Write((short)NewObjs.Count);
            foreach (var i in NewObjs)
                i.Write(wtr);
            wtr.Write((short)Drops.Count);
            foreach (var i in Drops)
                wtr.Write(i);
        }
    }
}
