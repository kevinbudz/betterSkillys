using Shared;
using System.Text.RegularExpressions;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class UnbanAccount : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "unban";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var db = player.GameServer.Database;

                // validate command
                var rgx = new Regex(@"^(\w+)$");
                if (!rgx.IsMatch(args))
                {
                    player.SendError("Usage: /unban <account id or name>");
                    return false;
                }

                // get info from args
                if (!int.TryParse(args, out int id))
                    id = db.ResolveId(args);

                // run checks
                if (id == 0)
                {
                    player.SendError("Account doesn't exist...");
                    return false;
                }

                var acc = db.GetAccount(id);

                // unban
                var banned = db.UnBan(id);
                var ipBanned = acc.IP != null && db.UnBanIp(acc.IP);

                // send notification
                if (!banned && !ipBanned)
                {
                    player.SendInfo($"{acc.Name} wasn't banned...");
                    return true;
                }
                if (banned && ipBanned)
                {
                    player.SendInfo($"Success! {acc.Name}'s account and IP no longer banned.");
                    return true;
                }
                if (banned)
                {
                    player.SendInfo($"Success! {acc.Name}'s account no longer banned.");
                    return true;
                }

                player.SendInfo($"Success! {acc.Name}'s IP no longer banned.");
                return true;
            }
        }
    }
}
