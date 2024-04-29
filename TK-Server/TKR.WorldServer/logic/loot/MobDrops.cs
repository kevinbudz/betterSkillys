using System;
using System.Collections.Generic;
using System.Linq;
using TKR.Shared.resources;
using NLog;
using TKR.WorldServer.core;

namespace TKR.WorldServer.logic.loot
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
    }

    public class Threshold : MobDrops
    {
        public Threshold(double threshold, params MobDrops[] children)
        {
            foreach (var i in children)
                i.Populate(LootDefs, new LootDef(null, -1, threshold));
        }
    }
}
