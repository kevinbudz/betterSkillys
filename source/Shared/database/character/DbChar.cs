using System;
using Shared.database.account;
using Shared.database.character.inventory;

namespace Shared.database.character
{
    public class DbChar : RedisObject
    {
        public DbChar(DbAccount acc, int charId, bool isAsync = false)
        {
            Account = acc;
            CharId = charId;

            Init(acc.Database, "char." + acc.AccountId + "." + charId, null, isAsync);
        }

        public DbAccount Account { get; private set; }

        public int CharId { get; private set; }
        public DateTime CreateTime { get => GetValue<DateTime>("createTime"); set => SetValue("createTime", value); }
        public bool Dead { get => GetValue<bool>("dead"); set => SetValue("dead", value); }
        public int Experience { get => GetValue<int>("exp"); set => SetValue("exp", value); }
        public int Fame { get => GetValue<int>("fame"); set => SetValue("fame", value); }
        public byte[] FameStats { get => GetValue<byte[]>("fameStats"); set => SetValue("fameStats", value); }
        public int FinalFame { get => GetValue<int>("finalFame"); set => SetValue("finalFame", value); }
        public bool HasBackpack { get => GetValue<bool>("hasBackpack"); set => SetValue("hasBackpack", value); }
        public int HealthStackCount { get => GetValue<int>("hpPotCount"); set => SetValue("hpPotCount", value); }
        public int Health { get => GetValue<int>("hp"); set => SetValue("hp", value); }
        public ushort[] Items { get => GetValue<ushort[]>("items"); set => SetValue("items", value); }
        public ItemData[] Datas { get => GetValue<ItemData[]>("datas"); set => SetValue("datas", value); }
        public DateTime LastSeen { get => GetValue<DateTime>("lastSeen"); set => SetValue("lastSeen", value); }
        public int LDBoostTime { get => GetValue<int>("ldBoost"); set => SetValue("ldBoost", value); }
        public int Level { get => GetValue<int>("level"); set => SetValue("level", value); }
        public int MagicStackCount { get => GetValue<int>("mpPotCount"); set => SetValue("mpPotCount", value); }
        public int MP { get => GetValue<int>("mp"); set => SetValue("mp", value); }
        public ushort ObjectType { get => GetValue<ushort>("charType"); set => SetValue("charType", value); }
        public int PetId { get => GetValue<int>("petId"); set => SetValue("petId", value); }
        public int Skin { get => GetValue<int>("skin"); set => SetValue("skin", value); }

        public int[] Stats { get => GetValue<int[]>("stats"); set => SetValue("stats", value); }
        public int Tex1 { get => GetValue<int>("tex1"); set => SetValue("tex1", value); }
        public int Tex2 { get => GetValue<int>("tex2"); set => SetValue("tex2", value); }
        public bool UpgradeEnabled { get => GetValue<bool>("upgradeEnabled"); set => SetValue("upgradeEnabled", value); }
        public int XPBoostTime { get => GetValue<int>("xpBoost"); set => SetValue("xpBoost", value); }
        public bool CompletedTrialOfSouls { get => GetValue<bool>("completedTrialOfSouls"); set => SetValue("completedTrialOfSouls", value); }
    }
}
