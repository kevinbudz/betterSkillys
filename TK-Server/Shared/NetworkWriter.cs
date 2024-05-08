using System;
using System.IO;
using System.Net;
using System.Text;

namespace Shared
{
    public sealed class NetworkWriter : BinaryWriter
    {
        public NetworkWriter(Stream stream) : base(stream, Encoding.UTF8)
        {
        }

        public override void Write(short value) => base.Write(IPAddress.HostToNetworkOrder(value));
        public override void Write(int value) => base.Write(IPAddress.HostToNetworkOrder(value));
        public override void Write(long value) => base.Write(IPAddress.HostToNetworkOrder(value));
        public override void Write(ushort value) => base.Write((ushort)IPAddress.HostToNetworkOrder((short)value));
        public override void Write(uint value) => base.Write((uint)IPAddress.HostToNetworkOrder((int)value));
        public override void Write(ulong value) => base.Write((ulong)IPAddress.HostToNetworkOrder((long)value));

        public override void Write(float value)
        {
            var b = BitConverter.GetBytes(value);
            Array.Reverse(b);
            Write(b);
        }
        public override void Write(double value)
        {
            var b = BitConverter.GetBytes(value);
            Array.Reverse(b);
            Write(b);
        }

        public void WriteUTF16(string str)
        {
            if (str == null)
            {
                Write((short)0); // no length
                return;
            }

            var bytes = Encoding.UTF8.GetBytes(str);
            Write((short)bytes.Length);
            Write(bytes);
        }
        public void WriteUTF32(string str)
        {
            if (str == null)
            {
                Write((short)0); // no length
                return;
            }

            var bytes = Encoding.UTF8.GetBytes(str);
            Write(bytes.Length);
            Write(bytes);
        }
        public void WriteNullTerminatedString(string str)
        {
            if (str == null)
            {
                Write((short)0); // no length
                return;
            }

            Write(Encoding.UTF8.GetBytes(str));
            Write((byte)0);
        }
    }
}
