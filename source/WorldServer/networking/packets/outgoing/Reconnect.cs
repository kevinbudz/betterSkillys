using Shared;
using System;

namespace WorldServer.networking.packets.outgoing
{
    public class Reconnect : OutgoingMessage
    {
        public string Name { get; set; }
        public string Host { get; set; }
        public int Port { get; set; }
        public int GameId { get; set; }
        public int KeyTime { get; set; }
        public byte[] Key { get; private set; }

        public override MessageId MessageId => MessageId.RECONNECT;

        public Reconnect()
        {
            Key = Guid.NewGuid().ToByteArray();
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
            wtr.WriteUTF16(Host);
            wtr.Write(Port);
            wtr.Write(GameId);
            wtr.Write(KeyTime);
            wtr.Write((short)Key.Length);
            wtr.Write(Key);
        }
    }
}
