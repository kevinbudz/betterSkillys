using Shared;
using WorldServer.core.net.datas;

namespace WorldServer.networking.packets.outgoing
{
    public class Notification : OutgoingMessage
    {
        public int ObjectId { get; set; }
        public string Message { get; set; }
        public ARGB Color { get; set; }
        public int PlayerId { get; set; }

        public override MessageId MessageId => MessageId.NOTIFICATION;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(ObjectId);
            wtr.WriteUTF16(Message);
            Color.Write(wtr);
            wtr.Write(PlayerId);
        }
    }
}
