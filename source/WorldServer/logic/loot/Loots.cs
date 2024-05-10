using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Shared;
using Shared.database.character.inventory;
using Shared.resources;
using WorldServer.core;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.logic.loot
{
    public class ChestLoot
    {
        private readonly static List<MobDrops> ChestItems = new List<MobDrops>();

        public ChestLoot(params MobDrops[] drops) => ChestItems.AddRange(ChestItems);

        public IEnumerable<Item> CalculateItems(GameServer core, Random random, int min, int max)
        {
            var consideration = new List<LootDef>();
            foreach (var i in ChestItems)
                i.Populate(consideration);

            var retCount = random.Next(min, max);

            foreach (var i in consideration)
            {
                if (random.NextDouble() < i.Probabilty)
                {
                    yield return core.Resources.GameData.Items[core.Resources.GameData.IdToObjectType[i.Item]];
                    retCount--;
                }

                if (retCount == 0)
                    yield break;
            }
        }
    }

    public class Loot : List<MobDrops>
    {
        #region Utils

        /*  
         *  Brown 0,
         *  Pink 1,
         *  Purple 2, 
         *  Cyan 3, 
         *  Blue 4, 
         *  Gold 5, 
         *  White 6,
         *  Orange 7,
         *  Egg 8
         */

        public static readonly ushort[] BAG_ID_TO_TYPE = new ushort[] { 0x0500, 0x0506, 0x0503, 0x0509, 0x050B, 0x050E, 0x050C, 0x0508 };
        public static readonly ushort[] BOOSTED_BAG_ID_TO_TYPE = new ushort[] { 0x6ad, 0x6ae, 0x6ba, 0x6bd, 0x6be, 0x6bc, 0x0510, 0x6bb };

        public static bool DropsInSoulboundBag(ItemType type, int tier)
        {
            if (type == ItemType.Ring)
                if (tier >= 2)
                    return true;
            if (type == ItemType.Ability)
                if (tier > 2)
                    return true;
            return tier > 6;
        }

        // slotType
        // tier
        // item
        private static Dictionary<ItemType, Dictionary<int, List<Item>>> Items = new Dictionary<ItemType, Dictionary<int, List<Item>>>();

        public List<Item> GetItems(ItemType itemType, int tier)
        {
            if (Items.TryGetValue(itemType, out var keyValuePairs))
                if (keyValuePairs.TryGetValue(tier, out var items))
                    return items;
            return null;
        }

        public static void Initialize(GameServer gameServer)
        {
            // get all tiers

            var allItems = gameServer.Resources.GameData.Items;
            foreach (var item in allItems.Values)
            {
                var itemType = TierLoot.SlotTypesToItemType(item.SlotType);
                if (!Items.TryGetValue(itemType, out var dict))
                    Items[itemType] = dict = new Dictionary<int, List<Item>>();
                if (!dict.TryGetValue(item.Tier, out var items))
                    Items[itemType][item.Tier] = items = new List<Item>();
                items.Add(item);
            }

            //GetSlotTypes

            Items = Items.OrderBy(_ => _.Key).ToDictionary(_ => _.Key, _ => _.Value);
        }
        private List<LootDef> ExtraLootTables(List<LootDef> list, Enemy enemy)
        {
            var gameData = enemy.GameServer.Resources.GameData;
            var xmlitem = gameData.Items;
            var itemtoid = gameData.IdToObjectType;

            if (enemy.ObjectDesc.HealthBarBoss == true)
            {
                if (TimeOfYear.CurrentMonth == 12 || TimeOfYear.CurrentMonth == 1)
                {
                    list.Add(new LootDef("Frost Citadel Armor", 0.01, 0.01));
                    list.Add(new LootDef("Frost Drake Hide Armor", 0.01, 0.01));
                    list.Add(new LootDef("Frost Elementalist Robe", 0.01, 0.01));
                    list.Add(new LootDef("Scepter of Sainthood", 0.01, 0.01));
                    list.Add(new LootDef("Snowbound Orb", 0.01, 0.01));
                    list.Add(new LootDef("Pathfinder's Helm", 0.01, 0.01));
                    list.Add(new LootDef("Coalbearing Quiver", 0.01, 0.01));
                    list.Add(new LootDef("Skull of Krampus", 0.01, 0.01));
                    list.Add(new LootDef("Vigil Spell", 0.01, 0.01));
                    list.Add(new LootDef("Greedsnatcher Trap", 0.01, 0.01));
                    list.Add(new LootDef("Resounding Shield", 0.01, 0.01));
                    list.Add(new LootDef("Ornamental Prism", 0.01, 0.01));
                    list.Add(new LootDef("Nativity Tome", 0.01, 0.01));
                    list.Add(new LootDef("Holly Poison", 0.01, 0.01));
                    list.Add(new LootDef("Cloak of Winter", 0.01, 0.01));
                    list.Add(new LootDef("Advent Seal", 0.01, 0.01));
                    list.Add(new LootDef("Ilex Star", 0.01, 0.01));
                    list.Add(new LootDef("Icicle Launcher", 0.01, 0.01));
                    list.Add(new LootDef("Winter's Breath Wand", 0.01, 0.01));
                    list.Add(new LootDef("Frosty's Walking Stick", 0.01, 0.01));
                    list.Add(new LootDef("Frost Lich's Finger", 0.01, 0.01));
                    list.Add(new LootDef("Saint Nicolas' Blade", 0.01, 0.01));
                    list.Add(new LootDef("Yuki", 0.01, 0.01));
                }
            }
            /*if (NexusWorld.GetCurrentMonth == 5 ||
                NexusWorld.GetCurrentMonth == 6 ||
                NexusWorld.GetCurrentMonth == 7) */
				
			/* if (NexusWorld.GetCurrentMonth == 10 || 
				NexusWorld.GetCurrentMonth == 11 ||)*/

            /*if (enemy.Rare)
            if (enemy.Epic)
            if (enemy.Legendary)*/
            return list;
        }

        #endregion Utils

        public Loot(params MobDrops[] drops) => AddRange(drops);

        public void Handle(Enemy enemy, TickTime time)
        {
            if (enemy.SpawnedByBehavior)
                return;

            var possDrops = new List<LootDef>();
            ExtraLootTables(possDrops, enemy);
            foreach (var i in this)
                i.Populate(possDrops);

            var pubDrops = new List<Item>();

            foreach (var i in possDrops)
            {
                if (i.ItemType == ItemType.None)
                {
                    // we treat item names as soulbound never public loot
                    continue;
                }

                if (DropsInSoulboundBag(i.ItemType, i.Tier))
                    continue;
                
                var chance = Random.Shared.NextDouble();
                if (i.Threshold <= 0 && chance < i.Probabilty)
                {
                    var items = GetItems(i.ItemType, i.Tier);
                    var chosenTieredItem = items[Random.Shared.Next(items.Count)];
                    pubDrops.Add(chosenTieredItem);
                }
            }

            if(pubDrops.Count > 0)
                ProcessPublic(pubDrops, enemy);

            var playersAvaliable = enemy.DamageCounter.GetPlayerData();
            if (playersAvaliable == null)
                return;

            var privDrops = new Dictionary<Player, IList<Item>>();
            foreach (var tupPlayer in playersAvaliable)
            {
                var player = tupPlayer.Item1;
                if (player == null || player.World == null || player.Client == null)
                    continue;

                double enemyBoost = 0;
                if (enemy.IsRare) enemyBoost = .25;
                if (enemy.IsEpic) enemyBoost = .5;
                if (enemy.IsLegendary) enemyBoost = .75;

                var dmgBoost = Math.Round(tupPlayer.Item2 / (double)enemy.DamageCounter.TotalDamage, 4);
                var ldBoost = player.LDBoostTime > 0 ? 0.25 : 0;
                var wkndBoost = NexusWorld.WeekendLootBoostEvent;
                var totalBoost = 1 + (ldBoost + wkndBoost + dmgBoost + enemyBoost);

                var gameData = enemy.GameServer.Resources.GameData;

                var drops = new List<Item>();
                foreach (var i in possDrops)
                {
                    var c = Random.Shared.NextDouble();

                    var probability = i.Probabilty * totalBoost;

                    if (i.Threshold >= 0 && i.Threshold < Math.Round(tupPlayer.Item2 / (double)enemy.DamageCounter.TotalDamage, 4))
                    {
                        Item item = null;
                        if (i.ItemType != ItemType.None)
                        {
                            var items = GetItems(i.ItemType, i.Tier);
                            if (items != null)
                                item = Random.Shared.NextLength(items);
                        }
                        else
                        {
                            if (!gameData.IdToObjectType.TryGetValue(i.Item, out var type))
                                continue;
                            if (!gameData.Items.TryGetValue(type, out item))
                                continue;
                        }

                        if (item == null)
                        {
                            player.SendError($"There was a error calculating the item roll for item: {i.Item}, please report this [#1]");
                            continue;
                        }

                        if (c >= probability)
                            continue;

                        if (item == null)
                        {
                            player.SendError($"There was a error giving u the item: {i.Item}, please report this [#2]");
                            continue;
                        }

                        drops.Add(item);
                    }
                }

                privDrops[player] = drops;
            }

            foreach (var priv in privDrops)
            {
                if (priv.Value.Count > 0)
                {
                    ProcessSoulbound(enemy, priv.Value, enemy.GameServer, priv.Key);
                }
            }
        }

        private static void ProcessPublic(List<Item> drops, Enemy enemy)
        {
            var bagType = 0;
            var idx = 0;
            var items = new Item[8];

            bagType = drops.Max(_ => _.BagType);

            var ownerIds = Array.Empty<int>();
            foreach (var i in drops)
            {
                items[idx] = i;
                idx++;
                if (idx == 8)
                {
                    DropBag(enemy, ownerIds, bagType, items, false);
                    idx = 0;
                    items = new Item[8];
                    bagType = 0;
                }
            }

            if (idx > 0)
                DropBag(enemy, ownerIds, bagType, items, false);
        }

        private static void ProcessSoulbound(Enemy enemy, IEnumerable<Item> loots, GameServer core, params Player[] owners)
        {
            var player = owners[0] ?? null;
            var idx = 0;
            var bagType = 0;

            var items = new Item[8];
            var boosted = false;
            bool isWhite = false;

            var hitters = enemy.DamageCounter.GetHitters();

            if (owners.Count() == 1 && player.LDBoostTime > 0 || (Math.Round(hitters[player] / (double)enemy.DamageCounter.TotalDamage, 4) > .25 && Random.Shared.NextDouble() > .5))
                boosted = true;

            bagType = loots.Max(_ => _.BagType);

            foreach (var i in loots)
            {
                if (player != null)
                {
                    var chat = core.ChatManager;
                    var world = player.World;
                    isWhite = i.BagType == 6;
                    if (player != null && isWhite)
                    {
                        var msg = new StringBuilder($" {player.Client.Account.Name} has obtained:");
                        msg.Append($" [{i.DisplayId ?? i.ObjectId}], by doing {Math.Round(100.0 * (hitters[player] / (double)enemy.DamageCounter.TotalDamage), 0)}% damage!");
                        chat.AnnounceLoot(msg.ToString());
                    }
                }

                items[idx] = i;
                idx++;

                if (idx == 8)
                {
                    DropBag(enemy, owners.Select(x => x.AccountId).ToArray(), bagType, items, boosted);
                    items = new Item[8];
                    idx = 0;
                }
            }

            if (idx > 0)
                DropBag(enemy, owners.Select(x => x.AccountId).ToArray(), bagType, items, boosted);
        }

        private static void DropBag(Enemy enemy, int[] owners, int bagType, Item[] items, bool boosted)
        {
            var bag = BAG_ID_TO_TYPE[bagType];
            if (boosted)
                bag = BOOSTED_BAG_ID_TO_TYPE[bagType];

            var container = new Container(enemy.GameServer, bag, 1500 * 60, true);

            for (int j = 0; j < 8; j++)
            {
                if (items[j] != null && items[j].Quantity > 0 && items[j].QuantityLimit > 0)
                    container.Inventory.Data[j] = new ItemData()
                    {
                        Stack = items[j].Quantity,
                        MaxStack = items[j].QuantityLimit
                    };
                container.Inventory[j] = items[j];
            }

            container.BagOwners = owners;
            container.Move(enemy.X + (float)((Random.Shared.NextDouble() * 2 - 1) * 0.5), enemy.Y + (float)((Random.Shared.NextDouble() * 2 - 1) * 0.5));
            container.Size = bagType >= 3 ? 100 : 80;
            enemy.World.EnterWorld(container);
        }
    }

    public class LootDef
    {
        public string Item;
        public double Probabilty;
        public double Threshold;
        public int Tier;
        public ItemType ItemType;

        public LootDef(string item, double probabilty, double threshold, int tier = -1, ItemType itemType = ItemType.None)
        {
            Item = item;
            Probabilty = probabilty;
            Threshold = threshold;
            Tier = tier;
            ItemType = itemType;
        }
    }
}
