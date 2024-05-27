using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.behaviors;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public sealed class UseStorageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.USE_STORAGE;

        public string[] Potions = ["Life", "Mana", "Attack", "Defense", "Speed", "Dexterity", "Vitality", "Wisdom", "Unknown"];

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var type = rdr.ReadByte();
            var action = rdr.ReadByte();
            var player = client.Player;
            var typeName = Potions[type];

            if (player == null || typeName == Potions[8])
            {
                player.SendInfo("Unknown Error");
                return;
            }

            switch (action)
            {
                case 0: // add
                    ModifyAdd(player, type, typeName);
                    break;
                case 1: // remove
                    ModifyRemove(player, type, typeName);
                    break;
                case 2: // consume
                    ModifyRemove(player, type, typeName, true);
                    break;
                case 3: // max
                    ModifyRemove(player, type, typeName, false, true);
                    break;
            }
        }

        private void ModifyAdd(Player player, byte type, string typeName)
        {
            if (!CanModifyStat(player, type, false))
            {
                player.SendInfo($"You can store no more {typeName}");
                return;
            }

            var isGreater = false;
            var potIndex = ScanInventory(player, $"Potion of {typeName}");

            if (potIndex == -1)
            {
                potIndex = ScanInventory(player, $"Greater Potion of {typeName}");
                isGreater = true;
            }

            if (potIndex == -1)
            {
                player.SendInfo($"You dont have any {typeName} in your inventory");
                return;
            }

            var transaction = player.Inventory.CreateTransaction();
            transaction[potIndex] = null;
            transaction.Execute(); // might not need this as a transaction

            var amount = isGreater ? 2 : 1;
            ModifyStat(player, type, true, amount);

            bool checkVowel = typeName.Substring(0, 1) == "A";
            string accForVowel = checkVowel ? "n" : "";
            player.SendInfo($"You deposited {(isGreater ? $"two {typeName}" : $"a{accForVowel} {typeName}")}!");
        }

        private void ModifyRemove(Player player, byte type, string typeName, bool isConsume = false, bool isMax = false)
        {
            if (CanModifyStat(player, type, true))
            {
                player.SendInfo($"You have no more {typeName} left!");
                return;
            }

            var statInfo = player.GameServer.Resources.GameData.Classes[player.ObjectType].Stats;
            var maxStatValue = statInfo[type].MaxValue;

            if (isConsume)
            {
                if (player.Stats.Base[type] >= maxStatValue)
                {
                    player.SendInfo($"You are already maxed!");
                    return;
                }

                player.Stats.Base[type] += type < 2 ? 5 : 1;
                if (player.Stats.Base[type] >= maxStatValue)
                    player.Stats.Base[type] = maxStatValue;

                ModifyStat(player, type, false);

                player.SendInfo($"You consumed a {typeName}!");
                return;
            }

            if (isMax)
            {
                if (player.Stats.Base[type] >= maxStatValue)
                {
                    player.SendInfo($"You're already maxed in this stat!");
                    return;
                }

                var toMax = type < 2 ? (maxStatValue - player.Stats.Base[type]) / 5 : maxStatValue - player.Stats.Base[type];
                var newToMax = 0;

                if (CanMax(player, type, toMax))
                {
                    newToMax = toMax - LeftToMax(player, type, toMax);
                    toMax = newToMax;
                    player.SendInfo($"Not enough {typeName} to max, using {newToMax} instead!");
                }

                player.Stats.Base[type] += type < 2 ? 5 * toMax : 1 * toMax;

                if (player.Stats.Base[type] >= maxStatValue)
                    player.Stats.Base[type] = maxStatValue;

                ModifyStat(player, type, false, toMax);
                if (newToMax > 0)
                    return;
                else
                    player.SendInfo($"You maxed {typeName}!");

                return;
            }

            var potionType = player.GameServer.Resources.GameData.Items[player.GameServer.Resources.GameData.IdToObjectType["Potion of " + typeName]];

            var index = player.Inventory.GetAvailableInventorySlot(potionType);
            if (index == -1)
            {
                player.SendInfo("Your inventory is full!");
                return;
            }

            var transaction = player.Inventory.CreateTransaction();
            transaction[index] = potionType;
            transaction.Execute(); // might not need this as a transaction

            player.SendInfo($"You withdrew a {typeName}!");

            ModifyStat(player, type, false, 1);
        }

        private static int ScanInventory(Player player, string item)
        {
            for (var i = 0; i < player.Inventory.Length; i++)
                if (player.Inventory[i] != null && player.Inventory[i].ObjectId == item)
                    return i;
            return -1;
        }

        private static void ModifyStat(Player player, byte type, bool isAdd, int amount = 1)
        {
            var potions = player.Client.Account.StoredPotions;
            var newAmount = isAdd ? amount : -amount;
            potions[type] += newAmount;

            player.Client.Account.StoredPotions = potions;
            player.Client.Account.FlushAsync();
        }

        private static int LeftToMax(Player player, byte type, int toMax)
        {
            return toMax - player.Client.Account.StoredPotions[type];
        }

        private static bool CanMax(Player player, byte type, int toMax)
        {
            return player.Client.Account.StoredPotions[type] < toMax;
        }

        private static bool CanModifyStat(Player player, byte type, bool checkZero)
        {
            var stored = player.Client.Account.StoredPotions;
            return checkZero ? stored[type] <= 0 : stored[type] < 50;
        }
    }
}
