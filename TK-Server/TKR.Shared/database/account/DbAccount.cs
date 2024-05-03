using StackExchange.Redis;
using System;
using TKR.Shared;

namespace TKR.Shared.database.account
{
    public class DbAccount : RedisObject
    {
        public DbAccount(IDatabase db, int accId, string field = null, bool isAsync = false)
        {
            AccountId = accId;



            Init(db, "account." + accId, field, isAsync);

            if (isAsync || field != null)
                return;

            var time = Utils.FromUnixTimestamp(BanLiftTime);

            if (!Banned || BanLiftTime <= -1 || time > DateTime.UtcNow)
                return;

            Banned = false;
            BanLiftTime = 0;

            FlushAsync();
        }

        public int AccountId { get; private set; }
        public int BanLiftTime { get => GetValue<int>("banLiftTime"); set => SetValue("banLiftTime", value); }
        public bool Banned { get => GetValue<bool>("banned"); set => SetValue("banned", value); }
        public int ColorChat { get => GetValue<int>("colorchat"); set => SetValue("colorchat", value); }
        public int ColorNameChat { get => GetValue<int>("colornamechat"); set => SetValue("colornamechat", value); }
        public int Credits { get => GetValue<int>("credits"); set => SetValue("credits", value); }
        public int Fame { get => GetValue<int>("fame"); set => SetValue("fame", value); }
        public bool FirstDeath { get => GetValue<bool>("firstDeath"); set => SetValue("firstDeath", value); }
        public ushort[] Gifts { get => GetValue<ushort[]>("gifts") ?? new ushort[0]; set => SetValue("gifts", value); }
        public int GlowColor { get => GetValue<int>("glow"); set => SetValue("glow", value); }
        public bool Guest { get => GetValue<bool>("guest"); set => SetValue("guest", value); }
        public int GuildFame { get => GetValue<int>("guildFame"); set => SetValue("guildFame", value); }
        public int GuildId { get => GetValue<int>("guildId"); set => SetValue("guildId", value); }
        public int GuildRank { get => GetValue<int>("guildRank"); set => SetValue("guildRank", value); }
        public bool Hidden { get => GetValue<bool>("hidden"); set => SetValue("hidden", value); }
        public int[] IgnoreList { get => GetValue<int[]>("ignoreList") ?? new int[0]; set => SetValue("ignoreList", value); }
        public string IP { get => GetValue<string>("ip"); set => SetValue("ip", value); }
        public DateTime LastRecoveryTime { get => GetValue<DateTime>("lastRecoveryTime"); set => SetValue("lastRecoveryTime", value); }
        public int LastSeen { get => GetValue<int>("lastSeen"); set => SetValue("lastSeen", value); }
        public int FuelContributed { get => GetValue<int>("fuelContributed"); set => SetValue("fuelContributed", value); }
        //public RankingType Rank { get => (RankingType)GetValue<int>("rank"); set => SetValue("rank", (int)value); }
        public int[] LockList { get => GetValue<int[]>("lockList") ?? new int[0]; set => SetValue("lockList", value); }
        public int[] MarketOffers { get => GetValue<int[]>("marketOffers") ?? new int[0]; set => SetValue("marketOffers", value); }
        public int MaxCharSlot { get => GetValue<int>("maxCharSlot"); set => SetValue("maxCharSlot", value); }
        public string Name { get => GetValue<string>("name"); set => SetValue("name", value); }
        public bool NameChosen { get => GetValue<bool>("nameChosen"); set => SetValue("nameChosen", value); }
        public int NextCharId { get => GetValue<int>("nextCharId"); set => SetValue("nextCharId", value); }
        public string Notes { get => GetValue<string>("notes"); set => SetValue("notes", value); }
        public int PartyId { get => GetValue<int>("partyId"); set => SetValue("partyId", value); }
        public string PassResetToken { get => GetValue<string>("passResetToken"); set => SetValue("passResetToken", value); }
        public DateTime RegTime { get => GetValue<DateTime>("regTime"); set => SetValue("regTime", value); }
        public int SetBaseStat { get => GetValue<int>("setBaseStat"); set => SetValue("setBaseStat", value); }
        public int Size { get => GetValue<int>("size"); set => SetValue("size", value); }
        public ushort[] Skins { get => GetValue<ushort[]>("skins") ?? new ushort[0]; set => SetValue("skins", value); }
        public int TotalCredits { get => GetValue<int>("totalCredits"); set => SetValue("totalCredits", value); }
        public int TotalFame { get => GetValue<int>("totalFame"); set => SetValue("totalFame", value); }
        public string UUID { get => GetValue<string>("uuid"); set => SetValue("uuid", value); }
        public int VaultCount { get => GetValue<int>("vaultCount"); set => SetValue("vaultCount", value); }
        public int SPSLifeCount { get => GetValue<int>("sps_lifeCount"); set => SetValue("sps_lifeCount", value); }
        public int SPSManaCount { get => GetValue<int>("sps_manaCount"); set => SetValue("sps_manaCount", value); }
        public int SPSDefenseCount { get => GetValue<int>("sps_defenseCount"); set => SetValue("sps_defenseCount", value); }
        public int SPSAttackCount { get => GetValue<int>("sps_attackCount"); set => SetValue("sps_attackCount", value); }
        public int SPSDexterityCount { get => GetValue<int>("sps_dexterityCount"); set => SetValue("sps_dexterityCount", value); }
        public int SPSSpeedCount { get => GetValue<int>("sps_speedCount"); set => SetValue("sps_speedCount", value); }
        public int SPSVitalityCount { get => GetValue<int>("sps_vitalityCount"); set => SetValue("sps_vitalityCount", value); }
        public int SPSWisdomCount { get => GetValue<int>("sps_wisdomCount"); set => SetValue("sps_wisdomCount", value); }

        internal string LockToken { get; set; }

        public void RefreshLastSeen() => LastSeen = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
    }
}
