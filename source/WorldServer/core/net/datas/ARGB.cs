using Shared;

namespace WorldServer.core.net.datas
{
    public struct ARGB
    {
        public byte A;
        public byte B;
        public byte G;
        public byte R;

        public ARGB(uint argb)
        {
            A = (byte)((argb & 0xff000000) >> 24);
            R = (byte)((argb & 0x00ff0000) >> 16);
            G = (byte)((argb & 0x0000ff00) >> 8);
            B = (byte)((argb & 0x000000ff) >> 0);
        }

        public static ARGB Read(NetworkReader rdr) => new ARGB()
        {
            A = rdr.ReadByte(),
            R = rdr.ReadByte(),
            G = rdr.ReadByte(),
            B = rdr.ReadByte()
        };

        public void Write(NetworkWriter wtr)
        {
            wtr.Write(A);
            wtr.Write(R);
            wtr.Write(G);
            wtr.Write(B);
        }
    }
}
