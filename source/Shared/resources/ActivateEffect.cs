using System;
using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class ActivateEffect
    {
        public readonly int Amount;
        public readonly ConditionEffectIndex? CheckExistingEffect;
        public readonly uint Color;
        public readonly ConditionEffectIndex? ConditionEffect;
        public readonly float Cooldown;
        public readonly int DurationMS;
        public readonly float DurationSec;
        public readonly ActivateEffects Effect;
        public readonly float EffectDuration;
        public readonly int ImpactDamage;
        public readonly float MaximumDistance;
        public readonly int MaxTargets;
        public readonly bool NoStack;
        public readonly float Radius;
        public readonly float Range;
        public readonly bool RemoveSelf;
        public readonly ushort SkinType;
        public readonly int Stats;
        public readonly int ThrowTime;
        public readonly int TotalDamage;
        public readonly bool UseWisMod;
        public readonly int VisualEffect;
        public readonly byte Type;
        public readonly float SuccessChange;
        public readonly float SuccessDamage;
        public readonly float FailureDamage;
        public readonly float Speed;
        public readonly float Distance;
        public readonly float AngleOffset;
        public readonly float Duration;

        public string Center;
        public string DungeonName;
        public string Id;
        public string LockedName;
        public string ObjectId;
        public string Target;
        public float Proc;
        public int HealthThreshold;
        public int HealthRequired;
        public float HealthRequiredRelative;
        public int ManaCost;
        public int ManaRequired;
        public int DamageThreshold;
        public string RequiredConditions;

        public ActivateEffect(XElement e)
        {
            try
            {
                Effect = (ActivateEffects)Enum.Parse(typeof(ActivateEffects), e.Value);
            }
            catch
            {
                Console.WriteLine($"Unknown effect: {e.Value}");
                Effect = ActivateEffects.None;
            }

            Speed = e.GetAttribute("speed", 0.0f);
            Distance = e.GetAttribute("distance", 8.0f);
            AngleOffset = e.GetAttribute("angleOffset", 0.0f);

            if (e.HasAttribute("effect"))
                ConditionEffect = Utils.GetEffect(e.GetAttribute<string>("effect"));

            if (e.HasAttribute("condEffect"))
                ConditionEffect = Utils.GetEffect(e.GetAttribute<string>("condEffect"));

            if (e.HasAttribute("checkExistingEffect"))
                CheckExistingEffect = Utils.GetEffect(e.GetAttribute<string>("checkExistingEffect"));

            if (e.HasAttribute("color"))
                Color = e.GetAttribute<uint>("color");

            if (e.Attribute("skinType") != null)
                SkinType = ushort.Parse(e.Attribute("skinType").Value.Substring(2), System.Globalization.NumberStyles.AllowHexSpecifier);

            if (e.Attribute("useWisMod") != null)
                UseWisMod = e.Attribute("useWisMod").Value.Equals("true");

            if (e.Attribute("target") != null)
                Target = e.Attribute("target").Value;

            if (e.Attribute("center") != null)
                Center = e.Attribute("center").Value;

            if (e.Attribute("visualEffect") != null)
                VisualEffect = Utils.FromString(e.Attribute("visualEffect").Value);

            if (e.Attribute("color") != null)
            {
                if (e.Attribute("color").Value == "-1")
                    Color = uint.MaxValue;
                else
                    Color = uint.Parse(e.Attribute("color").Value.Substring(2), System.Globalization.NumberStyles.AllowHexSpecifier);
            }

            NoStack = e.HasElement("noStack");
            TotalDamage = e.GetAttribute<int>("totalDamage");
            Radius = e.GetAttribute<float>("radius");
            EffectDuration = e.GetAttribute<float>("condDuration");
            DurationSec = e.GetAttribute<float>("duration");
            DurationMS = (int)(DurationSec * 1000.0f);
            Amount = e.GetAttribute<int>("amount");
            Range = e.GetAttribute<float>("range");
            ObjectId = e.GetAttribute<string>("objectId");
            Id = e.GetAttribute<string>("id");
            MaximumDistance = e.GetAttribute<float>("maxDistance");
            MaxTargets = e.GetAttribute<int>("maxTargets");
            Stats = e.GetAttribute<int>("stat");
            Cooldown = e.GetAttribute<float>("cooldown");
            RemoveSelf = e.GetAttribute<bool>("removeSelf");
            DungeonName = e.GetAttribute<string>("dungeonName");
            LockedName = e.GetAttribute<string>("lockedName");

            if (e.Attribute("totalDamage") != null)
                TotalDamage = Utils.FromString(e.Attribute("totalDamage").Value);

            if (e.Attribute("impactDamage") != null)
                ImpactDamage = Utils.FromString(e.Attribute("impactDamage").Value);

            if (e.Attribute("throwTime") != null)
                ThrowTime = (int)(float.Parse(e.Attribute("throwTime").Value) * 1000);

            if (e.Attribute("proc") != null)
                Proc = float.Parse(e.Attribute("proc").Value);

            if (e.Attribute("hpMinThreshold") != null)
                HealthThreshold = (int)float.Parse(e.Attribute("hpMinThreshold").Value);

            if (e.Attribute("hpRequired") != null)
                HealthRequired = (int)float.Parse(e.Attribute("hpRequired").Value);

            if (e.HasAttribute("hpRequiredRelative"))
                HealthRequiredRelative = float.Parse(e.Attribute("hpRequiredRelative").Value);

            if (e.HasAttribute("manaCost"))
                ManaCost = (int)float.Parse(e.Attribute("manaCost").Value);

            if (e.HasAttribute("manaRequired"))
                ManaRequired = (int)float.Parse(e.Attribute("manaRequired").Value);

            if (e.Attribute("damageThreshold") != null)
                DamageThreshold = (int)float.Parse(e.Attribute("damageThreshold").Value);

            if (e.HasAttribute("requiredConditions"))
                RequiredConditions = e.GetAttribute<string>("requiredConditions");

            if (e.HasAttribute("type"))
                Type = (byte)e.GetAttribute<int>("type");
        }
    }
}
