using Newtonsoft.Json;
using StackExchange.Redis;
using Shared;

namespace Shared.database.account
{
    public sealed class DbRank
    {
        private readonly IDatabase _db;

        public RankingType Rank { get; set; }
        public int TotalAmountDonated { get; set; }
        public int NewAmountDonated { get; set; }
        public bool IsCommunityManager { get; set; }

        [JsonIgnore] public int AccountId { get; private set; }
        [JsonIgnore] public bool IsNull { get; private set; }

        public DbRank(IDatabase db, int accountId)
        {
            _db = db;

            AccountId = accountId;

            var json = (string)db.HashGet("ranks", AccountId);

            if (json == null)
                IsNull = true;
            else
                JsonConvert.PopulateObject(json, this);
        }

        public void Flush() => _db.HashSet("ranks", AccountId, JsonConvert.SerializeObject(this));

        [JsonIgnore] public bool IsAdmin => Rank >= RankingType.Admin;
        [JsonIgnore] public bool IsSupporter1 => Rank >= RankingType.Supporter1;
        [JsonIgnore] public bool IsSupporter2 => Rank >= RankingType.Supporter2;
        [JsonIgnore] public bool IsSupporter3 => Rank >= RankingType.Supporter3;
        [JsonIgnore] public bool IsSupporter4 => Rank >= RankingType.Supporter4;
        [JsonIgnore] public bool IsSupporter5 => Rank >= RankingType.Supporter5;
    }
}
