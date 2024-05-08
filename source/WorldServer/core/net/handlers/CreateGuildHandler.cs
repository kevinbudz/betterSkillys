using Shared;
using Shared.database.guild;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.net.handlers
{
    internal class CreateGuildHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.CREATEGUILD;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var name = rdr.ReadUTF16();

            if (client.Player == null || client?.Player?.World is TestWorld)
                return;

            var acc = client.Account;

            acc.Reload("fame");
            acc.Reload("totalFame");

            if (acc.Fame < 1000)
            {
                SendError(client, "Insufficient funds");
                return;
            }

            if (!acc.NameChosen)
            {
                SendError(client, "Must pick a character name\nbefore creating a guild");
                return;
            }

            if (acc.GuildId > 0)
            {
                SendError(client, "Already in a guild");
                return;
            }

            var guildResult = client.GameServer.Database.CreateGuild(name, out DbGuild guild);

            if (guildResult != DbGuildCreateStatus.OK)
            {
                SendError(client, guildResult.ToString());
                return;
            }

            var addResult = client.GameServer.Database.AddGuildMember(guild, acc, true);

            if (addResult != DbAddGuildMemberStatus.OK)
            {
                SendError(client, addResult.ToString());
                return;
            }

            client.GameServer.Database.UpdateFame(acc, -1000);
            client.Player.CurrentFame = acc.Fame;
            client.Player.Guild = guild.Name;
            client.Player.GuildRank = 40;

            SendSuccess(client);
        }

        private void SendError(Client client, string message = null) => client.SendPacket(new GuildResultMessage(false, "Guild Creation Error: " + message));
        private void SendSuccess(Client client) => client.SendPacket(new GuildResultMessage(true, "Success!"));
    }
}
