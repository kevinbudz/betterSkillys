using Newtonsoft.Json;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Text;
using Shared.resources;

namespace Shared.database.market
{
    public class DbMarketData
    {
        [JsonProperty("currency")] public CurrencyType Currency;
        [JsonProperty("marketId")] public int Id;
        [JsonProperty("itemType")] public ushort ItemType;
        [JsonProperty("price")] public int Price;
        [JsonProperty("sellerId")] public int SellerId;
        [JsonProperty("sellerName")] public string SellerName;
        [JsonProperty("startTime")] public int StartTime;
        [JsonProperty("timeLeft")] public int TimeLeft;
        [JsonProperty("itemData")] public string ItemData;

        private readonly IDatabase _db;

        public DbMarketData()
        { }

        public DbMarketData(IDatabase db, int id)
        {
            _db = db;

            Id = id;

            var json = (string)db.HashGet("market", id);

            if (json == null)
                IsNull = true;
            else
                JsonConvert.PopulateObject(json, this);
        }

        [JsonIgnore] public bool IsNull { get; private set; }

        public static void CleanMarket(Database db)
        {
            var allOffers = db.Conn.HashGetAll("market");

            foreach (var i in allOffers)
            {
                var l = JsonConvert.DeserializeObject<DbMarketData>(i.Value);

                if (l.TimeLeft < DateTime.UtcNow.ToUnixTimestamp())
                {
                    var owner = db.GetAccount(l.SellerId);

                    db.RemoveMarketEntrySafety(owner, l.Id);
                    db.AddGift(owner, l.ItemType);
                }
            }
        }

        public static void ForceCleanMarket(Database db)
        {
            var allOffers = db.Conn.HashGetAll("market");

            foreach (var i in allOffers)
            {
                var l = JsonConvert.DeserializeObject<DbMarketData>(i.Value);
                var owner = db.GetAccount(l.SellerId);

                db.RemoveMarketEntrySafety(owner, l.Id);
                db.AddGift(owner, l.ItemType);
            }
        }

        public static DbMarketData[] Get(IDatabase db, ushort itemType)
        {
            var ret = new List<DbMarketData>();
            var allOffers = db.HashGetAll("market");

            foreach (var i in allOffers)
            {
                var l = JsonConvert.DeserializeObject<DbMarketData>(i.Value);

                if (l.ItemType == itemType) ret.Add(l);
            }

            return ret.ToArray();
        }

        public static DbMarketData GetSpecificOffer(IDatabase db, int id)
        {
            var data = db.HashGet("market", id);

            if (data.IsNullOrEmpty)
                return null;

            var l = JsonConvert.DeserializeObject<DbMarketData>(data);

            if (l.Id == id)
                return l;
            else
                return null;
        }

        public void Flush() => _db.HashSet("market", Id, Encoding.ASCII.GetBytes(JsonConvert.SerializeObject(this)));
    }
}
