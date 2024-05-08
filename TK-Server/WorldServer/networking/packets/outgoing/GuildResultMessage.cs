using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class GuildResultMessage : OutgoingMessage
    {
        private readonly bool Success;
        private readonly string ErrorText;

        public override MessageId MessageId => MessageId.GUILDRESULT;

        public GuildResultMessage(bool success, string errorText)
        {
            Success = success;
            ErrorText = errorText;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Success);
            wtr.WriteUTF16(ErrorText);
        }
    }
}
