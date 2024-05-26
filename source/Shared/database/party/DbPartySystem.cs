using Newtonsoft.Json;
using StackExchange.Redis;
using System.Collections.Generic;
using Shared;

namespace Shared.database.party
{
    public enum PartySizes
    {
        NPlayer = 4,
        S1 = 5,
        S2 = 6,
        S3 = 7,
    }

    public class DbPartySystem
    {
        private IDatabase _db;

        public DbPartySystem()
        { }

        public DbPartySystem(IDatabase db, int id)
        {
            _db = db;

            PartyId = id;

            var json = (string)db.HashGet("party", id);

            if (json != null)
                JsonConvert.PopulateObject(json, this);
        }

        public int PartyId { get; set; }
        public (string, int) PartyLeader { get; set; }
        public List<DbPartyMemberData> PartyMembers { get; set; }
        public int WorldId { get; set; }

        public static DbPartySystem Get(IDatabase db, int partyId)
        {
            if (partyId == 0)
                return null;

            var allParties = db.HashGet("party", partyId);

            if (allParties.IsNullOrEmpty)
                return null;

            var l = JsonConvert.DeserializeObject<DbPartySystem>(allParties);

            if (l.PartyId == partyId)
                return l;
            else
                return null;
        }

        public static int NextId(IDatabase db)
        {
            int id = 0;

            do id++;
            while ((string)db.HashGet("party", id) != null);

            return id;
        }

        public static int ReturnSize(RankingType rank)
        {
            switch (rank)
            {
                // todo
                case RankingType.Donator:
                    return (int)PartySizes.S1;
                case RankingType.Supporter:
                    return (int)PartySizes.S2;
                case RankingType.Sponsor:
                    return (int)PartySizes.S3;
                case RankingType.Sandbox:
                case RankingType.Moderator:
                case RankingType.Admin:
                    return (int)PartySizes.S3;
                default:
                    return (int)PartySizes.NPlayer;
            }
        }

        public void Flush() => _db.HashSet("party", PartyId, JsonConvert.SerializeObject(this));

        public int ReturnWorldId() => WorldId;
    }
}
