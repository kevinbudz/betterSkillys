using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class GlobalNotificationMessage : OutgoingMessage
    {
        private readonly int Type;
        private readonly string Text;

        public override MessageId MessageId => MessageId.GLOBAL_NOTIFICATION;

        public GlobalNotificationMessage(int type, string text)
        {
            Type = type;
            Text = text;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Type);
            wtr.WriteUTF16(Text);
        }
    }
}
