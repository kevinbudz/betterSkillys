using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class Ping : OutgoingMessage
    {
        public int Serial { get; set; }
        public int RTT { get; set; }

        public override MessageId MessageId => MessageId.PING;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Serial);
            wtr.Write(RTT);
        }
    }
}
