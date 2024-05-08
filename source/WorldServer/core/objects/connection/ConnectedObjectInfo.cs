using System;
using System.Collections.Generic;

namespace WorldServer.core.objects.connection
{
    public class ConnectedObjectInfo
    {
        public static readonly Dictionary<uint, ConnectedObjectInfo> Infos = new Dictionary<uint, ConnectedObjectInfo>();
        public static readonly Dictionary<Tuple<ConnectionType, int>, ConnectedObjectInfo> Infos2 = new Dictionary<Tuple<ConnectionType, int>, ConnectedObjectInfo>();

        static ConnectedObjectInfo()
        {
            Build(0x02020202, ConnectionType.Dot);          //1111
            Build(0x01020202, ConnectionType.ShortLine);    //0111
            Build(0x01010202, ConnectionType.L);            //0011
            Build(0x01020102, ConnectionType.Line);         //0101
            Build(0x01010201, ConnectionType.T);            //0010
            Build(0x01010101, ConnectionType.Cross);        //0000
        }

        private ConnectedObjectInfo(uint bits, ConnectionType type, int rotation)
        {
            Bits = bits;
            Type = type;
            Rotation = rotation;
        }

        public uint Bits { get; private set; }

        public int Rotation { get; private set; }

        public ConnectionType Type { get; private set; }

        private static void Build(uint bits, ConnectionType type)
        {
            for (var i = 0; i < 4; i++)
                if (!Infos.ContainsKey(bits))
                {
                    Infos[bits] = Infos2[Tuple.Create(type, i * 90)] = new ConnectedObjectInfo(bits, type, i * 90);
                    bits = bits >> 8 | bits << 24;
                }
        }
    }
}
