using Shared;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using WorldServer.core;
using WorldServer.core.miscfile;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Mute : Command
        {
            private static readonly Regex CmdParams = new Regex(@"^(\w+)( \d+)?$", RegexOptions.IgnoreCase);

            private readonly GameServer _manager;

            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "mute";

            public Mute(GameServer manager)
            {
                _manager = manager;
                _manager.DbEvents.Expired += HandleUnMute;
            }

            protected override bool Process(Player player, TickTime time, string args)
            {
                var match = CmdParams.Match(args);
                if (!match.Success)
                {
                    player?.SendError("Usage: /mute <player name> <time out in minutes>\\n" +
                                     "Time parameter is optional. If left out player will be muted until unmuted.");
                    return false;
                }

                // gather arguments
                var name = match.Groups[1].Value;
                var id = _manager.Database.ResolveId(name);
                var acc = _manager.Database.GetAccount(id);
                int timeout;
                if (string.IsNullOrEmpty(match.Groups[2].Value))
                {
                    timeout = -1;
                }
                else
                {
                    int.TryParse(match.Groups[2].Value, out timeout);
                }

                // run through checks
                if (id == 0 || acc == null)
                {
                    player?.SendError("Account not found!");
                    return false;
                }
                if (acc.IP == null)
                {
                    player?.SendError("Account has no associated IP address. Player must login at least once before being muted.");
                    return false;
                }
                if (acc.IP.Equals(player?.Client.Account.IP))
                {
                    player?.SendError("Mute failed. That action would cause yourself to be muted (IPs are the same).");
                    return false;
                }
                if (player.IsAdmin)
                {
                    player?.SendError("Cannot mute other admins.");
                    return false;
                }

                // mute player if currently connected
                var client = _manager.ConnectionManager.Clients
                    .Keys.Where(_ => _.Player != null
                        && _.IpAddress.Equals(acc.IP)
                        && !_.Rank.IsAdmin)
                    .SingleOrDefault();
                if (client != default)
                    client.Player.Muted = true;

                if (player != null)
                {
                    if (timeout > 0)
                        _manager.ChatManager.SendInfo(id, "You have been muted by " + player.Name + " for " + timeout + " minutes.");
                    else
                        _manager.ChatManager.SendInfo(id, "You have been muted by " + player.Name + ".");
                }

                // mute ip address
                if (timeout < 0)
                {
                    _manager.Database.Mute(acc.IP);
                    player?.SendInfo(name + " successfully muted indefinitely.");
                }
                else
                {
                    _manager.Database.Mute(acc.IP, TimeSpan.FromMinutes(timeout));
                    player?.SendInfo(name + " successfully muted for " + timeout + " minutes.");
                }

                return true;
            }

            private void HandleUnMute(object entity, DbEventArgs expired)
            {
                var key = expired.Message;

                if (!key.StartsWith("mutes:"))
                    return;

                var client = _manager.ConnectionManager.Clients
                    .Keys.SingleOrDefault(_ => _.Player != null
                        && _.IpAddress.Equals(key.Substring(6))
                        && !_.Rank.IsAdmin);
                if (client == default)
                    return;

                client.Player.Muted = false;
                client.Player.SendInfo("You are no longer muted. Please do not spam. Thank you.");
            }
        }
    }
}
