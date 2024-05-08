using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class ClientStatMessage : OutgoingMessage
    {
        private readonly string Name;
        private readonly int Value;

        public override MessageId MessageId => MessageId.CLIENTSTAT;

        public ClientStatMessage(string name, int value)
        {
            Name = name;
            Value = value;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
            wtr.Write(Value);
        }
    }
}
