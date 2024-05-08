using StackExchange.Redis;
using Shared.database.account;

namespace Shared.database.guild
{
    public enum GuildCreateStatus
    {
        Ok,
        InvalidName,
        UsedName
    }

    public enum GuildRank : byte
    {
        Initiate = 0,
        Member = 10,
        Officer = 20,
        Leader = 30,
        Founder = 40
    }

    public enum DbAddGuildMemberStatus
    {
        OK,
        NameNotChosen,
        AlreadyInGuild,
        InAnotherGuild,
        IsAMember,
        GuildFull,
        Error
    }

    public enum DbGuildCreateStatus
    {
        OK,
        InvalidName,
        UsedName
    }

    public class DbGuild : RedisObject
    {
        public readonly object MemberLock;

        public DbGuild(DbAccount acc, bool isAsync = false)
        {
            MemberLock = new object();
            Id = acc.GuildId;

            Init(acc.Database, "guild." + Id, null, isAsync);
        }

        public DbGuild(IDatabase db, int id, bool isAsync = false)
        {
            MemberLock = new object();
            Id = id;

            Init(db, "guild." + id, null, isAsync);
        }

        public string Board { get => GetValue<string>("board") ?? ""; set => SetValue("board", value); }
        public int Fame { get => GetValue<int>("fame"); set => SetValue("fame", value); }
        public int GuildCurrency { get => GetValue<int>("guildCurrency"); set => SetValue("guildCurrency", value); }
        public float GuildLootBoost { get => GetValue<float>("guildLootBoost"); set => SetValue("guildLootBoost", value); }
        public int GuildPoints { get => GetValue<int>("guildPoints"); set => SetValue("guildPoints", value); }

        public int Id { get; private set; }

        public int Level { get => GetValue<int>("level"); set => SetValue("level", value); }
        public int[] Members { get => GetValue<int[]>("members") ?? new int[0]; set => SetValue("members", value); }
        public string Name { get => GetValue<string>("name"); set => SetValue("name", value); }
        public int TotalFame { get => GetValue<int>("totalFame"); set => SetValue("totalFame", value); }
    }
}
