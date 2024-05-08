using System;
using System.IO;
using System.Net;
using System.Text;

namespace Shared
{
    public sealed class NetworkReader : BinaryReader
    {
        public NetworkReader(Stream stream) : base(stream, Encoding.UTF8)
        {
        }

        public override short ReadInt16() => IPAddress.NetworkToHostOrder(base.ReadInt16());
        public override ushort ReadUInt16() => (ushort)IPAddress.NetworkToHostOrder((short)base.ReadUInt16());
        public override int ReadInt32() => IPAddress.NetworkToHostOrder(base.ReadInt32());
        public override uint ReadUInt32() => (uint)IPAddress.NetworkToHostOrder((int)base.ReadUInt32());
        public override long ReadInt64() => IPAddress.NetworkToHostOrder(base.ReadInt64());
        public override ulong ReadUInt64() => (ulong)IPAddress.NetworkToHostOrder((long)base.ReadUInt64());

        public override float ReadSingle()
        {
            var arr = base.ReadBytes(sizeof(float));
            Array.Reverse(arr);
            return BitConverter.ToSingle(arr, 0);
        }
        public override double ReadDouble()
        {
            var arr = base.ReadBytes(sizeof(double));
            Array.Reverse(arr);
            return BitConverter.ToDouble(arr, 0);
        }

        public string ReadUTF16() => Encoding.UTF8.GetString(ReadBytes(ReadInt16()));
        public string ReadUTF32() => Encoding.UTF8.GetString(ReadBytes(ReadInt32()));
    }
}
