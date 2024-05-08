using Shared;
using Shared.resources;
using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Gift : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "gift";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (player == null)
                    return false;

                var manager = player.GameServer;

                // verify argument
                var index = args.IndexOf(' ');
                if (string.IsNullOrWhiteSpace(args) || index == -1)
                {
                    player.SendInfo("Usage: /gift <player name> <item name>");
                    return false;
                }

                // get command args
                var playerName = args.Substring(0, index);
                var item = GetItem(player, args.Substring(index + 1));
                if (item == null)
                {
                    player.SendError("Unable to find item");
                    return false;
                }

                var id = manager.Database.ResolveId(playerName);
                var acc = manager.Database.GetAccount(id);
                if (id == 0 || acc == null)
                {
                    player.SendError("Account not found!");
                    return false;
                }

                // add gift
                var result = player.GameServer.Database.AddGift(acc, item.ObjectType);
                if (!result)
                {
                    player.SendError("Gift not added. Something happened with the adding process.");
                    return false;
                }

                player.SendInfo($"You have gifted {acc.Name} - {item.DisplayName}.");
                var gifted = player.GameServer.ConnectionManager.FindClient(acc.AccountId);
                if(gifted != null)
                {
                    gifted.Player.SendInfo($"You received a gift from {player.Name}. Enjoy your {item.DisplayName}.");
                    return false;
                }
                return true;
            }

            private static Item GetItem(Player player, string itemName)
            {
                var gameData = player.GameServer.Resources.GameData;

                // allow both DisplayId and Id for query
                if (!gameData.IdToObjectType.TryGetValue(itemName, out var objType))
                    return null;

                if (!gameData.Items.ContainsKey(objType))
                {
                    player.SendError("Not an item!");
                    return null;
                }

                return gameData.Items[objType];
            }
        }
    }
}
