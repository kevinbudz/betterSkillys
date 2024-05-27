using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using Shared;
using Shared.database;
using Shared.database.account;
using Shared.database.character;
using Shared.database.character.inventory;
using Shared.database.guild;
using Shared.database.news;
using Shared.database.vault;

namespace App
{
    public class ServerItem
    {
        public string Name { get; set; }
        public string DNS { get; set; }
        public int Port { get; set; }
        public double Lat { get; set; }
        public double Long { get; set; }
        public double Usage { get; set; }
        public bool AdminOnly { get; set; }
        public string UsageText { get; set; }

        public XElement ToXml()
        {
            return
                new XElement("Server",
                    new XElement("Name", Name),
                    new XElement("DNS", DNS),
                    new XElement("Port", Port),
                    new XElement("Lat", Lat),
                    new XElement("Long", Long),
                    new XElement("Usage", Usage),
                    new XElement("AdminOnly", AdminOnly),
                    new XElement("UsageText", UsageText)
                );
        }
    }

    internal class NewsItem
    {
        public string Icon { get; internal set; }
        public string Title { get; internal set; }
        public string TagLine { get; internal set; }
        public string Link { get; internal set; }
        public DateTime Date { get; internal set; }

        public static NewsItem FromDb(DbNewsEntry entry)
        {
            return new NewsItem()
            {
                Icon = entry.Icon,
                Title = entry.Title,
                TagLine = entry.Text,
                Link = entry.Link,
                Date = entry.Date
            };
        }

        public XElement ToXml()
        {
            return
                new XElement("Item",
                    new XElement("Icon", Icon),
                    new XElement("Title", Title),
                    new XElement("TagLine", TagLine),
                    new XElement("Link", Link),
                    new XElement("Date", Date.ToUnixTimestamp())
                );
        }
    }

    internal class GuildMember
    {
        private string _name;
        private int _rank;
        private int _guildFame;
        private int _lastSeen;

        public static GuildMember FromDb(DbAccount acc)
        {
            return new GuildMember()
            {
                _name = acc.Name,
                _rank = acc.GuildRank,
                _guildFame = acc.GuildFame,
                _lastSeen = acc.LastSeen
            };
        }

        public XElement ToXml()
        {
            return new XElement("Member",
                new XElement("Name", _name),
                new XElement("Rank", _rank),
                new XElement("Fame", _guildFame),
                new XElement("LastSeen", _lastSeen));
        }
    }

    internal class Guild
    {
        private int _id;
        private string _name;
        private int _currentFame;
        private int _totalFame;
        private string _hallType;
        private List<GuildMember> _members;

        public static Guild FromDb(CoreService core, DbGuild guild)
        {
            var members = (from member in guild.Members
                           select core.Database.GetAccount(member) into acc
                           where acc != null
                           orderby acc.GuildRank descending,
                                   acc.GuildFame descending,
                                   acc.Name ascending
                           select GuildMember.FromDb(acc)).ToList();

            return new Guild()
            {
                _id = guild.Id,
                _name = guild.Name,
                _currentFame = guild.Fame,
                _totalFame = guild.TotalFame,
                _hallType = "Guild Hall " + guild.Level,
                _members = members
            };
        }

        public XElement ToXml()
        {
            var guild = new XElement("Guild");
            guild.Add(new XAttribute("id", _id));
            guild.Add(new XAttribute("name", _name));
            guild.Add(new XElement("TotalFame", _totalFame));
            guild.Add(new XElement("CurrentFame", _currentFame));
            guild.Add(new XElement("HallType", _hallType));
            foreach (var member in _members)
                guild.Add(member.ToXml());

            return guild;
        }
    }

    internal class GuildIdentity
    {
        private int _id;
        private string _name;
        private int _rank;

        public static GuildIdentity FromDb(DbAccount acc, DbGuild guild)
        {
            return new GuildIdentity()
            {
                _id = guild.Id,
                _name = guild.Name,
                _rank = acc.GuildRank
            };
        }

        public XElement ToXml()
        {
            return
                new XElement("Guild",
                    new XAttribute("id", _id),
                    new XElement("Name", _name),
                    new XElement("Rank", _rank)
                );
        }
    }

    internal class ClassStatsEntry
    {
        public ushort ObjectType { get; private set; }
        public int BestLevel { get; private set; }
        public int BestFame { get; private set; }

        public static ClassStatsEntry FromDb(ushort objType, DbClassStatsEntry entry)
        {
            return new ClassStatsEntry()
            {
                ObjectType = objType,
                BestLevel = entry.BestLevel,
                BestFame = entry.BestFame
            };
        }

        public XElement ToXml()
        {
            return
                new XElement("ClassStats",
                    new XAttribute("objectType", ObjectType.To4Hex()),
                    new XElement("BestLevel", BestLevel),
                    new XElement("BestFame", BestFame)
                );
        }
    }

    internal class Stats
    {
        public int BestCharFame { get; private set; }
        public int TotalFame { get; private set; }
        public int Fame { get; private set; }

        private Dictionary<ushort, ClassStatsEntry> entries;

        public ClassStatsEntry this[ushort objType]
        {
            get { return entries[objType]; }
        }

        public static Stats FromDb(DbAccount acc, DbClassStats stats)
        {
            Stats ret = new Stats()
            {
                TotalFame = acc.TotalFame,
                Fame = acc.Fame,
                entries = new Dictionary<ushort, ClassStatsEntry>(),
                BestCharFame = 0
            };
            foreach (var i in stats.AllKeys)
            {
                var objType = ushort.Parse(i);
                var entry = ClassStatsEntry.FromDb(objType, stats[objType]);
                if (entry.BestFame > ret.BestCharFame) ret.BestCharFame = entry.BestFame;
                ret.entries[objType] = entry;
            }
            return ret;
        }

        public XElement ToXml()
        {
            return
                new XElement("Stats",
                    entries.Values.Select(x => x.ToXml()),
                    new XElement("BestCharFame", BestCharFame),
                    new XElement("TotalFame", TotalFame),
                    new XElement("Fame", Fame)
                );
        }
    }

    internal class Vault
    {
        private ushort[][] chests;

        public ushort[] this[int index]
        {
            get { return chests[index]; }
        }

        public static Vault FromDb(DbAccount acc, DbVault vault)
        {
            return new Vault()
            {
                chests = Enumerable.Range(0, acc.VaultCount - 1).
                            Select(x => vault[x] ?? Enumerable.Repeat((ushort)0xffff, 8).ToArray()).ToArray()
            };
        }

        public XElement ToXml()
        {
            return
                new XElement("Vault",
                    chests.Select(x => new XElement("Chest", x.Select(i => (short)i).Take(8).ToArray().ToCommaSepString()))
                );
        }
    }

    internal class Account
    {
        public int AccountId { get; private set; }
        public string Name { get; set; }

        public bool NameChosen { get; private set; }
        public int Rank { get; private set; }
        public bool Admin { get; private set; }
        public bool FirstDeath { get; private set; }

        public int Credits { get; private set; }
        public int AmountDonated { get; private set; }
        public int NextCharSlotPrice { get; private set; }
        public int NextCharSlotCurrency { get; private set; }
        public string MenuMusic { get; private set; }
        public string DeadMusic { get; private set; }

        public Vault Vault { get; private set; }
        public int[] StoredPotions { get; private set; }
        public Stats Stats { get; private set; }
        public GuildIdentity Guild { get; private set; }

        public ushort[] Skins { get; private set; }

        public static Account FromDb(CoreService core, DbAccount acc)
        {
            return new Account()
            {
                AccountId = acc.AccountId,
                Name = acc.Name,

                NameChosen = acc.NameChosen,
                Rank = acc.Rank,
                Admin = acc.Admin,
                FirstDeath = acc.FirstDeath,

                Credits = acc.Credits,
                NextCharSlotPrice = core.Resources.Settings.NewAccounts.SlotCost,
                NextCharSlotCurrency = (int)core.Resources.Settings.NewAccounts.SlotCurrency,
                MenuMusic = core.Resources.Settings.MenuMusic,
                DeadMusic = core.Resources.Settings.DeadMusic,

                Vault = Vault.FromDb(acc, new DbVault(acc)),
                StoredPotions = acc.StoredPotions ?? new int[8],
                Stats = Stats.FromDb(acc, new DbClassStats(acc)),
                Guild = GuildIdentity.FromDb(acc, new DbGuild(acc)),

                Skins = acc.Skins ?? new ushort[0],
            };
        }

        public XElement ToXml()
        {
            return
                new XElement("Account",
                    new XElement("AccountId", AccountId),
                    new XElement("Name", Name),
                    new XElement("Rank", Rank),
                    new XElement("Admin", Admin),

                    NameChosen ? new XElement("NameChosen", "") : null,
                    FirstDeath ? new XElement("isFirstDeath", "") : null,

                    new XElement("Credits", Credits),
                    new XElement("AmountDonated", AmountDonated),
                    new XElement("NextCharSlotPrice", NextCharSlotPrice),
                    new XElement("NextCharSlotCurrency", NextCharSlotCurrency),
                    new XElement("MenuMusic", MenuMusic),
                    new XElement("DeadMusic", DeadMusic),
                    new XElement("StoredPotions", string.Join(",", StoredPotions)),

                    Vault.ToXml(),
                    Stats.ToXml(),
                    Guild.ToXml()
                );
        }

        public XElement PotionsToXml()
        {
            return new XElement("StoredPotions", string.Join(",", StoredPotions));
        }
    }

    internal class Character
    {
        public int CharacterId { get; private set; }
        public ushort ObjectType { get; private set; }
        public int Level { get; private set; }
        public int Exp { get; private set; }
        public int CurrentFame { get; private set; }
        public int[] Equipment { get; private set; }
        public string[] ItemData { get; private set; }
        public int MaxHitPoints { get; private set; }
        public int HitPoints { get; private set; }
        public int MaxMagicPoints { get; private set; }
        public int MagicPoints { get; private set; }
        public int Attack { get; private set; }
        public int Defense { get; private set; }
        public int Speed { get; private set; }
        public int Dexterity { get; private set; }
        public int HpRegen { get; private set; }
        public int MpRegen { get; private set; }
        public int Tex1 { get; private set; }
        public int Tex2 { get; private set; }
        public int Skin { get; private set; }
        public FameStats PCStats { get; private set; }
        public int HealthStackCount { get; private set; }
        public int MagicStackCount { get; private set; }
        public bool Dead { get; private set; }
        public bool HasBackpack { get; private set; }

        public static Character FromDb(DbChar character, bool dead)
        {
            return new Character()
            {
                CharacterId = character.CharId,
                ObjectType = character.ObjectType,
                Level = character.Level,
                Exp = character.Experience,
                CurrentFame = character.Fame,
                Equipment = character.Items.Select(x => x == 0xFFFF ? -1 : x).ToArray(),
                ItemData = GetJson(character.Datas ?? new ItemData[28]),
                MaxHitPoints = character.Stats[0],
                MaxMagicPoints = character.Stats[1],
                Attack = character.Stats[2],
                Defense = character.Stats[3],
                Speed = character.Stats[4],
                Dexterity = character.Stats[5],
                HpRegen = character.Stats[6],
                MpRegen = character.Stats[7],
                HitPoints = character.Health,
                MagicPoints = character.MP,
                Tex1 = character.Tex1,
                Tex2 = character.Tex2,
                Skin = character.Skin,
                PCStats = FameStats.Read(character.FameStats),
                HealthStackCount = character.HealthStackCount,
                MagicStackCount = character.MagicStackCount,
                Dead = dead,
                HasBackpack = character.HasBackpack
            };
        }

        public static string[] GetJson(ItemData[] datas)
        {
            var datasString = new string[datas.Length];
            for (var i = 0; i < datas.Length; i++)
                datasString[i] = datas[i]?.GetData() ?? "{}";
            return datasString;
        }

        public XElement ToXml()
        {
            return
                new XElement("Char",
                    new XAttribute("id", CharacterId),
                    new XElement("ObjectType", ObjectType),
                    new XElement("Level", Level),
                    new XElement("Exp", Exp),
                    new XElement("CurrentFame", CurrentFame),
                    new XElement("Equipment", Equipment.ToCommaSepString()),
                    new XElement("ItemDatas", ItemData.ToArray().ToCommaDotSepString()),
                    new XElement("MaxHitPoints", MaxHitPoints),
                    new XElement("HitPoints", HitPoints),
                    new XElement("MaxMagicPoints", MaxMagicPoints),
                    new XElement("MagicPoints", MagicPoints),
                    new XElement("Attack", Attack),
                    new XElement("Defense", Defense),
                    new XElement("Speed", Speed),
                    new XElement("Dexterity", Dexterity),
                    new XElement("HpRegen", HpRegen),
                    new XElement("MpRegen", MpRegen),
                    new XElement("Tex1", Tex1),
                    new XElement("Tex2", Tex2),
                    new XElement("Texture", Skin),
                    new XElement("PCStats", Convert.ToBase64String(PCStats.Write())),
                    new XElement("HealthStackCount", HealthStackCount),
                    new XElement("MagicStackCount", MagicStackCount),
                    new XElement("Dead", Dead),
                    new XElement("HasBackpack", HasBackpack ? "1" : "0")
                );
        }
    }

    internal class ClassAvailability
    {
        // Availability is based off DbClassStats class.
        // A player class is available if it has an entry
        // in the class stats table or meets unlock req.
        // When a class is unlocked via gold, a
        // 0 bestfame & 0 bestlevel entry is added
        // for that class to the class stats table.

        public Dictionary<string, string> Classes { get; private set; }

        public static ClassAvailability FromDb(CoreService core, Database db, DbAccount acc)
        {
            var classes = core._classAvailability.Keys.ToDictionary(id => id, id => core._classAvailability[id]);

            var cs = db.ReadClassStats(acc);
            foreach (string c in cs.AllKeys
                .Select(key => core._classes[(ushort)(int)key]))
                classes[c] = "unrestricted";

            return new ClassAvailability()
            {
                Classes = classes
            };
        }

        public XElement ToXml()
        {
            var elem = new XElement("ClassAvailabilityList");
            foreach (var @class in Classes.Keys)
            {
                var ca = new XElement("ClassAvailability", Classes[@class]);
                ca.Add(new XAttribute("id", @class));

                elem.Add(ca);
            }
            return elem;
        }
    }

    internal class MaxClassLevelList
    {

        private DbClassStats _classStats;

        public static MaxClassLevelList FromDb(Database db, DbAccount acc)
        {
            return new MaxClassLevelList()
            {
                _classStats = db.ReadClassStats(acc),
            };
        }

        public XElement ToXml(CoreService core)
        {
            var elem = new XElement("MaxClassLevelList");
            foreach (var type in core.PlayerClasses)
            {
                var ca = new XElement("MaxClassLevel");
                ca.Add(new XAttribute("maxLevel", _classStats[type].BestLevel));
                ca.Add(new XAttribute("classType", type));
                elem.Add(ca);
            }
            return elem;
        }
    }

    internal class CharList
    {
        public Character[] Characters { get; private set; }
        public int NextCharId { get; private set; }
        public int MaxNumChars { get; private set; }

        public Account Account { get; private set; }

        public IEnumerable<NewsItem> News { get; private set; }
        public IEnumerable<ServerItem> Servers { get; set; }

        public ClassAvailability ClassesAvailable { get; private set; }

        public MaxClassLevelList MaxLevelList { get; private set; }

        public double? Lat { get; set; }
        public double? Long { get; set; }

        private static IEnumerable<NewsItem> GetItems(CoreService core, Database db, DbAccount acc)
        {
            var news = new DbNews(db.Conn, 10).Entries
                .Select(x => NewsItem.FromDb(x)).ToArray();
            var chars = db.GetDeadCharacters(acc).Take(10).Select(x =>
            {
                var death = new DbDeath(acc, x);
                return new NewsItem()
                {
                    Icon = "fame",
                    Title = "Your " + core.Resources.GameData.ObjectTypeToId[death.ObjectType]
                            + " died at level " + death.Level,
                    TagLine = "You earned " + death.TotalFame + " glorious Fame",
                    Link = "fame:" + death.CharId,
                    Date = death.DeathTime
                };
            });
            return news.Concat(chars).OrderByDescending(x => x.Date);
        }

        public static CharList FromDb(CoreService core, DbAccount acc)
        {
            var db = core.Database;
            return new CharList()
            {
                Characters = db.GetAliveCharacters(acc)
                                .Select(x => Character.FromDb(db.LoadCharacter(acc, x), false))
                                .ToArray(),
                NextCharId = acc.NextCharId,
                MaxNumChars = acc.MaxCharSlot,
                Account = Account.FromDb(core, acc),
                News = GetItems(core, db, acc),
                ClassesAvailable = ClassAvailability.FromDb(core, db, acc),
                MaxLevelList = MaxClassLevelList.FromDb(db, acc)
            };
        }

        public XElement ToXml(CoreService core)
        {
            return
                new XElement("Chars",
                    new XAttribute("nextCharId", NextCharId),
                    new XAttribute("maxNumChars", MaxNumChars),
                    Characters.Select(x => x.ToXml()),
                    Account.ToXml(),
                    ClassesAvailable.ToXml(),
                    new XElement("News",
                        News.Select(x => x.ToXml())
                    ),
                    new XElement("Servers",
                        Servers.Select(x => x.ToXml())
                    ),
                    Lat == null ? null : new XElement("Lat", Lat),
                    Long == null ? null : new XElement("Long", Long),
                    Account.Skins.Length > 0 ? new XElement("OwnedSkins", Account.Skins.ToCommaSepString()) : null,
                    core.ItemCostsXml,
                    MaxLevelList.ToXml(core)
                );
        }
    }

    internal class Fame
    {
        public string Name { get; private set; }
        public Character Character { get; private set; }
        public FameStats Stats { get; private set; }
        public IEnumerable<Tuple<string, string, int>> Bonuses { get; private set; }
        public int TotalFame { get; private set; }

        public bool FirstBorn { get; private set; }
        public DateTime DeathTime { get; private set; }
        public string Killer { get; private set; }

        public static Fame FromDb(CoreService core, DbChar character)
        {
            DbDeath death = new DbDeath(character.Account, character.CharId);
            if (death.IsNull) return null;
            var stats = FameStats.Read(character.FameStats);
            return new Fame()
            {
                Name = character.Account.Name,
                Character = Character.FromDb(character, !death.IsNull),
                Stats = stats,
                Bonuses = stats.GetBonuses(core.Resources.GameData, character, death.FirstBorn),
                TotalFame = death.TotalFame,

                FirstBorn = death.FirstBorn,
                DeathTime = death.DeathTime,
                Killer = death.Killer
            };
        }

        private XElement GetCharElem()
        {
            var ret = Character.ToXml();
            ret.Add(new XElement("Account",
                new XElement("Name", Name)
            ));
            return ret;
        }

        public XElement ToXml()
        {
            return
                new XElement("Fame",
                    GetCharElem(),
                    new XElement("BaseFame", Character.CurrentFame),
                    new XElement("TotalFame", TotalFame),

                    new XElement("Shots", Stats.Shots),
                    new XElement("ShotsThatDamage", Stats.ShotsThatDamage),
                    new XElement("SpecialAbilityUses", Stats.SpecialAbilityUses),
                    new XElement("TilesUncovered", Stats.TilesUncovered),
                    new XElement("Teleports", Stats.Teleports),
                    new XElement("PotionsDrunk", Stats.PotionsDrunk),
                    new XElement("MonsterKills", Stats.MonsterKills),
                    new XElement("MonsterAssists", Stats.MonsterAssists),
                    new XElement("GodKills", Stats.GodKills),
                    new XElement("GodAssists", Stats.GodAssists),
                    new XElement("CubeKills", Stats.CubeKills),
                    new XElement("OryxKills", Stats.OryxKills),
                    new XElement("QuestsCompleted", Stats.QuestsCompleted),
                    new XElement("PirateCavesCompleted", Stats.PirateCavesCompleted),
                    new XElement("UndeadLairsCompleted", Stats.UndeadLairsCompleted),
                    new XElement("AbyssOfDemonsCompleted", Stats.AbyssOfDemonsCompleted),
                    new XElement("SnakePitsCompleted", Stats.SnakePitsCompleted),
                    new XElement("SpiderDensCompleted", Stats.SpiderDensCompleted),
                    new XElement("SpriteWorldsCompleted", Stats.SpriteWorldsCompleted),
                    new XElement("LevelUpAssists", Stats.LevelUpAssists),
                    new XElement("MinutesActive", Stats.MinutesActive),
                    new XElement("TombsCompleted", Stats.TombsCompleted),
                    new XElement("TrenchesCompleted", Stats.TrenchesCompleted),
                    new XElement("JunglesCompleted", Stats.JunglesCompleted),
                    new XElement("ManorsCompleted", Stats.ManorsCompleted),
                    Bonuses.Select(x =>
                        new XElement("Bonus",
                            new XAttribute("id", x.Item1),
                            new XAttribute("desc", x.Item2),
                            x.Item3
                        )
                    ),
                    new XElement("CreatedOn", DeathTime.ToUnixTimestamp()),
                    new XElement("KilledBy", Killer)
                );
        }
    }

    internal class FameListEntry
    {
        public int AccountId { get; private set; }
        public int CharId { get; private set; }
        public string Name { get; private set; }
        public ushort ObjectType { get; private set; }
        public int Tex1 { get; private set; }
        public int Tex2 { get; private set; }
        public int Skin { get; private set; }
        public ushort[] Equipment { get; private set; }
        public string[] ItemDatas { get; private set; }
        public int TotalFame { get; private set; }

        public static FameListEntry FromDb(DbChar character)
        {
            var death = new DbDeath(character.Account, character.CharId);
            return new FameListEntry()
            {
                AccountId = character.Account.AccountId,
                CharId = character.CharId,
                Name = character.Account.Name,
                ObjectType = character.ObjectType,
                Tex1 = character.Tex1,
                Tex2 = character.Tex2,
                Skin = character.Skin,
                Equipment = character.Items,
                ItemDatas = GetJson(character.Datas ?? new ItemData[28]),
                TotalFame = death.TotalFame
            };
        }

        private static string[] GetJson(ItemData[] datas)
        {
            var ret = new string[datas.Length];
            for (var i = 0; i < datas.Length; i++)
                ret[i] = datas[i]?.GetData() ?? "{}";
            return ret;
        }

        public XElement ToXml()
        {
            return
                new XElement("FameListElem",
                    new XAttribute("accountId", AccountId),
                    new XAttribute("charId", CharId),
                    new XElement("Name", Name),
                    new XElement("ObjectType", ObjectType),
                    new XElement("Tex1", Tex1),
                    new XElement("Tex2", Tex2),
                    new XElement("Texture", Skin),
                    new XElement("Equipment", Equipment.Select(x => (short)x).ToArray().ToCommaSepString()),
                    new XElement("ItemDatas", ItemDatas.ToArray().ToCommaDotSepString()),
                    new XElement("TotalFame", TotalFame)
                );
        }
    }

    internal class FameList
    {
        private string _timeSpan;
        private IEnumerable<FameListEntry> _entries;
        private int _lastUpdate;

        private static readonly ConcurrentDictionary<string, FameList> StoredLists =
            new ConcurrentDictionary<string, FameList>();

        public static FameList FromDb(CoreService core, string timeSpan)
        {
            var db = core.Database;

            timeSpan = timeSpan.ToLower();

            // check if we already got updated list
            var lastUpdate = db.LastLegendsUpdateTime();
            if (StoredLists.ContainsKey(timeSpan))
            {
                var fl = StoredLists[timeSpan];
                if (lastUpdate == fl._lastUpdate)
                {
                    return fl;
                }
            }

            // get & store list
            var entries = db.GetLegendsBoard(timeSpan);
            var fameList = new FameList()
            {
                _timeSpan = timeSpan,
                _entries = entries.Select(FameListEntry.FromDb),
                _lastUpdate = lastUpdate
            };
            StoredLists[timeSpan] = fameList;

            return fameList;
        }

        public XElement ToXml()
        {
            return
                new XElement("FameList",
                    new XAttribute("timespan", _timeSpan),
                    _entries.Select(x => x.ToXml())
                );
        }
    }
}
