using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class SwitchMusic : OutgoingMessage
    {
        public string Music { get; set; }

        public override MessageId MessageId => MessageId.SWITCH_MUSIC;

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Music);
        }
    }
}