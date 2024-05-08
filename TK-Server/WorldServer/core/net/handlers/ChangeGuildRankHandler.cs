using Shared;
using System.Linq;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    public sealed class ChangeGuildRankHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.CHANGEGUILDRANK;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var name = rdr.ReadUTF16();
            var rank = rdr.ReadInt32();

            var manager = client.GameServer;
            var srcAcnt = client.Account;
            var srcPlayer = client.Player;

            if (srcPlayer == null || client?.Player?.World is TestWorld)
                return;

            var targetId = client.GameServer.Database.ResolveId(name);
            if (targetId == 0)
            {
                srcPlayer.SendError("A player with that name does not exist.");
                return;
            }

            // get target client if available (player is currently connected to the server)
            // otherwise pull account from db
            var target = client.GameServer.ConnectionManager.Clients
                .Keys.Where(_ => _.Account.AccountId == targetId)
                .FirstOrDefault();
            var targetAcnt = target != null ? target.Account : manager.Database.GetAccount(targetId);

            if (srcAcnt.GuildId <= 0 || srcAcnt.GuildRank < 20 || srcAcnt.GuildRank <= targetAcnt.GuildRank
                || srcAcnt.GuildRank < rank || rank == 40 || srcAcnt.GuildId != targetAcnt.GuildId)
            {
                srcPlayer.SendError("No permission");
                return;
            }

            var targetRank = targetAcnt.GuildRank;

            if (targetRank == rank)
            {
                srcPlayer.SendError("Player is already a " + ResolveRank(rank));
                return;
            }

            // change rank
            if (!client.GameServer.Database.ChangeGuildRank(targetAcnt, rank))
            {
                srcPlayer.SendError("Failed to change rank.");
                return;
            }

            // update player if connected
            if (target != null)
                target.Player.GuildRank = rank;

            // notify guild
            if (targetRank < rank)
                client.GameServer.ChatManager.Guild(srcPlayer, targetAcnt.Name + " has been promoted to " + ResolveRank(rank) + ".");
            else
                client.GameServer.ChatManager.Guild(srcPlayer, targetAcnt.Name + " has been demoted to " + ResolveRank(rank) + ".");
        }

        private string ResolveRank(int rank)
        {
            switch (rank)
            {
                case 0: return "Initiate";
                case 10: return "Member";
                case 20: return "Officer";
                case 30: return "Leader";
                case 40: return "Founder";
                default: return "";
            }
        }
    }
}
