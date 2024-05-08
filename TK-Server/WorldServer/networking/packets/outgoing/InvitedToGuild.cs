using Shared;

namespace WorldServer.networking.packets.outgoing
{
    internal class InvitedToGuild : OutgoingMessage
    {
        public string Name;
        public string GuildName;

        public override MessageId MessageId => MessageId.INVITEDTOGUILD;

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
            wtr.WriteUTF16(GuildName);
        }
    }
}
