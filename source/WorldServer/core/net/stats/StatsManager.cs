using System;
using Shared.resources;
using WorldServer.core.objects;

namespace WorldServer.core.net.stats
{
    public class StatsManager
    {
        internal const int NumStatTypes = 8;

        internal BaseStatManager Base;
        internal BoostStatManager Boost;
        internal Player Owner;

        private const double MAX_ATTACK_FREQ = 0.008;
        private const double MAX_ATTACK_MULT = 2.0;
        private const double MIN_ATTACK_FREQ = 0.0015;
        private const double MIN_ATTACK_MULT = 0.5;

        private StatTypeValue<int>[] _stats;

        public int length { get; internal set; }

        public StatsManager(Player owner)
        {
            Owner = owner;
            Base = new BaseStatManager(this);
            Boost = new BoostStatManager(this);

            _stats = new StatTypeValue<int>[NumStatTypes];

            for (var i = 0; i < NumStatTypes; i++)
                _stats[i] = new StatTypeValue<int>(Owner, GetStatType(i), this[i], i != 0 && i != 1); // make maxHP and maxMP global update
        }

        public int this[int index] => Base[index] + Boost[index];

        public static StatDataType GetBoostStatType(int stat)
        {
            switch (stat)
            {
                case 0:
                    return StatDataType.HealthBoost;

                case 1:
                    return StatDataType.ManaBoost;

                case 2:
                    return StatDataType.AttackBonus;

                case 3:
                    return StatDataType.DefenseBonus;

                case 4:
                    return StatDataType.SpeedBonus;

                case 5:
                    return StatDataType.DexterityBonus;

                case 6:
                    return StatDataType.VitalityBonus;

                case 7:
                    return StatDataType.WisdomBonus;

                default:
                    return StatDataType.None;
            }
        }

        public static int DamageWithDefense(Entity host, int dmg, bool pierce, int targetDefense)
        {
            var def = targetDefense;
            if (host.HasConditionEffect(ConditionEffectIndex.Armored))
                def *= 2;
            if (pierce || host.HasConditionEffect(ConditionEffectIndex.ArmorBroken))
                def = 0;

            var min = dmg * 3 / 20;
            var d = (double)Math.Max(min, dmg - def);

            if (host.HasConditionEffect(ConditionEffectIndex.Invulnerable) || host.HasConditionEffect(ConditionEffectIndex.Invincible))
                d = 0;

            if (host.HasConditionEffect(ConditionEffectIndex.Petrify))
                d *= 0.9;

            if (host.HasConditionEffect(ConditionEffectIndex.Curse))
                d *= 1.2;

            return (int)d;
        }

        public static float GetSpeed(Entity entity, float stat)
        {
            var ret = 4 + 5.6f * (stat / 75f);
            if (entity.HasConditionEffect(ConditionEffectIndex.Speedy))
                ret *= 1.4f;
            if (entity.HasConditionEffect(ConditionEffectIndex.Slowed))
                ret = 4;
            if (entity.HasConditionEffect(ConditionEffectIndex.Paralyzed))
                ret = 0;
            return ret;
        }

        public static int GetStatIndex(string name)
        {
            switch (name)
            {
                case "MaxHitPoints": return 0;
                case "MaxMagicPoints": return 1;
                case "Attack": return 2;
                case "Defense": return 3;
                case "Speed": return 4;
                case "Dexterity": return 5;
                case "HpRegen": return 6;
                case "MpRegen": return 7;
            }
            return -1;
        }

        public static int GetStatIndex(StatDataType stat)
        {
            switch (stat)
            {
                case StatDataType.MaximumHealth:
                    return 0;

                case StatDataType.MaximumMana:
                    return 1;

                case StatDataType.Attack:
                    return 2;

                case StatDataType.Defense:
                    return 3;

                case StatDataType.Speed:
                    return 4;

                case StatDataType.Dexterity:
                    return 5;

                case StatDataType.Vitality:
                    return 6;

                case StatDataType.Wisdom:
                    return 7;

                default:
                    return -1;
            }
        }

        public static StatDataType GetStatType(int stat)
        {
            switch (stat)
            {
                case 0:
                    return StatDataType.MaximumHealth;

                case 1:
                    return StatDataType.MaximumMana;

                case 2:
                    return StatDataType.Attack;

                case 3:
                    return StatDataType.Defense;

                case 4:
                    return StatDataType.Speed;

                case 5:
                    return StatDataType.Dexterity;

                case 6:
                    return StatDataType.Vitality;

                case 7:
                    return StatDataType.Wisdom;

                default:
                    return StatDataType.None;
            }
        }

        public static string StatIndexToName(int index)
        {
            switch (index)
            {
                case 0: return "MaxHitPoints";
                case 1: return "MaxMagicPoints";
                case 2: return "Attack";
                case 3: return "Defense";
                case 4: return "Speed";
                case 5: return "Dexterity";
                case 6: return "HpRegen";
                case 7: return "MpRegen";
            }
            return null;
        }

        public double GetAttackFrequency()
        {
            if (Owner.HasConditionEffect(ConditionEffectIndex.Dazed))
                return MIN_ATTACK_FREQ;
            var rof = MIN_ATTACK_FREQ + this[5] / (double)75.0 * (MAX_ATTACK_FREQ - MIN_ATTACK_FREQ);
            if (Owner.HasConditionEffect(ConditionEffectIndex.Berserk) || Owner.HasConditionEffect(ConditionEffectIndex.NinjaBerserk))
                rof *= 1.25;
            return rof;
        }

        private const double MIN_MOVE_SPEED = 0.004;
        private const double MAX_MOVE_SPEED = 0.0096;

        public double MoveSpeed(double multiplier)
        {
            if (Owner.HasConditionEffect(ConditionEffectIndex.Slowed))
                return MIN_MOVE_SPEED * multiplier;
            var spdMult = MIN_MOVE_SPEED + this[4] / (double)75.0 * (MAX_MOVE_SPEED - MIN_MOVE_SPEED);
            if (Owner.HasConditionEffect(ConditionEffectIndex.Speedy))
                spdMult *= 1.5;
            return spdMult * multiplier;
        }

        public double GetAttackMult()
        {
            if (Owner.HasConditionEffect(ConditionEffectIndex.Weak))
                return MIN_ATTACK_MULT;

            var mult = MIN_ATTACK_MULT + this[2] / (double)75.0 * (MAX_ATTACK_MULT - MIN_ATTACK_MULT);
            if (Owner.HasConditionEffect(ConditionEffectIndex.Damaging) || Owner.HasConditionEffect(ConditionEffectIndex.NinjaDamaging))
                mult *= 1.25;
            return mult;
        }

        public float GetDefenseDamage(int dmg, bool noDef)
        {
            var def = this[3];

            if (Owner.HasConditionEffect(ConditionEffectIndex.Armored))
                def *= 2;

            if (Owner.HasConditionEffect(ConditionEffectIndex.ArmorBroken) || noDef)
                def = 0;

            float limit = dmg * 0.15f;

            float ret;
            if (dmg - def < limit)
                ret = limit;
            else
                ret = dmg - def;

            if (Owner.HasConditionEffect(ConditionEffectIndex.Petrify))
                ret = (int)(ret * .9);
            if (Owner.HasConditionEffect(ConditionEffectIndex.Curse))
                ret = (int)(ret * 1.20);
            if (Owner.HasConditionEffect(ConditionEffectIndex.Invulnerable) || Owner.HasConditionEffect(ConditionEffectIndex.Invincible))
                ret = 0;
            return ret;
        }

        public float GetSpeed() => GetSpeed(Owner, this[4]);

        public void ReCalculateValues()
        {
            Base.ReCalculateValues();
            Boost.ReCalculateValues();

            for (var i = 0; i < _stats.Length; i++)
                _stats[i].SetValue(this[i]);

            if (Owner.Health > Owner.Stats[0])
                Owner.Health = Owner.Stats[0];
            if (Owner.Mana > Owner.Stats[1])
                Owner.Mana = Owner.Stats[1];
        }

        internal void StatChanged(int index) => _stats[index].SetValue(this[index]);
    }
}
