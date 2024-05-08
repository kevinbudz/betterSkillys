using Shared;
using Shared.database;
using NLog;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.core.objects;
using WorldServer.networking.packets.outgoing;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    internal class ChooseNameHandler : IMessageHandler
    {
        private static readonly Logger NameChangeLog = LogManager.GetCurrentClassLogger();

        public override MessageId MessageId => MessageId.CHOOSENAME;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var name = rdr.ReadUTF16();

            if (client.Player == null || client?.Player?.World is TestWorld)
                return;

            client.GameServer.Database.ReloadAccount(client.Account);

            if (name.Length < 1 || name.Length > 10 || !name.All(char.IsLetter) || !IsValid(name) || Database.GuestNames.Contains(name, StringComparer.InvariantCultureIgnoreCase))
                client.SendPacket(new NameResult()
                {
                    Success = false,
                    ErrorText = "Invalid name"
                });
            else
            {
                string lockToken = null;

                var key = Database.NAME_LOCK;

                try
                {
                    while ((lockToken = client.GameServer.Database.AcquireLock(key)) == null) ;

                    if (client.GameServer.Database.Conn.HashExists("names", name.ToUpperInvariant()))
                    {
                        client.SendPacket(new NameResult()
                        {
                            Success = false,
                            ErrorText = "Duplicated name"
                        });
                        return;
                    }

                    if (client.Account.NameChosen && client.Account.Credits < 100)
                        client.SendPacket(new NameResult()
                        {
                            Success = false,
                            ErrorText = "Not enough gold"
                        });
                    else
                    {
                        // remove fame is purchasing name change
                        if (client.Account.NameChosen)
                            client.GameServer.Database.UpdateCredit(client.Account, -100);

                        // rename
                        var oldName = client.Account.Name;
                        while (!client.GameServer.Database.RenameIGN(client.Account, name, lockToken)) ;
                        NameChangeLog.Info($"{oldName} changed their name to {name}");

                        // update player
                        UpdatePlayer(client.Player);
                        client.SendPacket(new NameResult()
                        {
                            Success = true,
                            ErrorText = ""
                        });
                    }
                }
                finally
                {
                    if (lockToken != null)
                        client.GameServer.Database.ReleaseLock(key, lockToken);
                }
            }
        }

        private bool IsValid(string text)
        {
            var nonDup = new Regex(@"([a-zA-z]{2,})\1{1,}");
            var alpha = new Regex(@"^[A-Za-z]{1,10}$");

            return !(nonDup.Matches(text).Count > 0) && alpha.Matches(text).Count > 0;
        }

        private void UpdatePlayer(Player player)
        {
            player.Credits = player.Client.Account.Credits;
            player.CurrentFame = player.Client.Account.Fame;
            player.Name = player.Client.Account.Name;
            player.NameChosen = true;
        }
    }
}
