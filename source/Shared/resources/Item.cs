using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace Shared.resources
{
    public class Item
    {
        public ActivateEffect[] ActivateEffects;
        public float ArcGap;
        public bool Backpack;
        public int BagType;
        public bool Clarification;
        public string Class;
        public bool Consumable;
        public float Cooldown;
        public bool Demonized;
        public string Description;
        public string DisplayId;
        public string DisplayName;
        public int Doses;
        public bool Electrify;
        public int FameBonus;
        public bool GodBless;
        public bool GodTouch;
        public bool HolyProtection;
        public bool Insanity;
        public bool Vampiric;
        public bool InvUse;
        public bool LDBoosted;
        public bool Legendary;
        public bool LTBoosted;
        public bool Lucky;
        public bool MonkeyKingsWrath;
        public int MpCost;
        public int MpEndCost;
        public bool Mutilate;
        public bool Mythical;
        public int NumProjectiles;
        public string ObjectId;
        public ushort ObjectType;
        public bool OutOfOneMind;
        public bool Potion;
        public ProjectileDesc[] Projectiles;
        public int Quantity;
        public int QuantityLimit;
        public float RateOfFire;
        public bool Resurrects;
        public int SlotType;
        public bool SNormal;
        public bool SonicBlaster;
        public bool Soulbound;
        public int SpellProjectiles;
        public bool SPlus;
        public KeyValuePair<int, int>[] ActivateOnEquips;
        public bool SteamRoller;
        public string SuccessorId;
        public int Texture1;
        public int Texture2;
        public int Tier;
        public float Timer;
        public bool TypeOfConsumable;
        public bool Usable;
        public bool XpBoost;

        public readonly bool DonorItem;

        public Item(ushort type, XElement e)
        {
            ObjectType = type;
            ObjectId = e.GetAttribute<string>("id");
            Class = e.GetValue<string>("Class");
            DisplayId = e.GetValue<string>("DisplayId");
            DisplayName = string.IsNullOrWhiteSpace(DisplayId) ? ObjectId : DisplayId;
            Texture1 = e.GetValue<int>("Tex1");
            Texture2 = e.GetValue<int>("Tex2");
            SlotType = e.GetValue<int>("SlotType");
            Description = e.GetValue<string>("Description");
            Consumable = e.HasElement("Consumable");
            Soulbound = e.HasElement("Soulbound");
            Potion = e.HasElement("Potion");
            Usable = e.HasElement("Usable");
            Legendary = e.HasElement("Legendary");
            Mythical = e.HasElement("Mythical");
            Resurrects = e.HasElement("Resurrects");
            RateOfFire = e.GetValue<float>("RateOfFire");
            Tier = e.GetValue("Tier", -1);
            BagType = e.GetValue<int>("BagType");
            FameBonus = e.GetValue<int>("FameBonus");
            NumProjectiles = e.GetValue("NumProjectiles", 1);
            SpellProjectiles = e.GetValue("SpellProjectiles", 0);
            ArcGap = e.GetValue("ArcGap", 11.25f);
            MpCost = e.GetValue<int>("MpCost");
            Cooldown = e.GetValue("Cooldown", 0.5f);
            Doses = e.GetValue<int>("Doses");
            SuccessorId = e.GetValue<string>("SuccessorId");
            Backpack = e.HasElement("Backpack");
            LDBoosted = e.HasElement("LDBoosted");
            LTBoosted = e.HasElement("LTBoosted");
            XpBoost = e.HasElement("XpBoost");
            Timer = e.GetValue<float>("Timer");
            MpEndCost = e.GetValue("MpEndCost", 0);
            InvUse = e.HasElement("InvUse");
            TypeOfConsumable = InvUse || Consumable;
            DonorItem = e.HasElement("DonorItem");
            ActivateOnEquips = e.Elements("ActivateOnEquip").Select(_ => new KeyValuePair<int, int>(_.GetAttribute<int>("stat"), _.GetAttribute<int>("amount"))).ToArray();
            ActivateEffects = e.Elements("Activate").Select(_ => new ActivateEffect(_)).ToArray();
            Projectiles = e.Elements("Projectile").Select(_ => new ProjectileDesc(_)).ToArray();
            Quantity = e.GetValue("Quantity", 0);
            QuantityLimit = e.GetValue("QuantityLimit", 0);
            SNormal = e.Element("SNormal") != null;
            SPlus = e.Element("SPlus") != null;
            MonkeyKingsWrath = e.HasElement("MonkeyKingsWrath");
            Lucky = e.HasElement("Lucky");
            Insanity = e.HasElement("Insanity");
            HolyProtection = e.HasElement("HolyProtection");
            GodBless = e.HasElement("GodBless");
            GodTouch = e.HasElement("GodTouch");
            Electrify = e.HasElement("Electrify");
            OutOfOneMind = e.HasElement("OutOfOneMind");
            SteamRoller = e.HasElement("SteamRoller");
            Mutilate = e.HasElement("Mutilate");
            Demonized = e.HasElement("Demonized");
            Clarification = e.HasElement("Clarification");
            SonicBlaster = e.HasElement("SonicBlaster");
            Vampiric = e.HasElement("Vampiric");
        }
    }
}
