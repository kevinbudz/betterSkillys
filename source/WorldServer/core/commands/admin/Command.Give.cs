using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Give : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "give";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var gameData = player.GameServer.Resources.GameData;
                if (!gameData.DisplayIdToObjectType.TryGetValue(args, out ushort objType))
                {
                    if (!gameData.IdToObjectType.TryGetValue(args, out objType))
                    {
                        player.SendError($"unable to find item: {args}!");
                        return false;
                    }
                }

                if (!gameData.Items.ContainsKey(objType))
                {
                    player.SendError($"unable to find item: {args}!");
                    return false;
                }

                var item = gameData.Items[objType];
                var availableSlot = player.Inventory.GetAvailableInventorySlot(item);
                if (availableSlot != -1)
                {
                    player.Inventory[availableSlot] = item;
                    return true;
                }

                player.SendError("Not enough space in inventory!");
                return false;
            }
        }
    }
}