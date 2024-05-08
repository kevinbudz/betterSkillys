using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class PlaySound : OutgoingMessage
    {
        public int OwnerId { get; set; }
        public int SoundId { get; set; }

        public override MessageId MessageId => MessageId.PLAYSOUND;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(OwnerId);
            wtr.Write((byte)SoundId);
        }
    }
}
