using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public sealed class UseStorageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.USE_STORAGE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var type = rdr.ReadByte();
            var action = rdr.ReadByte();

            var player = client.Player;

            var typeName = Player.GetPotionFromType(type);
            if (player == null || typeName == Player.UNKNOWN_POTION)
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
                    ModifyRemove(player, type, typeName, false, true);
                    break;
                case 3: // sell
                    player.SendInfo($"Sell feature has been temporarily removed");
                    //ModifyRemove(player, type, typeName, true);
                    break;
                case 4: // max
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
            var potIndex = ScanInventory(player, typeName);
            if (potIndex == -1)
            {
                potIndex = ScanInventory(player, $"Greater {typeName}");
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

            player.SendInfo($"You deposited a {(isGreater ? $"Greater {typeName}" : typeName)}!");
        }

        private void ModifyRemove(Player player, byte type, string typeName, bool isConsume = false, bool isMax = false)
        {
            if (CanModifyStat(player, type, true))
            {
                player.SendInfo($"You have no more {typeName}");
                return;
            }

            var statInfo = player.GameServer.Resources.GameData.Classes[player.ObjectType].Stats;
            var maxStatValue = statInfo[type].MaxValue;

            if (isConsume)
            {
                if (player.Stats.Base[type] >= maxStatValue)
                {
                    player.SendInfo($"You are already maxed");
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
                    player.SendInfo($"You are already maxed");
                    return;
                }

                var toMax = type < 2 ? (maxStatValue - player.Stats.Base[type]) / 5 : maxStatValue - player.Stats.Base[type];
                var newToMax = 0;

                if (CanMax(player, type, toMax))
                {
                    newToMax = toMax - PotionsToMaxCalc(player, type, toMax);
                    toMax = newToMax;
                    player.SendInfo($"Not enough {typeName} to max, using [{newToMax}]");
                }

                player.Stats.Base[type] += type < 2 ? 5 * toMax : 1 * toMax;

                if (player.Stats.Base[type] >= maxStatValue)
                    player.Stats.Base[type] = maxStatValue;

                ModifyStat(player, type, false, toMax);
                if (newToMax > 0)
                    return;
                else
                    player.SendInfo($"You maxed {typeName.Remove(0, 9)}!");

                return;
            }

            var potionType = player.GameServer.Resources.GameData.Items[player.GameServer.Resources.GameData.IdToObjectType[typeName]];

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
            var newAmount = isAdd ? amount : -amount;

            switch (type)
            {
                case 0:
                    player.SPSLifeCount += newAmount;
                    break;
                case 1:
                    player.SPSManaCount += newAmount;
                    break;
                case 2:
                    player.SPSAttackCount += newAmount;
                    break;
                case 3:
                    player.SPSDefenseCount += newAmount;
                    break;
                case 4:
                    player.SPSSpeedCount += newAmount;
                    break;
                case 5:
                    player.SPSDexterityCount += newAmount;
                    break;
                case 6:
                    player.SPSVitalityCount += newAmount;
                    break;
                case 7:
                    player.SPSWisdomCount += newAmount;
                    break;
            }

            player.SavePotionStorage();
        }

        private static int PotionsToMaxCalc(Player player, byte type, int toMax) => type switch
        {
            0 => toMax - player.SPSLifeCount,
            1 => toMax - player.SPSManaCount,
            2 => toMax - player.SPSAttackCount,
            3 => toMax - player.SPSDefenseCount,
            4 => toMax - player.SPSSpeedCount,
            5 => toMax - player.SPSDexterityCount,
            6 => toMax - player.SPSVitalityCount,
            7 => toMax - player.SPSWisdomCount,
            _ => 0,
        };

        private static bool CanMax(Player Player, byte type, int toMax) => type switch
        {
            0 => Player.SPSLifeCount < toMax,
            1 => Player.SPSManaCount < toMax,
            2 => Player.SPSAttackCount < toMax,
            3 => Player.SPSDefenseCount < toMax,
            4 => Player.SPSSpeedCount < toMax,
            5 => Player.SPSDexterityCount < toMax,
            6 => Player.SPSVitalityCount < toMax,
            7 => Player.SPSWisdomCount < toMax,
            _ => false,
        };

        private static bool CanModifyStat(Player player, byte type, bool checkZero) => type switch
        {
            0 => checkZero ? player.SPSLifeCount <= 0 : player.SPSLifeCount < player.SPSLifeCountMax,
            1 => checkZero ? player.SPSManaCount <= 0 : player.SPSManaCount < player.SPSManaCountMax,
            2 => checkZero ? player.SPSAttackCount <= 0 : player.SPSAttackCount < player.SPSAttackCountMax,
            3 => checkZero ? player.SPSDefenseCount <= 0 : player.SPSDefenseCount < player.SPSDefenseCountMax,
            4 => checkZero ? player.SPSSpeedCount <= 0 : player.SPSSpeedCount < player.SPSSpeedCountMax,
            5 => checkZero ? player.SPSDexterityCount <= 0 : player.SPSDexterityCount < player.SPSDexterityCountMax,
            6 => checkZero ? player.SPSVitalityCount <= 0 : player.SPSVitalityCount < player.SPSVitalityCountMax,
            7 => checkZero ? player.SPSWisdomCount <= 0 : player.SPSWisdomCount < player.SPSWisdomCountMax,
            _ => false,
        };
    }
}
