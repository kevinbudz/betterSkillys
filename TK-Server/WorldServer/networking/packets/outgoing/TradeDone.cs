using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class TradeDone : OutgoingMessage
    {
        public int Code { get; set; }
        public string Description { get; set; }

        public override MessageId MessageId => MessageId.TRADEDONE;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Code);
            wtr.WriteUTF16(Description);
        }
    }
}
