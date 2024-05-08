using Shared;
using Shared.database;
using NLog.LayoutRenderers;
using System.Linq;
using System.Text.RegularExpressions;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class BanIP : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "banip";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var manager = player.GameServer;
                var db = manager.Database;

                // validate command
                var rgx = new Regex(@"^(\w+) (.+)$");
                var match = rgx.Match(args);
                if (!match.Success)
                {
                    player.SendError("Usage: /banip <account id or name> <reason>");
                    return false;
                }

                // get info from args
                var idstr = match.Groups[1].Value;
                if (!int.TryParse(idstr, out int id))
                {
                    id = db.ResolveId(idstr);
                }
                var reason = match.Groups[2].Value;

                // run checks
                if (Database.GuestNames.Any(n => n.ToLower().Equals(idstr.ToLower())))
                {
                    player.SendError("If you specify a player name to ban, the name needs to be unique.");
                    return false;
                }
                if (id == 0)
                {
                    player.SendError("Account not found...");
                    return false;
                }
                if (string.IsNullOrWhiteSpace(reason))
                {
                    player.SendError("A reason must be provided.");
                    return false;
                }

                var acc = db.GetAccount(id);
                if (string.IsNullOrEmpty(acc.IP))
                {
                    player.SendError("Failed to ip ban player. IP not logged...");
                    return false;
                }

                if (player.AccountId != acc.AccountId && acc.IP.Equals(player.Client.Account.IP))
                {
                    player.SendError("IP ban failed. That action would cause yourself to be banned (IPs are the same).");
                    return false;
                }

                // ban
                db.Ban(acc.AccountId, reason);
                db.BanIp(acc.IP, reason);

                // disconnect currently connected
                var targets = manager.ConnectionManager.Clients.Keys.Where(_ => _.IpAddress.Equals(acc.IP));
                foreach(var target in targets)
                    target.Disconnect("BanIPCommand");

                // send notification
                player.SendInfo($"Banned {acc.Name} (both account and ip).");
                return true;
            }
        }
    }
}
