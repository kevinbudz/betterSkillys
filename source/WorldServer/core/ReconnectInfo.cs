using System;

namespace WorldServer.core
{
    public sealed class ReconnectInfo
    {
        public byte[] Key { get; }
        public int Destination { get; }
        public DateTime Timeout { get; }

        public ReconnectInfo(int dest, byte[] key, DateTime timeout)
        {
            Destination = dest;
            Key = key;
            Timeout = timeout;
        }
    }
}
