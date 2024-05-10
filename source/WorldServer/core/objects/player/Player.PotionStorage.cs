using Shared;
using Shared.database.account;
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

        private StatTypeValue<int> _storageLifeCount;
        public int SPSLifeCount
        {
            get => _storageLifeCount.GetValue();
            set => _storageLifeCount.SetValue(value);
        }

        private StatTypeValue<int> _storageManaCount;
        public int SPSManaCount
        {
            get => _storageManaCount.GetValue();
            set => _storageManaCount.SetValue(value);
        }

        private StatTypeValue<int> _storageDefenseCount;
        public int SPSDefenseCount
        {
            get => _storageDefenseCount.GetValue();
            set => _storageDefenseCount.SetValue(value);
        }

        private StatTypeValue<int> _storageAttackCount;
        public int SPSAttackCount
        {
            get => _storageAttackCount.GetValue();
            set => _storageAttackCount.SetValue(value);
        }

        private StatTypeValue<int> _storageDexterityCount;
        public int SPSDexterityCount
        {
            get => _storageDexterityCount.GetValue();
            set => _storageDexterityCount.SetValue(value);
        }

        private StatTypeValue<int> _storageSpeedCount;
        public int SPSSpeedCount
        {
            get => _storageSpeedCount.GetValue();
            set => _storageSpeedCount.SetValue(value);
        }

        private StatTypeValue<int> _storageVitalityCount;
        public int SPSVitalityCount
        {
            get => _storageVitalityCount.GetValue();
            set => _storageVitalityCount.SetValue(value);
        }

        private StatTypeValue<int> _storageWisdomCount;
        public int SPSWisdomCount
        {
            get => _storageWisdomCount.GetValue();
            set => _storageWisdomCount.SetValue(value);
        }

        private StatTypeValue<int> _storageLifeCountMax;
        public int SPSLifeCountMax
        {
            get => _storageLifeCountMax.GetValue();
            set => _storageLifeCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageManaCountMax;
        public int SPSManaCountMax
        {
            get => _storageManaCountMax.GetValue();
            set => _storageManaCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageDefenseCountMax;
        public int SPSDefenseCountMax
        {
            get => _storageDefenseCountMax.GetValue();
            set => _storageDefenseCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageAttackCountMax;
        public int SPSAttackCountMax
        {
            get => _storageAttackCountMax.GetValue();
            set => _storageAttackCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageDexterityCountMax;
        public int SPSDexterityCountMax
        {
            get => _storageDexterityCountMax.GetValue();
            set => _storageDexterityCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageSpeedCountMax;
        public int SPSSpeedCountMax
        {
            get => _storageSpeedCountMax.GetValue();
            set => _storageSpeedCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageVitalityCountMax;
        public int SPSVitalityCountMax
        {
            get => _storageVitalityCountMax.GetValue();
            set => _storageVitalityCountMax.SetValue(value);
        }

        private StatTypeValue<int> _storageWisdomCountMax;
        public int SPSWisdomCountMax
        {
            get => _storageWisdomCountMax.GetValue();
            set => _storageWisdomCountMax.SetValue(value);
        }

        public void InitializePotionStorage(DbAccount account)
        {
            var iRank = (int)Rank;

            var maxPotionAmount = 50;
            if (iRank <= (int)RankingType.Supporter5)
                maxPotionAmount += iRank * 10;

            _storageLifeCount = new StatTypeValue<int>(this, StatDataType.SPS_LIFE_COUNT, account.SPSLifeCount, true);
            _storageManaCount = new StatTypeValue<int>(this, StatDataType.SPS_MANA_COUNT, account.SPSManaCount, true);
            _storageDefenseCount = new StatTypeValue<int>(this, StatDataType.SPS_DEFENSE_COUNT, account.SPSDefenseCount, true);
            _storageAttackCount = new StatTypeValue<int>(this, StatDataType.SPS_ATTACK_COUNT, account.SPSAttackCount, true);
            _storageDexterityCount = new StatTypeValue<int>(this, StatDataType.SPS_DEXTERITY_COUNT, account.SPSDexterityCount, true);
            _storageSpeedCount = new StatTypeValue<int>(this, StatDataType.SPS_SPEED_COUNT, account.SPSSpeedCount, true);
            _storageVitalityCount = new StatTypeValue<int>(this, StatDataType.SPS_VITALITY_COUNT, account.SPSVitalityCount, true);
            _storageWisdomCount = new StatTypeValue<int>(this, StatDataType.SPS_WISDOM_COUNT, account.SPSWisdomCount, true);

            _storageLifeCountMax = new StatTypeValue<int>(this, StatDataType.SPS_LIFE_COUNT_MAX, maxPotionAmount, true);
            _storageManaCountMax = new StatTypeValue<int>(this, StatDataType.SPS_MANA_COUNT_MAX, maxPotionAmount, true);
            _storageDefenseCountMax = new StatTypeValue<int>(this, StatDataType.SPS_DEFENSE_COUNT_MAX, maxPotionAmount, true);
            _storageAttackCountMax = new StatTypeValue<int>(this, StatDataType.SPS_ATTACK_COUNT_MAX, maxPotionAmount, true);
            _storageDexterityCountMax = new StatTypeValue<int>(this, StatDataType.SPS_DEXTERITY_COUNT_MAX, maxPotionAmount, true);
            _storageSpeedCountMax = new StatTypeValue<int>(this, StatDataType.SPS_SPEED_COUNT_MAX, maxPotionAmount, true);
            _storageVitalityCountMax = new StatTypeValue<int>(this, StatDataType.SPS_VITALITY_COUNT_MAX, maxPotionAmount, true);
            _storageWisdomCountMax = new StatTypeValue<int>(this, StatDataType.SPS_WISDOM_COUNT_MAX, maxPotionAmount, true);
        }

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
