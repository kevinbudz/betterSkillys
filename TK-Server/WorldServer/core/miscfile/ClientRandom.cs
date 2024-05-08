using System;

namespace WorldServer.core.miscfile
{
    public class ClientRandom
    {
        private uint _seed;

        public ClientRandom() : this((uint)Environment.TickCount)
        {
        }

        public ClientRandom(uint seed) => _seed = seed;

        public double NextDouble() => Gen() / 2147483647.0;

        public double NextDoubleRange(double min, double max) => min + (max - min) * NextDouble();

        public uint NextInt() => Gen();

        public uint NextIntRange(uint min, uint max) => min == max ? min : min + Gen() % (max - min);

        public double NextNormal(double min = 0, double max = 1)
        {
            var j = Gen() / 2147483647;
            var k = Gen() / 2147483647;
            var l = Math.Sqrt(-2 * Math.Log(j)) * Math.Cos(2 * k * Math.PI);
            return min + l * max;
        }

        private uint Gen()
        {
            uint lb = 16807 * (_seed & 0xFFFF);
            uint hb = 16807 * (uint)((int)_seed >> 16);
            lb = lb + ((hb & 32767) << 16);
            lb = lb + (uint)((int)hb >> 15);
            if (lb > 2147483647)
                lb = lb - 2147483647;

            return _seed = lb;
        }
    }
}
