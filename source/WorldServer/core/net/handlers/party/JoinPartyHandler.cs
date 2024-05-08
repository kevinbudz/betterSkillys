using Shared;
using Shared.database.party;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;

namespace WorldServer.core.net.handlers.party
{
    internal class JoinPartyHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.JOIN_PARTY;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var partyLeader = rdr.ReadUTF16();
            var partyId = rdr.ReadInt32();

            if (client == null || client?.Player?.World is TestWorld || client.Player == null || client.Player.World == null)
                return;

            var db = client.Account.Database;

            client.Account.Reload("partyId");

            var party = DbPartySystem.Get(db, partyId);

            if (party == null)
            {
                client.Player.SendError("Party doesn't exists.");
                return;
            }

            if (client.Account.PartyId != 0)
            {
                client.Player.SendError("You're already in a Party.");
                client.Account.Reload("partyId");
                return;
            }

            if (partyLeader != null)
                if (party.PartyLeader.Item1 != partyLeader)
                {
                    client.Player.SendError("Unexpected error.");
                    return;
                }

            client.GameServer.Database.AddMemberToParty(db, client.Account.Name, client.Account.AccountId, party.PartyId);
            client.Account.PartyId = party.PartyId;
            client.Account.FlushAsync();
            client.Account.Reload("partyId");
            client.GameServer.ChatManager.Party(client.Player, client.Player.Name + " has joined the Party!");
            client.Player?.SendInfo("Joined Successfully!");
        }
    }
}
