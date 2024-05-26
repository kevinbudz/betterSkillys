using Shared;
using Shared.database;
using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Rename : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "rename";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var index = args.IndexOf(' ');
                if (string.IsNullOrWhiteSpace(args) || index == -1)
                {
                    player.SendInfo("Usage: /rename <player name> <new player name>");
                    return false;
                }

                var playerName = args.Substring(0, index);
                var newPlayerName = args.Substring(index + 1);

                var id = player.GameServer.Database.ResolveId(playerName);
                if (id == 0)
                {
                    player.SendError("Player account not found!");
                    return false;
                }

                if (newPlayerName.Length < 3 || newPlayerName.Length > 15 || !newPlayerName.All(char.IsLetter) ||
                    Database.GuestNames.Contains(newPlayerName, StringComparer.InvariantCultureIgnoreCase))
                {
                    player.SendError("New name is invalid. Must be between 3-15 char long and contain only letters.");
                    return false;
                }

                string lockToken = null;
                var key = Database.NAME_LOCK;
                var db = player.GameServer.Database;

                try
                {
                    while ((lockToken = db.AcquireLock(key)) == null) ;

                    if (db.Conn.HashExists("names", newPlayerName.ToUpperInvariant()))
                    {
                        player.SendError("Name already taken");
                        return false;
                    }

                    var acc = db.GetAccount(id);
                    if (acc == null)
                    {
                        player.SendError("Account doesn't exist.");
                        return false;
                    }

                    using (var accountLock = db.LockAccount(acc))
                        if (accountLock.HasLock)
                        {
                            while (!db.RenameIGN(acc, newPlayerName, lockToken)) ;
                            player.SendInfo("Rename successful.");
                        }
                        else
                            player.SendError("Account in use.");
                }
                finally
                {
                    if (lockToken != null)
                        db.ReleaseLock(key, lockToken);
                }

                return true;
            }
        }
    }
}
