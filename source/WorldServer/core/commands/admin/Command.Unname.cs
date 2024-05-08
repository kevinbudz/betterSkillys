using Shared;
using Shared.database;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Unname : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "unname";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (string.IsNullOrWhiteSpace(args))
                {
                    player.SendInfo("Usage: /unname <player name>");
                    return false;
                }

                var playerName = args;

                var id = player.GameServer.Database.ResolveId(playerName);
                if (id == 0)
                {
                    player.SendError("Player account not found!");
                    return false;
                }

                string lockToken = null;
                var key = Database.NAME_LOCK;
                var db = player.GameServer.Database;

                try
                {
                    while ((lockToken = db.AcquireLock(key)) == null) ;

                    var acc = db.GetAccount(id);
                    if (acc == null)
                    {
                        player.SendError("Account doesn't exist.");
                        return false;
                    }

                    using (var l = db.Lock(acc))
                        if (db.LockOk(l))
                        {
                            while (!db.UnnameIGN(acc, lockToken)) ;
                            player.SendInfo("Account succesfully unnamed.");
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
