using System;
using System.Collections.Generic;
using Shared;
using WorldServer.core.net.stats;

namespace WorldServer.core.net.datas
{
    public struct ObjectStats
    {
        public int Id;
        public float X;
        public float Y;
        public KeyValuePair<StatDataType, object>[] Stats;

        public ObjectStats(int id, float x, float y, KeyValuePair<StatDataType, object>[] stats)
        {
            Id = id;
            X = x;
            Y = y;
            Stats = stats;
        }

        public static ObjectStats Read(NetworkReader rdr)
        {
            var ret = new ObjectStats
            {
                Id = rdr.ReadInt32(),
                X = rdr.ReadSingle(),
                Y = rdr.ReadSingle(),
                Stats = new KeyValuePair<StatDataType, object>[rdr.ReadInt16()]
            };

            for (var i = 0; i < ret.Stats.Length; i++)
            {
                var type = (StatDataType)rdr.ReadByte();

                if (type == StatDataType.GuildName || type == StatDataType.Name)
                    ret.Stats[i] = new KeyValuePair<StatDataType, object>(type, rdr.ReadUTF16());
                else
                    ret.Stats[i] = new KeyValuePair<StatDataType, object>(type, rdr.ReadInt32());
            }

            return ret;
        }

        public void Write(NetworkWriter wtr)
        {
            wtr.Write(Id);
            wtr.Write(X);
            wtr.Write(Y);
            wtr.Write((short)Stats.Length);
            foreach (var i in Stats)
            {
                wtr.Write((byte)i.Key);

                if (i.Value is int)
                {
                    wtr.Write((int)i.Value);
                    continue;
                }

                if (i.Value is string)
                {
                    wtr.WriteUTF16(i.Value as string);
                    continue;
                }

                if (i.Value is bool)
                {
                    wtr.Write((bool)i.Value ? 1 : 0);
                    continue;
                }

                if (i.Value is ushort)
                {
                    wtr.Write((int)(ushort)i.Value);
                    continue;
                }

                throw new InvalidOperationException($"Stat '{i.Key}' of type '{i.Value?.GetType().ToString() ?? "null"}' not supported.");
            }
        }
    }
}
