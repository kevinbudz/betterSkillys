using System;
using Shared.database.account;

namespace Shared.database.character
{
    public class DbDeath : RedisObject
    {
        public DbDeath(DbAccount acc, int charId, bool isAsync = false)
        {
            Account = acc;
            CharId = charId;

            Init(acc.Database, "death." + acc.AccountId + "." + charId, null, isAsync);
        }

        public DbAccount Account { get; private set; }
        public int CharId { get; private set; }

        public DateTime DeathTime { get => GetValue<DateTime>("deathTime"); set => SetValue("deathTime", value); }
        public bool FirstBorn { get => GetValue<bool>("firstBorn"); set => SetValue("firstBorn", value); }
        public string Killer { get => GetValue<string>("killer"); set => SetValue("killer", value); }
        public int Level { get => GetValue<int>("level"); set => SetValue("level", value); }
        public ushort ObjectType { get => GetValue<ushort>("objType"); set => SetValue("objType", value); }
        public int TotalFame { get => GetValue<int>("totalFame"); set => SetValue("totalFame", value); }
    }
}
