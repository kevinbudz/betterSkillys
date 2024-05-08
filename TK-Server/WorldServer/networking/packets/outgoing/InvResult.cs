using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class InvResult : OutgoingMessage
    {
        public int Result { get; set; }

        public override MessageId MessageId => MessageId.INVRESULT;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Result);
        }
    }
}
