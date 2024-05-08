using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class TradeRequested : OutgoingMessage
    {
        public string Name { get; set; }

        public override MessageId MessageId => MessageId.TRADEREQUESTED;

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
        }
    }
}
