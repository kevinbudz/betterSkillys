using Shared;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.networking.packets.outgoing.party
{
    internal class InvitedToParty : OutgoingMessage
    {
        public string Name { get; set; }

        public int PartyId { get; set; }

        public override MessageId MessageId => MessageId.INVITED_TO_PARTY;

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
            wtr.Write(PartyId);
        }
    }
}
