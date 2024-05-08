using Shared;
using WorldServer.networking;
using WorldServer.core.objects;
using WorldServer.core.worlds;

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
                case 0:
                    ModifyAdd(player, type, typeName);
                    break;
                case 1:
                    ModifyRemove(player, type, typeName);
                    break;
                case 2:
                    ModifyRemove(player, type, typeName, false, true);
                    break;
                case 3:
                    ModifyRemove(player, type, typeName, true);
                    break;
                case 4:
                    ModifyRemove(player, type, typeName, false, false, true);
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

            ModifyStat(player, type, true);
            if (isGreater)
                ModifyStat(player, type, true);

            player.SendInfo($"You deposited a {(isGreater ? $"Greater {typeName}" : typeName)}!");
        }

        private void ModifyRemove(Player player, byte type, string typeName, bool isSell = false, bool isConsume = false, bool isMax = false)
        {
            if (CanModifyStat(player, type, true))
            {
                player.SendInfo($"You have no more {typeName}");
                return;
            }

            if (isConsume)
            {
                var statInfo = player.GameServer.Resources.GameData.Classes[player.ObjectType].Stats;
                if (player.Stats.Base[type] >= statInfo[type].MaxValue)
                {
                    player.SendInfo($"You are already maxed");
                    return;
                }

                player.Stats.Base[type] += type < 2 ? 5 : 1;
                if (player.Stats.Base[type] >= statInfo[type].MaxValue)
                    player.Stats.Base[type] = statInfo[type].MaxValue;

                ModifyStat(player, type, false);
                player.SendInfo($"You consumed a {typeName}!");
                return;
            }
            else if (isSell)
            {
                var fameToAdd = type < 2 ? 5 : 2;
                player.CurrentFame = player.Client.Account.Fame += fameToAdd;
                player.Client.Account.TotalFame += fameToAdd;
                player.GameServer.Database.ReloadAccount(player.Client.Account);
                player.SendInfo($"You sold a {typeName} for {fameToAdd} fame!");
            }
            else if (isMax)
            {
                var statInfo = player.GameServer.Resources.GameData.Classes[player.ObjectType].Stats;
                if (player.Stats.Base[type] >= statInfo[type].MaxValue)
                {
                    player.SendInfo($"You are already maxed");
                    return;
                }

                var toMax = type < 2 ? (statInfo[type].MaxValue - player.Stats.Base[type]) / 5 : statInfo[type].MaxValue - player.Stats.Base[type];
                var newToMax = 0;

                if (CheckMax(player, type, toMax))
                {
                    newToMax = toMax - ToMaxCalc(player, type, toMax);
                    toMax = newToMax;
                    player.SendInfo($"Not enough {typeName} to max, using [{newToMax}]");
                }


                player.Stats.Base[type] += type < 2 ? 5 * toMax : 1 * toMax;

                if (player.Stats.Base[type] >= statInfo[type].MaxValue)
                    player.Stats.Base[type] = statInfo[type].MaxValue;

                ModifyStat(player, type, false, toMax);
                if (newToMax > 0)
                    return;
                else
                    player.SendInfo($"You maxed {typeName.Remove(0, 9)}!");
                return;
            }
            else
            {
                var potion = player.GameServer.Resources.GameData.Items[player.GameServer.Resources.GameData.IdToObjectType[typeName]];
                var index = player.Inventory.GetAvailableInventorySlot(potion);
                if (index == -1)
                {
                    player.SendInfo("Your inventory is full!");
                    return;
                }

                var transaction = player.Inventory.CreateTransaction();
                transaction[index] = potion;
                transaction.Execute(); // might not need this as a transaction

                player.SendInfo($"You withdrew a {typeName}!");
            }

            ModifyStat(player, type, false, 1);
        }

        private static int ScanInventory(Player player, string item)
        {
            for (var i = 0; i < player.Inventory.Length; i++)
                if (player.Inventory[i] != null && player.Inventory[i].ObjectId == item)
                    return i;
            return -1;
        }

        private static void ModifyStat(Player Player, byte type, bool isAdd, int amount = 1)
        {
            var newAmount = isAdd ? amount : -amount;

            if (type == 0)
            {
                Player.SPSLifeCount += newAmount;
                Player.Client.Account.SPSLifeCount += newAmount;
            }
            else if (type == 1)
            {
                Player.SPSManaCount += newAmount;
                Player.Client.Account.SPSManaCount += newAmount;
            }
            else if (type == 2)
            {
                Player.SPSAttackCount += newAmount;
                Player.Client.Account.SPSAttackCount += newAmount;
            }
            else if (type == 3)
            {
                Player.SPSDefenseCount += newAmount;
                Player.Client.Account.SPSDefenseCount += newAmount;
            }
            else if (type == 4)
            {
                Player.SPSSpeedCount += newAmount;
                Player.Client.Account.SPSSpeedCount += newAmount;
            }
            else if (type == 5)
            {
                Player.SPSDexterityCount += newAmount;
                Player.Client.Account.SPSDexterityCount += newAmount;
            }
            else if (type == 6)
            {
                Player.SPSVitalityCount += newAmount;
                Player.Client.Account.SPSVitalityCount += newAmount;
            }
            else if (type == 7)
            {
                Player.SPSWisdomCount += newAmount;
                Player.Client.Account.SPSWisdomCount += newAmount;
            }
        }

        private static int ToMaxCalc(Player player, byte type, int toMax)
        {
            switch (type)
            {
                case 0: return toMax - player.SPSLifeCount;
                case 1: return toMax - player.SPSManaCount;
                case 2: return toMax - player.SPSAttackCount;
                case 3: return toMax - player.SPSDefenseCount;
                case 4: return toMax - player.SPSSpeedCount;
                case 5: return toMax - player.SPSDexterityCount;
                case 6: return toMax - player.SPSVitalityCount;
                case 7: return toMax - player.SPSWisdomCount;
                default: return 0;
            }
        }

        private static bool CheckMax(Player Player, byte type, int toMax)
        {
            switch (type)
            {
                case 0: return Player.SPSLifeCount < toMax;
                case 1: return Player.SPSManaCount < toMax;
                case 2: return Player.SPSAttackCount < toMax;
                case 3: return Player.SPSDefenseCount < toMax;
                case 4: return Player.SPSSpeedCount < toMax;
                case 5: return Player.SPSDexterityCount < toMax;
                case 6: return Player.SPSVitalityCount < toMax;
                case 7: return Player.SPSWisdomCount < toMax;
                default: return false;
            }
        }

        private static bool CanModifyStat(Player player, byte type, bool checkZero)
        {
            switch (type)
            {
                case 0: return checkZero ? player.SPSLifeCount <= 0 : player.SPSLifeCount < player.SPSLifeCountMax;
                case 1: return checkZero ? player.SPSManaCount <= 0 : player.SPSManaCount < player.SPSManaCountMax;
                case 2: return checkZero ? player.SPSAttackCount <= 0 : player.SPSAttackCount < player.SPSAttackCountMax;
                case 3: return checkZero ? player.SPSDefenseCount <= 0 : player.SPSDefenseCount < player.SPSDefenseCountMax;
                case 4: return checkZero ? player.SPSSpeedCount <= 0 : player.SPSSpeedCount < player.SPSSpeedCountMax;
                case 5: return checkZero ? player.SPSDexterityCount <= 0 : player.SPSDexterityCount < player.SPSDexterityCountMax;
                case 6: return checkZero ? player.SPSVitalityCount <= 0 : player.SPSVitalityCount < player.SPSVitalityCountMax;
                case 7: return checkZero ? player.SPSWisdomCount <= 0 : player.SPSWisdomCount < player.SPSWisdomCountMax;
                default: return false;
            }
        }
    }
}
