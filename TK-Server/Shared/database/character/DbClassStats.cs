using Newtonsoft.Json;
using System;
using Shared.database.account;

namespace Shared.database.character
{
    public struct DbClassStatsEntry
    {
        public int BestFame;
        public int BestLevel;
    }

    public class DbClassStats : RedisObject
    {
        public DbClassStats(DbAccount acc, ushort? type = null, bool isAsync = false)
        {
            Account = acc;

            Init(acc.Database, "classStats." + acc.AccountId, type?.ToString(), isAsync);
        }

        public DbAccount Account { get; private set; }

        public DbClassStatsEntry this[ushort type]
        {
            get
            {
                var v = GetValue<string>(type.ToString());

                return v != null ? JsonConvert.DeserializeObject<DbClassStatsEntry>(v) : default;
            }
            set => SetValue(type.ToString(), JsonConvert.SerializeObject(value));
        }

        public void Unlock(ushort type)
        {
            var field = type.ToString();
            var json = GetValue<string>(field);

            if (json == null)
                SetValue(field, JsonConvert.SerializeObject(new DbClassStatsEntry()
                {
                    BestLevel = 0,
                    BestFame = 0
                }));
        }

        public void Update(DbChar character)
        {
            var field = character.ObjectType.ToString();
            var finalFame = Math.Max(character.Fame, character.FinalFame);
            var json = GetValue<string>(field);

            if (json == null)
                SetValue(field, JsonConvert.SerializeObject(new DbClassStatsEntry()
                {
                    BestLevel = character.Level,
                    BestFame = finalFame
                }));
            else
            {
                var entry = JsonConvert.DeserializeObject<DbClassStatsEntry>(json);

                if (character.Level > entry.BestLevel)
                    entry.BestLevel = character.Level;

                if (finalFame > entry.BestFame)
                    entry.BestFame = finalFame;

                SetValue(field, JsonConvert.SerializeObject(entry));
            }
        }
    }
}
