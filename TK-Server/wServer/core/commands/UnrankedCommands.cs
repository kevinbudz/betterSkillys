﻿using CA.Extensions.Concurrent;
using common;
using common.database;
using common.isc.data;
using common.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using wServer.core.objects;
using wServer.core.worlds;
using wServer.core.worlds.logic;
using wServer.logic.loot;
using wServer.core.net.handlers;
using wServer.networking.packets.outgoing;
using File = TagLib.File;

namespace wServer.core.commands
{

    #region Party

    internal class PartyChatCommand : Command
    {
        public PartyChatCommand() : base("p", alias: "party")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.Client.Account.Reload("partyId");

            if (!player.NameChosen)
            {
                player.SendError("Choose a name!");
                return false;
            }

            if (player.Muted)
            {
                player.SendError("Muted. You can not use Party Chat at this time.");
                return false;
            }

            if (player.Client.Account.PartyId == 0)
            {
                player.SendError("You need to be in a Party to use this chat.");
                return false;
            }

            return player.GameServer.ChatManager.Party(player, args);
        }
    }

    internal class AcceptParty : Command
    {
        public AcceptParty() : base("paccept")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            try
            {
                if (String.IsNullOrWhiteSpace(args))
                {
                    player.SendInfo("Usage: /paccept <party id>");
                    return false;
                }

                //player.Client.ProcessPacket(new JoinPartyHandler()
                //{
                //    PartyId = args.ToInt32()
                //}, ref time);
                return true;
            }
            catch (Exception e)
            {
                //SLogger.Instance.Warn(e);
                return false;
            }
        }
    }

    internal class CloseParty : Command
    {
        public CloseParty() : base("pclose")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            try
            {
                var db = player.Client.Account.Database;

                player.Client.Account.Reload("partyId");

                if (player.Client.Account.PartyId == 0)
                {
                    player.SendError("You're not in a Party!");
                    return false;
                }

                var party = DbPartySystem.Get(db, player.Client.Account.PartyId);

                if (party == null)
                {
                    player.SendError("You're not in a Party!");
                    return false;
                }

                if (!party.LeaderIsVip(player.GameServer.Database))
                {
                    player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                    return false;
                }

                if (player.Client.Account.Name != party.PartyLeader.Item1)
                {
                    player.SendError("You're not the leader of this Party, use /pleave instead.");
                    return false;
                }

                Database DB = player.GameServer.Database;

                HashSet<DbAccount> members = new HashSet<DbAccount>();
                foreach (var member in party.PartyMembers)
                {
                    members.Add(DB.GetAccount(member.accid));
                }

                DB.RemoveParty(player.Client.Account, members, player.Client.Account.PartyId);
            }
            catch (Exception e)
            {
                //SLogger.Instance.Warn(e);
                return false;
            }

            player.SendInfo("Party closed successfully!");

            return true;
        }
    }

    internal class LeaveParty : Command
    {
        public LeaveParty() : base("pleave")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var db = player.Client.Account.Database;

            player.Client.Account.Reload("partyId");

            try
            {
                var party = DbPartySystem.Get(db, player.Client.Account.PartyId);

                if (party != null)
                {
                    if (!party.LeaderIsVip(player.GameServer.Database))
                    {
                        player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                        return false;
                    }
                    if (player.Name == party.PartyLeader.Item1)
                    {
                        player.SendError("You're the leader of this Party. Use /pclose to close this Party.");
                        return false;
                    }
                    else
                    {
                        player.GameServer.Database.LeaveFromParty(db, player.Name, player.Client.Account.PartyId, player.GameServer.Database);
                        player.GameServer.ChatManager.Party(player, player.Name + " has left the Party!");
                    }
                }
                else
                {
                    player.SendError("You're not in a Party!");
                    return false;
                }
            }
            catch (Exception e)
            {
                //SLogger.Instance.Warn(e);
                return false;
            }

            player.SendInfo("You have left the Party.");
            player.InvokeStatChange(StatDataType.PartyId, player.Client.Account.PartyId, true);
            return true;
        }
    }

    internal class InviteParty : Command
    {
        public InviteParty() : base("pinvite")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var db = player.Client.Account.Database;

            player.Client.Account.Reload("partyId");

            var party = DbPartySystem.Get(db, player.Client.Account.PartyId);

            if (party != null && !party.LeaderIsVip(player.GameServer.Database) || !player.CanUseThisFeature(Player.GenericRank.VIP))
            {
                player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                return false;
            }

            if (party == null)
            {
                var nextId = DbPartySystem.NextId(db);

                party = new DbPartySystem(db, nextId)
                {
                    PartyId = nextId,
                    PartyLeader = (player.Client.Account.Name, player.Client.Account.AccountId),
                    PartyMembers = new List<DbMemberData>(DbPartySystem.ReturnSize(player.Client.Account.Rank))
                };
                party.Flush();

                player.Client.Account.PartyId = party.PartyId;

                player.Client.Account.FlushAsync();
                player.Client.Account.Reload("partyId");

                player.SendInfo("Party created Successfully!");
            }

            if (party == null)
            {
                player.SendError("You're not in a Party!");
                return false;
            }

            if (party.PartyLeader.Item1 != player.Client.Account.Name)
            {
                player.SendError("Only the leader can do this!");
                return false;
            }

            if (String.IsNullOrEmpty(args))
            {
                player.SendInfo("Usage: /pinvite <playername>");
                return false;
            }

            foreach (var client in player.GameServer.ConnectionManager.Clients.Keys)
            {
                if (!client.Account.Name.EqualsIgnoreCase(args) || client.Player == null || client.Account == null)
                    continue;

                if (client == null)
                {
                    player.SendError("Player not found.");
                    return false;
                }

                client.Account.Reload("partyId");

                if (client.Account.PartyId != 0)
                {
                    player.SendError("He is already in a Party!");
                    client.Account.Reload("partyId");
                    return false;
                }

                client.SendPacket(new InvitedToParty()
                {
                    Name = player.Client.Account.Name,
                    PartyId = player.Client.Account.PartyId
                });

                player.SendInfo($"Invited successfully {client.Account.Name} to your Party!");
                return true;
            }

            return false;
        }
    }

    internal class RemoveFromParty : Command
    {
        public RemoveFromParty() : base("premove")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.Client.Account.Reload("partyId");

            var party = DbPartySystem.Get(player.Client.Account.Database, player.Client.Account.PartyId);

            if (party == null)
            {
                player.SendError("You're not in a Party!");
                return false;
            }

            if (!party.LeaderIsVip(player.GameServer.Database))
            {
                player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                return false;
            }

            if (party.PartyLeader.Item1 != player.Name || party.PartyLeader.Item2 != player.AccountId)
            {
                player.SendError("Only the Leader of the Party can do this!");
                return false;
            }

            if (args == player.Name)
            {
                player.SendError("You can't remove yourself!");
                return false;
            }

            if (String.IsNullOrEmpty(args))
            {
                player.SendInfo("Usage: /premove <playername>");
                return false;
            }

            foreach (var member in party.PartyMembers)
            {
                if (member.name.EqualsIgnoreCase(args))
                {
                    var db = player.GameServer.Database;
                    var acc = db.GetAccount(member.accid);

                    acc.PartyId = 0;
                    acc.FlushAsync();
                    acc.Reload("partyId");

                    party.PartyMembers.Remove(member);
                    db.FlushParty(party.PartyId, party);

                    var playerDemoted = player.GameServer.ConnectionManager.Clients.Keys.Where(c => c.Player != null && c.Player.Name == member.name && c.Player.AccountId == member.accid).Select(c => c.Player).ToArray();

                    if (playerDemoted != null)
                    {
                        playerDemoted[0].SendError($"You have been removed from the Party of {party.PartyLeader.Item1}.");
                        playerDemoted[0].InvokeStatChange(StatDataType.PartyId, playerDemoted[0].Client.Account.PartyId, true);
                    }

                    player.GameServer.ChatManager.Party(player, player.Name + " has been removed from the Party.");
                    player.SendInfo($"{acc.Name} removed from the Party.");
                    return true;
                }
                else
                {
                    player.SendError("Player not found.");
                    return false;
                }
            }

            player.SendError("Player not found.");
            return false;
        }
    }

    internal class JoinWorldParty : Command
    {
        public JoinWorldParty() : base("pjoin")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var party = DbPartySystem.Get(player.Client.Account.Database, player.Client.Account.PartyId);

            if (party == null)
            {
                player.SendError("You're not in a Party.");
                return false;
            }

            if (!party.LeaderIsVip(player.GameServer.Database))
            {
                player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                return false;
            }

            var leader = player.GameServer.ConnectionManager.Clients.Keys.Where(c => c.Player != null && c.Player.Name == party.PartyLeader.Item1 && c.Player.AccountId == party.PartyLeader.Item2 && c.Account.PartyId == party.PartyId).Select(c => c.Player).ToArray();

            if (leader == null)
            {
                player.SendError("The Leader of the Party is disconnected.");
                return false;
            }
            if (leader[0].Name == player.Name)
            {
                player.SendError("You're the Leader...");
                return false;
            }

            var world = player.GameServer.WorldManager.GetWorld(leader[0].World.Id);

            if (world == null)
            {
                player.GameServer.Database.FlushParty(party.PartyId, party);
                player.SendError("World doesn't exists.");
                return false;
            }
            if (world.Id != party.ReturnWorldId() || party.ReturnWorldId() == -1 && world != null)
            {
                player.GameServer.Database.FlushParty(party.PartyId, party);
                player.SendError("You need an invitation to join to the world!");
                return false;
            }
            if (party.ReturnWorldId() != -1 && (world.InstanceType == WorldResourceInstanceType.Guild || world is VaultWorld || world is NexusWorld))
            {
                party.WorldId = -1;
                player.GameServer.Database.FlushParty(party.PartyId, party);
                player.SendError("You can't connect to those Worlds.");
                return false;
            }

            player.SendInfo("Connecting!");
            player.Reconnect(world);

            return true;
        }
    }

    internal class InviteWorldParty : Command
    {
        public InviteWorldParty() : base("pinviteworld")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            try
            {
                var party = DbPartySystem.Get(player.Client.Account.Database, player.Client.Account.PartyId);

                if (party == null)
                {
                    player.SendError("You're not in a Party!");
                    return false;
                }

                if (!party.LeaderIsVip(player.GameServer.Database))
                {
                    player.SendError("<Error> VIPs cannot be the Leader of a Party.");
                    return false;
                }

                if (party.PartyLeader.Item1 != player.Client.Account.Name && party.PartyLeader.Item2 != player.Client.Account.PartyId)
                {
                    player.SendError("You're not the leader of the Party!");
                    return false;
                }

                var world = player.World;

                if (world == null) return false;

                if (world is VaultWorld || world is MarketplaceWorld || world.InstanceType == WorldResourceInstanceType.Guild  || world is Test)
                {
                    player.SendError("You can't invite players to this World.");
                    return false;
                }

                if (party.WorldId == player.World.Id)
                {
                    player.SendError("Already invited your Party Members to this World!");
                    return false;
                }

                party.WorldId = player.World.Id;

                try
                {
                    player.GameServer.Database.FlushParty(party.PartyId, party);
                }
                catch (Exception e)
                {
                    //SLogger.Instance.Warn(e);
                    return false;
                }

                foreach (var member in party.PartyMembers)
                {
                    var clientMember = player.GameServer.ConnectionManager.Clients.Keys.Where(c => c.Player != null && c.Account.Name == member.name && c.Account.AccountId == member.accid).Select(c => c.Player).ToArray();
                    clientMember[0].SendInfo($"You have invited to a {world.IdName ?? world.DisplayName}! use the command /pjoin to connect!");
                    return true;
                }
            }
            catch (Exception e)
            {
                //SLogger.Instance.Warn(e);
                return false;
            }

            return true;
        }
    }

    internal class PartyCommandsInfo : Command
    {
        public PartyCommandsInfo() : base("pcommands")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.SendInfo("Party Commands: \n/p <text> -> Party Chat.\n/paccept <partyId> -> accept an Invitation of a Party.\n/pinvite <name> -> Invite a Player to your Party (Only Leader).\n/premove <name> -> Remove a Player from your Party (Only Leader).\n/pleave -> Leave from the Party.\n/pclose -> Close a Party (Only Leader).\n/pjoin -> Join the World you were invited.\n/pinviteworld -> Invite a Player to your World (Only Leader).\n/pinfo -> Show information about your Party.\n/pcommands -> Show all Party Commands.");
            return true;
        }
    }

    internal class PartyInfo : Command
    {
        public PartyInfo() : base("pinfo")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var db = player.Client.Account.Database;
            var party = DbPartySystem.Get(db, player.Client.Account.PartyId);
            if (party == null)
            {
                player.SendInfo("You don't have a Party.");
                return false;
            }

            player.SendInfo("Party Information: ");
            player.SendInfo($"Party ID: {party.PartyId}");
            player.SendInfo($"Party Leader => Name: {party.PartyLeader.Item1}");
            player.SendInfo($"Party Max Players: {DbPartySystem.ReturnSize(player.GameServer.Database.GetAccount(party.PartyLeader.Item2).Rank)}");
            player.SendInfo("Members: ");
            foreach (var member in party.PartyMembers)
            {
                player.SendInfo($"Member => Name: {member.name}");
            }
            return true;
        }
    }

    #endregion Party

    internal class CheckGuildPoints : Command
    {
        public CheckGuildPoints() : base("checkguildpoints", alias: "cgp")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (player.Guild == null)
            {
                player.SendError("Must join a guild first!");
                return false;
            }
            var account = player.GameServer.Database.GetAccount(player.AccountId);
            var guild = player.GameServer.Database.GetGuild(account.GuildId);
            player.SendInfo("Total Guild Points: " + guild.GuildPoints);
            return true;
        }
    }

    internal class CurrentSongCommand : Command
    {
        public CurrentSongCommand() : base("currentsong", alias: "song") { }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var properName = player.World.Music;
            var file = File.Create(Environment.CurrentDirectory + $"/resources/web/music/{properName}.mp3");
            var artist = file.Tag.FirstPerformer ?? "Unknown";
            var title = file.Tag.Title ?? properName;
            var album = file.Tag.Album != null ? $" from {file.Tag.Album}" : "";
            var filename = $" ({properName}.mp3)";

            player.SendInfo($"Current Song: {title} by {artist}{album}{filename}.");
            return true;
        }
    }

    internal class CheckEnemiesKilled : Command
    {
        public CheckEnemiesKilled() : base("checkenemieskilled", alias: "cek")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var account = player.GameServer.Database.GetAccount(player.AccountId);
            player.SendInfo("Enemies Killed: " + account.EnemiesKilled);
            return true;
        }
    }

    internal class CheckAccId : Command
    {
        public CheckAccId() : base("checkid")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (!player.NameChosen)
            {
                player.SendError("Need to choose a name before!");
                return false;
            }

            player.SendInfo($"Your Acc id is: {player.Client.Account.AccountId}");
            player.SendInfo($"Your Player Id is: {player.Id}");
            return true;
        }
    }

    internal class CheckLoot : Command
    {
        public CheckLoot() : base("checkloot")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var lootBoost = Loot.GetPlayerLootBoost(player);

            //if (talismanofluck > 0) player.SendInfo($"Your Talisman of Luck give's you {talismanofluck}% Loot Boost!");
            //if (player.Node5TickMin > 0) player.SendInfo($"Your attributes provide you with an extra {treeNodeLoot}% Loot Boost!");
            ////if (treeNodeLoot > 0) player.SendInfo($"Your points in the Skill Tree gives you {skillTreeLoot}% Loot Boost!");
            ////if (donorloot > 0) player.SendInfo($"For supporting TK and donating you get an extra {donorloot}% Loot Boost!");
            //if (player.LDBoostTime > 0) player.SendInfo($"You have activated a Loot Drop Potion! This gives you an extra {lootDropBoost}% Loot Boost");
            //if (talismans > 0) player.SendInfo($"Your Talisman's of Looting gives you a total of {talismans}% Loot Boost!");
            //if (guildLootBoost > 0) player.SendInfo($"Your Guild gives you a {guildLootBoost}% Loot Boost!");

            player.SendInfo($"You have {Math.Round(lootBoost * 100.0f, 3)}% increased loot chance");
            player.SendInfo($"This will breakdown sources in the future");

            //player.SendInfo($"You have {lootBoosts}% Loot Boost{(eventRate != 1.0 ? $" (event multiplier: {eventRate}x)" : "")}!");
            return true;
        }
    }

    internal class ClothBazaarCommand : Command
    {
        public ClothBazaarCommand() : base("clothbazaar")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.Client.Reconnect(new Reconnect()
            {
                Host = "",
                Port = player.GameServer.Configuration.serverInfo.port,
                GameId = World.ClothBazaar,
                Name = "Cloth Bazaar"
            });
            return true;
        }
    }

    internal class GCommand : Command
    {
        public GCommand() : base("g", alias: "guild")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (!player.NameChosen)
            {
                player.SendError("Choose a name!");
                return false;
            }

            //if (player.Stars < 10 && player.Rank < 10)
            //{
            //    player.SendHelp("To use this feature you need 10 stars or D-1 rank.");
            //    return false;
            //}

            if (player.Muted)
            {
                player.SendError("Muted. You can not guild chat at this time.");
                return false;
            }

            if (String.IsNullOrEmpty(player.Guild))
            {
                player.SendError("You need to be in a guild to guild chat.");
                return false;
            }

            return player.GameServer.ChatManager.Guild(player, args);
        }
    }

    internal class GhallCommand : Command
    {
        public GhallCommand() : base("ghall")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (player.GuildRank < 0)
            {
                player.SendError("You need to be in a guild.");
                return false;
            }

            //var proto = player.CoreServerManager.Resources.Worlds["GuildHall"];
            //var world = player.CoreServerManager.WorldManager.GetWorld(proto.id);
            //player.Reconnect(world.GetInstance(player.Client));
            return true;
        }
    }

    internal class GLandCommand : Command
    {
        public GLandCommand() : base("gland", alias: "glands")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (!(player.World is RealmWorld))
            {
                player.SendError("This command requires you to be in realm first.");
                return false;
            }

            if (!player.TPCooledDown())
            {
                player.SendError("Too soon to teleport again!");
                return false;
            }
            else
            {
                player.TeleportPosition(time, 970, 1020);
                player.ApplyConditionEffect(ConditionEffectIndex.Invulnerable, 3000);
                player.ApplyConditionEffect(ConditionEffectIndex.Invisible, 3000);
                player.ApplyConditionEffect(ConditionEffectIndex.Stunned, 3000);
                player.ApplyConditionEffect(ConditionEffectIndex.Paralyzed, 3000);
            }

            return true;
        }
    }

    internal class GuildInviteCommand : Command
    {
        public GuildInviteCommand() : base("invite", alias: "ginvite")
        {
        }

        protected override bool Process(Player player, TickTime time, string playerName)
        {
            if (player.World is Test)
                return false;

            if (player.Client.Account.GuildRank < 20)
            {
                player.SendError("Insufficient privileges.");
                return false;
            }

            var targetAccId = player.Client.GameServer.Database.ResolveId(playerName);
            if (targetAccId == 0)
            {
                player.SendError("Player not found");
                return false;
            }

            var targetClient = player.Client.GameServer.ConnectionManager.Clients
                .KeyWhereAsParallel(_ => _.Account != null && _.Account.AccountId == targetAccId)
                .FirstOrDefault();

            var servers = player.GameServer.InterServerManager.GetServerList();
            foreach (var server in servers)
            {
                foreach (PlayerInfo plr in server.playerList)
                {
                    if (plr.Hidden)
                    {
                        player.SendError("Could not find the player to invite.");
                        return false;
                    }
                }
            }
            if (targetClient != null)
            {
                if (targetClient.Player == null ||
                    targetClient.Account == null ||
                    !targetClient.Account.Name.Equals(playerName))
                {
                    player.SendError("Could not find the player to invite.");
                    return false;
                }

                if (!targetClient.Account.NameChosen)
                {
                    player.SendError("Player needs to choose a name first.");
                    return false;
                }

                if (targetClient.Account.GuildId > 0)
                {
                    player.SendError("Player is already in a guild.");
                    return false;
                }

                targetClient.Player.GuildInvite = player.Client.Account.GuildId;

                targetClient.SendPacket(new InvitedToGuild()
                {
                    Name = player.Name,
                    GuildName = player.Guild
                });
                return true;
            }

            player.SendError("Could not find the player to invite.");
            return false;
        }
    }

    internal class GuildKickCommand : Command
    {
        public GuildKickCommand() : base("gkick")
        {
        }

        protected override bool Process(Player player, TickTime time, string name)
        {
            if (player.World is Test)
                return false;

            var manager = player.Client.GameServer;

            // if resigning
            if (player.Name.Equals(name))
            {
                // chat needs to be done before removal so we can use
                // srcPlayer as a source for guild info
                manager.ChatManager.Guild(player, player.Name + " has left the guild.");

                if (!manager.Database.RemoveFromGuild(player.Client.Account))
                {
                    player.SendError("Guild not found.");
                    return false;
                }

                player.Guild = "";
                player.GuildRank = 0;

                return true;
            }

            // get target account id
            var targetAccId = manager.Database.ResolveId(name);
            if (targetAccId == 0)
            {
                player.SendError("Player not found");
                return false;
            }

            // find target player (if connected)
            var targetClient = player.Client.GameServer.ConnectionManager.Clients
                .KeyWhereAsParallel(_ => _.Account != null && _.Account.AccountId == targetAccId)
                .FirstOrDefault();

            // try to remove connected member
            if (targetClient != null)
            {
                if (player.Client.Account.GuildRank >= 20 &&
                    player.Client.Account.GuildId == targetClient.Account.GuildId &&
                    player.Client.Account.GuildRank > targetClient.Account.GuildRank)
                {
                    var targetPlayer = targetClient.Player;

                    if (!manager.Database.RemoveFromGuild(targetClient.Account))
                    {
                        player.SendError("Guild not found.");
                        return false;
                    }

                    targetPlayer.Guild = "";
                    targetPlayer.GuildRank = 0;

                    manager.ChatManager.Guild(player, targetPlayer.Name + " has been kicked from the guild by " + player.Name);
                    targetPlayer.SendInfo("You have been kicked from the guild.");
                    return true;
                }

                player.SendError("Can't remove member. Insufficient privileges.");
                return false;
            }

            // try to remove member via database
            var targetAccount = manager.Database.GetAccount(targetAccId);

            if (player.Client.Account.GuildRank >= 20 &&
                player.Client.Account.GuildId == targetAccount.GuildId &&
                player.Client.Account.GuildRank > targetAccount.GuildRank)
            {
                if (!manager.Database.RemoveFromGuild(targetAccount))
                {
                    player.SendError("Guild not found.");
                    return false;
                }

                manager.ChatManager.Guild(player, targetAccount.Name + " has been kicked from the guild by " + player.Name);
                return true;
            }

            player.SendError("Can't remove member. Insufficient privileges.");
            return false;
        }
    }

    internal class GuildWhoCommand : Command
    {
        public GuildWhoCommand() : base("gwho", alias: "mates")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (player.Client.Account.GuildId == 0)
            {
                player.SendError("You are not in a guild!");
                return false;
            }

            var pServer = player.GameServer.Configuration.serverInfo.name;
            var pGuild = player.Client.Account.GuildId;
            var servers = player.GameServer.InterServerManager.GetServerList();
            var result =
                from server in servers
                from plr in server.playerList
                where plr.GuildId == pGuild
                group plr by server;

            player.SendInfo("Guild members online:");

            foreach (var group in result)
            {
                var server = (pServer == group.Key.name) ? $"[{group.Key.name}]" : group.Key.name;
                var players = group.ToArray();
                var sb = new StringBuilder($"{server}: ");
                for (var i = 0; i < players.Length; i++)
                {
                    if (players[i].Hidden)
                        continue;
                    else
                        sb.Append(players[i].Name + ", ");
                }
                player.SendInfo(sb.ToString());
            }
            return true;
        }
    }

    internal class HelpCommand : Command
    {
        //actually the command is 'help', but /help is intercepted by client
        public HelpCommand() : base("commands") { }

        protected override bool Process(Player player, TickTime time, string args)
        {
            StringBuilder sb = new StringBuilder("Available commands: ");
            var cmds = player.GameServer.CommandManager.Commands.Values.Distinct()
                .Where(x => x.HasPermission(player) && x.ListCommand)
                .ToArray();
            Array.Sort(cmds, (c1, c2) => c1.CommandName.CompareTo(c2.CommandName));
            for (int i = 0; i < cmds.Length; i++)
            {
                if (i != 0) sb.Append(", ");
                sb.Append(cmds[i].CommandName);
            }

            player.SendInfo(sb.ToString());
            return true;
        }
    }

    internal class IgnoreCommand : Command
    {
        public IgnoreCommand() : base("ignore")
        {
        }

        protected override bool Process(Player player, TickTime time, string playerName)
        {
            if (player.World is Test)
                return false;

            if (String.IsNullOrEmpty(playerName))
            {
                player.SendError("Usage: /ignore <player name>");
                return false;
            }

            if (player.Name.ToLower() == playerName.ToLower())
            {
                player.SendInfo("Can't ignore yourself!");
                return false;
            }

            var target = player.GameServer.Database.ResolveId(playerName);
            var targetAccount = player.GameServer.Database.GetAccount(target);
            var srcAccount = player.Client.Account;

            if (target == 0 || targetAccount == null || targetAccount.Hidden && player.Rank < 100)
            {
                player.SendError("Player not found.");
                return false;
            }

            player.GameServer.Database.IgnoreAccount(srcAccount, targetAccount, true);

            player.Client.SendPacket(new AccountList()
            {
                AccountListId = 1, // ignore list
                AccountIds = srcAccount.IgnoreList
                    .Select(i => i.ToString())
                    .ToArray()
            });

            player.SendInfo(playerName + " has been added to your ignore list.");
            return true;
        }
    }

    internal class imNotGuest : Command
    {
        public imNotGuest() : base("imNotGuest")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (!player.NameChosen)
            {
                player.SendError("Need to choose a name before!");
                return false;
            }

            player.Client.Account.Guest = false;
            player.SendInfo("You're not more a Guest!");
            return true;
        }
    }

    internal class JoinGuildCommand : Command
    {
        public JoinGuildCommand() : base("join")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            //player.Client.ProcessPacket(new JoinGuildHandler()
            //{
            //    GuildName = args
            //}, ref time);
            return true;
        }
    }

    internal class LockCommand : Command
    {
        public LockCommand() : base("lock")
        {
        }

        protected override bool Process(Player player, TickTime time, string playerName)
        {
            if (player.World is Test)
                return false;

            if (String.IsNullOrEmpty(playerName))
            {
                player.SendError("Usage: /lock <player name>");
                return false;
            }

            if (player.Name.ToLower() == playerName.ToLower())
            {
                player.SendInfo("Can't lock yourself!");
                return false;
            }

            var target = player.GameServer.Database.ResolveId(playerName);
            var targetAccount = player.GameServer.Database.GetAccount(target);
            var srcAccount = player.Client.Account;

            if (target == 0 || targetAccount == null || targetAccount.Hidden && player.Rank < 100)
            {
                player.SendError("Player not found.");
                return false;
            }

            player.GameServer.Database.LockAccount(srcAccount, targetAccount, true);

            player.Client.SendPacket(new AccountList()
            {
                AccountListId = 0, // locked list
                AccountIds = player.Client.Account.LockList
                    .Select(i => i.ToString())
                    .ToArray()
            });

            player.SendInfo(playerName + " has been locked.");
            return true;
        }
    }

    internal class MarketplaceCommand : Command
    {
        public MarketplaceCommand() : base("marketplace")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var worlds = player.GameServer.WorldManager.GetWorlds();
            foreach(var w in worlds)
                if(w.IdName.Contains("Market"))
                {
                    player.Reconnect(w);
                    break;
                }
            return true;
        }
    }

    internal class NexusCommand : Command
    {
        public NexusCommand() : base("nexus")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.Client.Reconnect(new Reconnect()
            {
                Host = "",
                Port = player.GameServer.Configuration.serverInfo.port,
                GameId = World.Nexus,
                Name = "Nexus"
            });
            return true;
        }
    }

    internal class PauseCommand : Command
    {
        public PauseCommand() : base("pause")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (player.HasConditionEffect(ConditionEffects.Paused))
            {
                player.ApplyConditionEffect(new ConditionEffect()
                {
                    Effect = ConditionEffectIndex.Paused,
                    DurationMS = 0
                });
                player.SendInfo("Game resumed.");
                return true;
            }

            if (!(player.World is VaultWorld) || !(player.World is NexusWorld) || !(player.World.InstanceType == WorldResourceInstanceType.Guild) || !(player.World is MarketplaceWorld) || !(player.World.Id != World.ClothBazaar))
            {
                player.SendError("Not safe to pause.");
                return false;
            }

            player.ApplyConditionEffect(new ConditionEffect()
            {
                Effect = ConditionEffectIndex.Paused,
                DurationMS = -1
            });
            player.SendInfo("Game paused.");
            return true;
        }
    }

    internal class PositionCommand : Command
    {
        public PositionCommand() : base("pos", alias: "position")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            player.SendInfo("Current Position: " + (int)player.X + ", " + (int)player.Y);
            return true;
        }
    }

    internal class RealmCommand : Command
    {
        public RealmCommand() : base("realm")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var worlds = player.GameServer.WorldManager.GetRealms();
            if(worlds.Count == 0)
            {
                player.SendInfo("Unable to find a realm.");
                return true;
            }

            var random = new Random();
            var world = worlds[random.Next(worlds.Count)];

            if (world.IsPlayersMax())
            {
                player.SendError("Dungeon is full");
                return true;
            }

            player.Reconnect(world);
            return true;
        }
    }

    internal class RestartWhen : Command
    {
        public RestartWhen() : base("rwhen")
        {
        }

        protected override bool Process(Player player, TickTime time, string color)
        {
            //var end = Program.Restarter.GetRestartTime();
            //var timeLeft = end.Subtract(DateTime.UtcNow);

            //player.SendInfo(string.Format(
            //    "The server will be restarted at {0} (on {5}) UTC (countdown: {1}d {2}h {3}m {4}s).",
            //    end.ToString("dd MMM yyyy"),
            //    timeLeft.Days.ToString("D2"),
            //    timeLeft.Hours.ToString("D2"),
            //    timeLeft.Minutes.ToString("D2"),
            //    timeLeft.Seconds.ToString("D2"),
            //    end.ToString("dddd")
            //));
            return true;
        }
    }

    internal class ServerCommand : Command
    {
        public ServerCommand() : base("world")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var servers = player.GameServer.InterServerManager.GetServerList();
            int hidden = 0;
            foreach (var server in servers)
                foreach (PlayerInfo plr in server.playerList)
                {
                    if (plr.Hidden)
                    {
                        hidden++;
                    }
                }
            var currentPlayersNotIncludingHide = player.World.Players.Count - hidden;
            player.SendInfo($"[{player.World.Id}] {player.World.GetDisplayName()} ({currentPlayersNotIncludingHide} players)");
            return true;
        }
    }

    internal class ServersCommand : Command
    {
        public ServersCommand() : base("servers", alias: "svrs")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var playerSvr = player.GameServer.Configuration.serverInfo.name;
            var servers = player.GameServer.InterServerManager.GetServerList();
            var countClients = 0;
            var maxClients = 0;
            var countClientsTxt = "{CLIENTS}";
            var prefixClientsTxt = "{CLIENTS_PREFIX}";
            var maxClientsTxt = "{MAX_CLIENTS}";
            var countServers = servers.Length - 1;
            var sb = new StringBuilder($"There {(countServers > 1 ? "are" : "is")} {countServers} server{(countServers > 1 ? "s" : "")} with {countClientsTxt}/{maxClientsTxt} player{prefixClientsTxt} online:\n");

            foreach (var server in servers)
            {
                if (server.type != common.isc.ServerType.World) continue;

                countClients += server.players;
                maxClients += server.maxPlayers;

                sb.Append($"-> {server.name} ({server.players}/{server.maxPlayers})");

                if (server.name.Equals(playerSvr))
                    sb.Append(" << current server >>");

                if (server.adminOnly)
                    sb.Append(" [Admin]");

                sb.Append("\n");
            }

            var result = sb.ToString();
            result = result.Replace(countClientsTxt, countClients.ToString());
            result = result.Replace(maxClientsTxt, maxClients.ToString());
            result = result.Replace(prefixClientsTxt, countClients > 1 ? "s" : "");

            player.SendInfo(result);
            return true;
        }
    }

    internal class TeleportCommand : Command
    {
        public TeleportCommand() : base("tp", alias: "teleport")
        { }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var servers = player.GameServer.InterServerManager.GetServerList();
            string playerName = args.ToLower();
            foreach (var server in servers)
            {
                foreach (PlayerInfo plr in server.playerList)
                {
                    if (plr.Hidden && player.Rank < 100)
                    {
                        player.SendError($"Unable to find player: {args}");
                        return false;
                    }

                    if (player.Name.ToLower() == playerName)
                    {
                        player.SendError("You cannot teleport to yourself.");
                            return false;
                    }
                }
            }

            var targets = player.World.GetPlayers();
            foreach (var target in targets)
            {
                if (!target.Name.EqualsIgnoreCase(args))
                    continue;

                player.Teleport(time, target.Id, target.Admin > 0);
                player.ApplyConditionEffect(ConditionEffectIndex.Invulnerable, 2500);
                player.ApplyConditionEffect(ConditionEffectIndex.Stunned, 2500);
                return true;
            }

            player.SendError($"Unable to find player: {args}");
            return false;
        }
    }

    internal class TellCommand : Command
    {
        public TellCommand() : base("tell", alias: "t")
        { }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (!player.NameChosen)
            {
                player.SendError("Choose a name!");
                return false;
            }

            if (player.Muted)
            {
                player.SendError("Muted. You can not tell at this time.");
                return false;
            }

            //if (player.Stars < 2 && player.Rank < 10)
            //{
            //    player.SendHelp("To use this feature you need 2 stars or D-1 rank.");
            //    return false;
            //}

            int index = args.IndexOf(' ');
            if (index == -1)
            {
                player.SendError("Usage: /tell <player name> <text>");
                return false;
            }

            string playername = args.Substring(0, index);
            string msg = args.Substring(index + 1);

            if (player.Name.ToLower() == playername.ToLower())
            {
                player.SendInfo("Quit telling yourself!");
                return false;
            }

            if (!player.GameServer.ChatManager.Tell(player, playername, msg))
            {
                player.SendError(string.Format("{0} not found.", playername));
                return false;
            }

            return true;
        }
    }

    internal class TransferFame : Command
    {
        public TransferFame() : base("transferfame", alias: "tf")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (String.IsNullOrWhiteSpace(args))
            {
                player.SendError("Usage: /tf <amount>");
                return false;
            }
            var amount = (int)Utils.FromString(args);
            // SLogger.Instance.Info(player.Fame);
            if (amount > player.Fame)
            {
                player.SendError("Amount asked is greater than current fame");
                return false;
            }

            if (amount < 0)
            {
                player.SendError("Amount cannot be lower than 0");
                return false;
            }
            var acc = player.GameServer.Database.GetAccount(player.AccountId);
            //  SLogger.Instance.Info(acc.Fame);
            if (acc != null)
            {
                acc.Fame += amount;
                player.Fame -= amount;
                player.Experience -= amount * 1000;
                acc.FlushAsync();
                player.SendInfo($"Success! You have transferred {amount} into your account!");
                var clients = player.GameServer.ConnectionManager.Clients
                    .KeyWhereAsParallel(_ => _.Account.Name.EqualsIgnoreCase(player.Name));
                for (var i = 0; i < clients.Length; i++)
                    clients[i].Disconnect("Fame Transfer");
            }

            return true;
        }
    }

    internal class TradeCommand : Command
    {
        public TradeCommand() : base("trade")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            if (String.IsNullOrWhiteSpace(args))
            {
                player.SendError("Usage: /trade <player name>");
                return false;
            }

            //if (player.Stars < 2 && player.Rank < 10)
            //{
            //    player.SendHelp("To use this feature you need 2 stars or D-1 rank.");
            //    return false;
            //}

            if (player.Rank >= 60)
            {
                player.SendError("You cannot trade.");
                return false;
            }

            var servers = player.GameServer.InterServerManager.GetServerList();

            foreach (var server in servers)
            {
                foreach (PlayerInfo plr in server.playerList)
                {
                    if (plr.Hidden)
                    {
                        player.SendError("Usage: /trade <player name>");
                        return false;
                    }
                }
            }

            player.RequestTrade(args);
            return true;
        }
    }

    internal class UnignoreCommand : Command
    {
        public UnignoreCommand() : base("unignore")
        {
        }

        protected override bool Process(Player player, TickTime time, string playerName)
        {
            if (player.World is Test)
                return false;

            if (String.IsNullOrEmpty(playerName))
            {
                player.SendError("Usage: /unignore <player name>");
                return false;
            }

            if (player.Name.ToLower() == playerName.ToLower())
            {
                player.SendInfo("You are no longer ignoring yourself. Good job.");
                return false;
            }

            var target = player.GameServer.Database.ResolveId(playerName);
            var targetAccount = player.GameServer.Database.GetAccount(target);
            var srcAccount = player.Client.Account;

            if (target == 0 || targetAccount == null || targetAccount.Hidden && player.Rank < 100)
            {
                player.SendError("Player not found.");
                return false;
            }

            player.GameServer.Database.IgnoreAccount(srcAccount, targetAccount, false);

            player.Client.SendPacket(new AccountList()
            {
                AccountListId = 1, // ignore list
                AccountIds = srcAccount.IgnoreList
                    .Select(i => i.ToString())
                    .ToArray()
            });

            player.SendInfo(playerName + " no longer ignored.");
            return true;
        }
    }

    internal class UnlockCommand : Command
    {
        public UnlockCommand() : base("unlock")
        {
        }

        protected override bool Process(Player player, TickTime time, string playerName)
        {
            if (player.World is Test)
                return false;

            if (String.IsNullOrEmpty(playerName))
            {
                player.SendError("Usage: /unlock <player name>");
                return false;
            }

            if (player.Name.ToLower() == playerName.ToLower())
            {
                player.SendInfo("You are no longer locking yourself. Nice!");
                return false;
            }

            var target = player.GameServer.Database.ResolveId(playerName);
            var targetAccount = player.GameServer.Database.GetAccount(target);
            var srcAccount = player.Client.Account;

            if (target == 0 || targetAccount == null || targetAccount.Hidden && player.Rank < 100)
            {
                player.SendError("Player not found.");
                return false;
            }

            player.GameServer.Database.LockAccount(srcAccount, targetAccount, false);

            player.Client.SendPacket(new AccountList()
            {
                AccountListId = 0, // locked list
                AccountIds = player.Client.Account.LockList
                    .Select(i => i.ToString())
                    .ToArray()
            });

            player.SendInfo(playerName + " no longer locked.");
            return true;
        }
    }

    internal class UptimeCommand : Command
    {
        public UptimeCommand() : base("uptime")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            TimeSpan t = TimeSpan.FromMilliseconds(time.TotalElapsedMs);

            string answer = string.Format("{0:D2}h:{1:D2}m:{2:D2}s",
                            t.Hours,
                            t.Minutes,
                            t.Seconds);

            player.SendInfo("The server has been up for " + answer + ".");
            return true;
        }
    }

    internal class VaultCommand : Command
    {
        public VaultCommand() : base("vault")
        {
        }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var world = player.GameServer.WorldManager.CreateNewWorld("Vault", null, player.GameServer.WorldManager.Nexus);
            if (world == null)
            {
                player.SendInfo("Unable to enter vault: BUG");
                return true;
            }
            player.Reconnect(world);
            return true;
        }
    }

    internal class WhereCommand : Command
    {
        public WhereCommand() : base("where")
        {
        }

        protected override bool Process(Player player, TickTime time, string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                player.SendInfo("Usage: /where <player name>");
                return true;
            }

            var servers = player.GameServer.InterServerManager.GetServerList();

            foreach (var server in servers)
                foreach (PlayerInfo plr in server.playerList)
                {
                    if (plr.Hidden)
                        continue;

                    if (!plr.Name.Equals(name, StringComparison.InvariantCultureIgnoreCase))
                        continue;

                    player.SendInfo($"{plr.Name} is playing on {server.name} at [{plr.WorldInstance}]{plr.WorldName}.");
                    return true;
                }

            var pId = player.GameServer.Database.ResolveId(name);
            if (pId == 0)
            {
                player.SendInfo($"No player with the name {name}.");
                return true;
            }

            var acc = player.GameServer.Database.GetAccount(pId, "lastSeen");
            foreach (var server in servers)
                foreach (PlayerInfo plr in server.playerList)
                    if (acc.LastSeen == 0 || plr.Hidden)
                    {
                        player.SendInfo($"{name} not online. Has not been seen since the dawn of time.");
                        return true;
                    }

            var dt = Utils.FromUnixTimestamp(acc.LastSeen);
            player.SendInfo($"{name} not online. Player last seen {Utils.TimeAgo(dt)}.");
            return true;
        }
    }

    internal class WhoCommand : Command
    {
        public WhoCommand() : base("who")
        { }

        protected override bool Process(Player player, TickTime time, string args)
        {
            var sb = new StringBuilder();
            var count = player.World.Players.Count;
            if (count != 0)
            {
                sb.Append($"There {(count > 1 ? "are" : "is")} {count}");
                sb.Append($"{(player.World.IsRealm || player.World.InstanceType == WorldResourceInstanceType.Dungeon ? $"/{player.World.MaxPlayers} " : "")} ");
                sb.Append($"player{(count > 1 ? "s" : "")} connected on this area:\n");

                var i = 0;
                foreach (var plr in player.World.Players.Values)
                {
                    sb.Append($"{plr.Name}{(i + 1 >= count ? "" : ", ")}");
                    i++;
                }
            }
            else
                sb.Append("There is no player connected on this area.");

            player.SendInfo(sb.ToString());
            return true;
        }
    }
}
