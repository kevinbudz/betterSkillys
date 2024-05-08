using WorldServer.core.net.stats;

namespace WorldServer.core.objects
{
    partial class Player
    {
        public const string POTION_OF_LIFE = "Potion of Life";
        public const string POTION_OF_MANA = "Potion of Mana";
        public const string POTION_OF_ATTACK = "Potion of Attack";
        public const string POTION_OF_DEFENSE = "Potion of Defense";
        public const string POTION_OF_DEXTERITY = "Potion of Dexterity";
        public const string POTION_OF_SPEED = "Potion of Speed";
        public const string POTION_OF_VITALITY = "Potion of Vitality";
        public const string POTION_OF_WISDOM = "Potion of Wisdom";
        public const string UNKNOWN_POTION = "Unknown";

        public int SPSLifeCount { get => _SPSLifeCount.GetValue(); set => _SPSLifeCount.SetValue(value); }
        public int SPSManaCount { get => _SPSManaCount.GetValue(); set => _SPSManaCount.SetValue(value); }
        public int SPSDefenseCount { get => _SPSDefenseCount.GetValue(); set => _SPSDefenseCount.SetValue(value); }
        public int SPSAttackCount { get => _SPSAttackCount.GetValue(); set => _SPSAttackCount.SetValue(value); }
        public int SPSDexterityCount { get => _SPSDexterityCount.GetValue(); set => _SPSDexterityCount.SetValue(value); }
        public int SPSSpeedCount { get => _SPSSpeedCount.GetValue(); set => _SPSSpeedCount.SetValue(value); }
        public int SPSVitalityCount { get => _SPSVitalityCount.GetValue(); set => _SPSVitalityCount.SetValue(value); }
        public int SPSWisdomCount { get => _SPSWisdomCount.GetValue(); set => _SPSWisdomCount.SetValue(value); }
        public int SPSLifeCountMax { get => _SPSLifeCountMax.GetValue(); set => _SPSLifeCountMax.SetValue(value); }
        public int SPSManaCountMax { get => _SPSManaCountMax.GetValue(); set => _SPSManaCountMax.SetValue(value); }
        public int SPSDefenseCountMax { get => _SPSDefenseCountMax.GetValue(); set => _SPSDefenseCountMax.SetValue(value); }
        public int SPSAttackCountMax { get => _SPSAttackCountMax.GetValue(); set => _SPSAttackCountMax.SetValue(value); }
        public int SPSDexterityCountMax { get => _SPSDexterityCountMax.GetValue(); set => _SPSDexterityCountMax.SetValue(value); }
        public int SPSSpeedCountMax { get => _SPSSpeedCountMax.GetValue(); set => _SPSSpeedCountMax.SetValue(value); }
        public int SPSVitalityCountMax { get => _SPSVitalityCountMax.GetValue(); set => _SPSVitalityCountMax.SetValue(value); }
        public int SPSWisdomCountMax { get => _SPSWisdomCountMax.GetValue(); set => _SPSWisdomCountMax.SetValue(value); }

        private readonly StatTypeValue<int> _SPSLifeCount;
        private readonly StatTypeValue<int> _SPSManaCount;
        private readonly StatTypeValue<int> _SPSDefenseCount;
        private readonly StatTypeValue<int> _SPSAttackCount;
        private readonly StatTypeValue<int> _SPSDexterityCount;
        private readonly StatTypeValue<int> _SPSSpeedCount;
        private readonly StatTypeValue<int> _SPSVitalityCount;
        private readonly StatTypeValue<int> _SPSWisdomCount;
        private readonly StatTypeValue<int> _SPSLifeCountMax;
        private readonly StatTypeValue<int> _SPSManaCountMax;
        private readonly StatTypeValue<int> _SPSDefenseCountMax;
        private readonly StatTypeValue<int> _SPSAttackCountMax;
        private readonly StatTypeValue<int> _SPSDexterityCountMax;
        private readonly StatTypeValue<int> _SPSSpeedCountMax;
        private readonly StatTypeValue<int> _SPSVitalityCountMax;
        private readonly StatTypeValue<int> _SPSWisdomCountMax;

        public static string GetPotionFromType(int type) => type switch
        {
            0 => POTION_OF_LIFE,
            1 => POTION_OF_MANA,
            2 => POTION_OF_ATTACK,
            3 => POTION_OF_DEFENSE,
            4 => POTION_OF_SPEED,
            5 => POTION_OF_DEXTERITY,
            6 => POTION_OF_VITALITY,
            7 => POTION_OF_WISDOM,
            _ => UNKNOWN_POTION,
        };
    }
}
