using Shared.database.character.inventory;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class FixStacks : Command
        {
            public override string CommandName => "fixstacks";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var inventory = player.Inventory;
                var fixedStacks = 0;
                int maxStacks = 0;

                for (int i = 4; i < 12; i++)
                {
                    if (inventory[i] != null)
                    {
                        switch (inventory[i].ObjectId)
                        {
                            case "Magic Dust": maxStacks = 5; break;
                            case "Glowing Shard": maxStacks = 50; break;
                            case "Frozen Coin": maxStacks = 200; break;
                            default: continue;
                        }
                        if (inventory.Data[i] == null)
                        {
                            inventory.Data[i] = new ItemData()
                            {
                                ObjectId = null,
                                Stack = 1,
                                MaxStack = maxStacks
                            };
                            fixedStacks ++;
                            player.SendInfo($"Successfully fixed ItemData in Slot {i}");
                        }
                    }
                }
                if (fixedStacks < 1)
                    player.SendError("Nothing to fix.");
                return true;
            }
        }
    }
}
