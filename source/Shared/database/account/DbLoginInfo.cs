using Newtonsoft.Json;
using StackExchange.Redis;

namespace Shared.database.account
{
    public class DbLoginInfo
    {
        private readonly IDatabase _db;

        public int AccountId { get; set; }
        public string HashedPassword { get; set; }

        [JsonIgnore] public string UUID { get; private set; }
        [JsonIgnore] public bool IsNull { get; private set; }

        public DbLoginInfo(IDatabase db, string uuid)
        {
            _db = db;

            UUID = uuid;

            var json = (string)db.HashGet("logins", uuid.ToUpperInvariant());

            if (json == null)
                IsNull = true;
            else
                JsonConvert.PopulateObject(json, this);
        }

        public void Flush() => _db.HashSet("logins", UUID.ToUpperInvariant(), JsonConvert.SerializeObject(this));
    }
}
