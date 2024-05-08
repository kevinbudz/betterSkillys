using System;
using System.Collections.Generic;
using System.Linq;
using Shared.resources;
using NLog;
using WorldServer.core;
using WorldServer.core.worlds.impl;
using System.Reflection.Metadata;

namespace WorldServer.logic.loot
{
    public abstract class MobDrops
    {
        protected static XmlData XmlData;
        protected readonly IList<LootDef> LootDefs = new List<LootDef>();

        public static void Initialize(GameServer gameServer)
        {
            if (XmlData != null)
                throw new Exception("MobDrops already initialized");
            XmlData = gameServer.Resources.GameData;
        }

        public virtual void Populate(IList<LootDef> lootDefs, LootDef overrides = null)
        {
            if (overrides == null)
            {
                foreach (var lootDef in LootDefs)
                    lootDefs.Add(lootDef);
                return;
            }

            foreach (var lootDef in LootDefs)
            {
                lootDefs.Add(new LootDef(
                    lootDef.Item,
                    overrides.Probabilty >= 0 ? overrides.Probabilty : lootDef.Probabilty,
                    overrides.Threshold >= 0 ? overrides.Threshold : lootDef.Threshold, lootDef.Tier, lootDef.ItemType));
            }
        }
    }

    public class ItemLoot : MobDrops
    {
        public ItemLoot(string item, double probability = 1, int numRequired = 0, double threshold = 0)
        {
            LootDefs.Add(new LootDef(item, probability, threshold));
        }
    }

    public class TierLoot : MobDrops
    {
        private static readonly int[] WeaponT = new int[] { 1, 2, 3, 8, 17, 24 };
        private static readonly int[] AbilityT = new int[] { 4, 5, 11, 12, 13, 15, 16, 18, 19, 20, 21, 22, 23, 25 };
        private static readonly int[] ArmorT = new int[] { 6, 7, 14, };
        private static readonly int[] RingT = new int[] { 9 };
        private static readonly int[] PotionT = new int[] { 10 };

        public static int[] GetSlotTypes(ItemType itemType)
        {
            int[] types;
            switch (itemType)
            {
                case ItemType.Weapon:
                    types = WeaponT; break;
                case ItemType.Ability:
                    types = AbilityT; break;
                case ItemType.Armor:
                    types = ArmorT; break;
                case ItemType.Ring:
                    types = RingT; break;
                case ItemType.Potion:
                    types = PotionT; break;
                default:
                    throw new NotSupportedException(itemType.ToString());
            }
            return types;
        }

        public static ItemType SlotTypesToItemType(int slotType)
        {
            if (WeaponT.Contains(slotType))
                return ItemType.Weapon;
            if (AbilityT.Contains(slotType))
                return ItemType.Ability;
            if (ArmorT.Contains(slotType))
                return ItemType.Armor;
            if (RingT.Contains(slotType))
                return ItemType.Ring;
            if (PotionT.Contains(slotType))
                return ItemType.Potion;
            throw new NotSupportedException(slotType.ToString());
        }

        public TierLoot(int tier, ItemType type, double probability = 1, int numRequired = 0, double threshold = 0)
        {
            LootDefs.Add(new LootDef(null, probability, threshold, tier, type));
        }
    }

    public class LootTemplates : MobDrops
    {
        public static MobDrops[] MountainDrop()
        {
            return
            [
                new TierLoot(6, ItemType.Weapon, .1),
                new TierLoot(7, ItemType.Weapon, .06),
                new TierLoot(8, ItemType.Weapon, .04),
                new TierLoot(6, ItemType.Armor, .1),
                new TierLoot(7, ItemType.Armor, .06),
                new TierLoot(8, ItemType.Armor, .04),
                new TierLoot(9, ItemType.Armor, .04),
                new TierLoot(2, ItemType.Ability, .06),
                new TierLoot(3, ItemType.Ability, .04),
                new TierLoot(4, ItemType.Ability, .04),
                new TierLoot(3, ItemType.Ring, .06),
                new TierLoot(4, ItemType.Ring, .04)
            ];
        }
        public static MobDrops[] BasicDrop()
        {
            return
            [
                new TierLoot(10, ItemType.Weapon, .07),
                new TierLoot(11, ItemType.Weapon, .07),
                new TierLoot(4, ItemType.Ability, .07),
                new TierLoot(5, ItemType.Ability, .07),
                new TierLoot(11, ItemType.Armor, .07),
                new TierLoot(12, ItemType.Armor, .07),
                new TierLoot(4, ItemType.Ring, .07),
                new TierLoot(5, ItemType.Ring, .07)
            ];
        }

        public static MobDrops[] StrongerDrop()
        {
            return
            [
                new TierLoot(11, ItemType.Weapon, .1),
                new TierLoot(12, ItemType.Weapon, .05),
                new TierLoot(5, ItemType.Ability, .1),
                new TierLoot(6, ItemType.Ability, .05),
                new TierLoot(12, ItemType.Armor, .1),
                new TierLoot(13, ItemType.Armor, .05),
                new TierLoot(5, ItemType.Ring, .1),
                new TierLoot(6, ItemType.Ring, .05)
            ];
        }

        public static MobDrops[] BasicPots()
        {
            return
            [
                new ItemLoot("Potion of Defense", .16),
                new ItemLoot("Potion of Attack", .16),
                new ItemLoot("Potion of Speed", .16),
                new ItemLoot("Potion of Vitality", .16),
                new ItemLoot("Potion of Wisdom", .16),
                new ItemLoot("Potion of Dexterity", .16)
            ];
        }

        public static MobDrops[] StrongerPots()
        {
            return
            [
                new ItemLoot("Potion of Defense", .2),
                new ItemLoot("Potion of Attack", .2),
                new ItemLoot("Potion of Speed", .2),
                new ItemLoot("Potion of Vitality", .2),
                new ItemLoot("Potion of Wisdom", .2),
                new ItemLoot("Potion of Dexterity", .2),
                new ItemLoot("Potion of Life", .2),
                new ItemLoot("Potion of Mana", .2)
            ];
        }
    }

    public class Threshold : MobDrops
    {
        public Threshold(double threshold, params MobDrops[] children)
        {
            foreach (var i in children)
                i.Populate(LootDefs, new LootDef(null, -1, threshold));
        }
    }

    public class SeasonalThreshold : MobDrops
    {
        public SeasonalThreshold(string time, double threshold, params MobDrops[] children)
        {
            switch (time)
            {
                case "winter":
                    if (NexusWorld.GetCurrentMonth != 12 ||
                        NexusWorld.GetCurrentMonth != 1) return;
                    break;
                case "summer":
                    if (NexusWorld.GetCurrentMonth != 5 ||
                        NexusWorld.GetCurrentMonth != 6 ||
                        NexusWorld.GetCurrentMonth != 7) return;
                    break;
                //case "spring":
                //case "fall":
                default:
                    return;
            }
            foreach (var i in children)
                i.Populate(LootDefs, new LootDef(null, -1, threshold));
        }
    }
}
