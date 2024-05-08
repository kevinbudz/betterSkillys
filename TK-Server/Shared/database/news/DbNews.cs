using Newtonsoft.Json;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Shared.database.news
{
    public class DbNews
    {
        public DbNewsEntry[] Entries;

        public DbNews(IDatabase db, int count) => Entries = GetEntries(db).ToArray();

        private IEnumerable<DbNewsEntry> GetEntries(IDatabase db)
        {
            var entries = db.SortedSetRangeByRankWithScores("news", 0, 10);

            for (var i = 0; i < entries.Length; i++)
            {
                var ret = JsonConvert.DeserializeObject<DbNewsEntry>(Encoding.UTF8.GetString(entries[i].Element));
                ret.Date = new DateTime(1970, 1, 1, 0, 0, 0).AddSeconds(entries[i].Score);

                yield return ret;
            }
        }
    }
}
