using Newtonsoft.Json;
using NLog;
using Shared.database.account;
using Shared.database.character;
using Shared.database.guild;
using Shared.database.leaderboard;
using Shared.database.market;
using Shared.database.party;
using Shared.database.vault;
using Shared.resources;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Shared.database
{
    public struct AccountLock : IDisposable
    {
        public bool HasLock { get; private set; }
        private readonly DbAccount _acc;
        private Database _db;

        public AccountLock(Database db, DbAccount acc)
        {
            _db = db;
            _acc = acc;
            HasLock = db.AcquireLock(acc);
        }

        public readonly void Dispose()
        {
            if (HasLock)
                _db.ReleaseLock(_acc);
        }
    }

    public class Database : IDisposable
    {
        public const string NAME_LOCK = "nameLock";
        public const string REG_LOCK = "regLock";

        public static readonly string[] GuestNames =
        {
            "Darq", "Deyst", "Drac", "Drol",
            "Eango", "Eashy", "Eati", "Eendi", "Ehoni",
            "Gharr",
            "Iatho", "Iawa", "Idrae", "Iri", "Issz", "Itani",
            "Laen", "Lauk", "Lorz",
            "Oalei", "Odaru", "Oeti", "Orothi", "Oshyu",
            "Queq",
            "Radph", "Rayr", "Ril", "Rilr", "Risrr",
            "Saylt", "Scheev", "Sek", "Serl", "Seus",
            "Tal", "Tiar",
            "Uoro", "Urake", "Utanu",
            "Vorck", "Vorv",
            "Yangu", "Yimi",
            "Zhiar"
        };

        public static readonly List<string> BlackListedNames = new List<string>
        {
            "NPC"
        };

        public readonly int DatabaseIndex;
        public readonly ISubscriber Subscriber;

        protected const int _lockTTL = 45;

        protected static readonly Logger Log = LogManager.GetCurrentClassLogger();

        protected ServerConfig _config;
        protected IDatabase _db;
        protected ConnectionMultiplexer _multiplexer;
        protected Resources _resources;
        protected IServer _server;

        private static readonly Dictionary<CurrencyType, string[]> CurrencyKey = new Dictionary<CurrencyType, string[]>
        {
            [CurrencyType.Gold] = new[] { "totalCredits", "credits" },
            [CurrencyType.Fame] = new[] { "totalFame", "fame" },
            [CurrencyType.GuildFame] = new[] { "totalFame", "fame" }
        };

        public Database(Resources resources, ServerConfig config)
        {
            _resources = resources;
            _config = config;

            DatabaseIndex = config.dbInfo.index;

            var conString = config.dbInfo.host + ":" + config.dbInfo.port + ",syncTimeout=120000";
            if (!string.IsNullOrWhiteSpace(config.dbInfo.auth))
                conString += ",password=" + config.dbInfo.auth;

			Console.WriteLine($"Connecting to: {conString}");

            _multiplexer = ConnectionMultiplexer.Connect(conString);
            _server = _multiplexer.GetServer(_multiplexer.GetEndPoints(true)[0]);
            _db = _multiplexer.GetDatabase(DatabaseIndex);
            Subscriber = _multiplexer.GetSubscriber();

            Log.Info("Database loaded");
        }

        public IDatabase Conn => _db;

        public int TotalAccounts => (int)_db.StringGet("nextAccId") - 1;

        public bool AccountLockExists(int accId) => _db.KeyExists($"lock:{accId}");

        // basic account locking functions
        public bool AcquireLock(DbAccount acc)
        {
            var tran = _db.CreateTransaction();
            var lockToken = Guid.NewGuid().ToString();
            var aKey = $"lock:{acc.AccountId}";
            tran.AddCondition(Condition.KeyNotExists(aKey));
            tran.StringSetAsync(aKey, lockToken, TimeSpan.FromSeconds(_lockTTL));
            var committed = tran.Execute();

            acc.LockToken = committed ? lockToken : null;
            return committed;
        }

        public string AcquireLock(string key)
        {
            var lockToken = Guid.NewGuid().ToString();
            var tran = _db.CreateTransaction();
            tran.AddCondition(Condition.KeyNotExists(key));
            tran.StringSetAsync(key, lockToken, TimeSpan.FromSeconds(_lockTTL));

            return tran.Execute() ? lockToken : null;
        }

        public bool AddGift(DbAccount acc, ushort item, ITransaction tran = null) => AddGifts(acc, new ushort[] { item }, tran);

        public bool AddGifts(DbAccount acc, IEnumerable<ushort> items, ITransaction transaction = null)
        {
            acc.Reload("gifts"); // not ideal but will work for now

            var gList = acc.Gifts.ToList();
            gList.AddRange(items);

            var giftBytes = GetGiftBytes(gList.ToArray());
            return SetGifts(acc, giftBytes, transaction);
        }

        public DbAddGuildMemberStatus AddGuildMember(DbGuild guild, DbAccount acc, bool founder = false)
        {
            if (acc == null)
                return DbAddGuildMemberStatus.Error;

            if (acc.NameChosen == false)
                return DbAddGuildMemberStatus.NameNotChosen;

            if (acc.GuildId == guild.Id)
                return DbAddGuildMemberStatus.AlreadyInGuild;

            if (acc.GuildId > 0)
                return DbAddGuildMemberStatus.InAnotherGuild;

            using (TimedLock.Lock(guild.MemberLock))
            {
                var guildSize = 128;

                // probably not best to lock this up but should be ok
                if (guild.Members.Length >= guildSize)
                    return DbAddGuildMemberStatus.GuildFull;

                var members = guild.Members.ToList();

                if (members.Contains(acc.AccountId))
                    return DbAddGuildMemberStatus.IsAMember; // this should not happen...

                members.Add(acc.AccountId);
                guild.Members = members.ToArray();
                guild.FlushAsync();
            }

            // set account guild info
            acc.GuildId = guild.Id;
            acc.GuildRank = founder ? 40 : 0;
            acc.FlushAsync();
            return DbAddGuildMemberStatus.OK;
        }

        public Task AddMarketEntrySafety(DbAccount account, List<(ushort, string)> itemTypes, int sellerId, string sellerName, int price, int timeLeft, CurrencyType currency, Action<string> log = null)
        {
            var trans = _db.CreateTransaction();
            var ids = itemTypes.Select(itemType =>
            {
                var id = _db.StringIncrement("nextMarketId");
                if (log != null)
                    log.Invoke($"Added new offer with ID {id} and price {price} to the marketplace.");

                var data = new DbMarketData(_db, (int)id)
                {
                    ItemType = itemType.Item1,
                    SellerName = sellerName,
                    SellerId = sellerId,
                    Currency = currency,
                    Price = price,
                    StartTime = DateTime.UtcNow.ToUnixTimestamp(),
                    TimeLeft = timeLeft,
                    ItemData = itemType.Item2
                };
                data.Flush();
                return (int)id;
            }).ToList();

            var offers = account.MarketOffers.ToList();
            offers.AddRange(ids);

            account.MarketOffers = offers.ToArray();

            var task = account.FlushAsync(trans).ContinueWith(t =>
            {
                if (!t.IsCanceled && account != null)
                {
                    if (log != null)
                        log.Invoke(
                            $"[Amount: {account.MarketOffers.Length + ids.Count}] Successfully " +
                            $"added total of {ids.Count} entr{(ids.Count > 1 ? "ies" : "y")} " +
                            $"into the marketplace to the account ID {account.AccountId}."
                        );

                    account.Reload("marketOffers");
                }
            });

            trans.Execute();
            return task;
        }

        public bool AddMemberToParty(IDatabase db, string accname, int AccId, int partyId)
        {
            var party = DbPartySystem.Get(db, partyId);
            var data = new DbPartyMemberData
            {
                accid = AccId,
                name = accname
            };

            if (party != null)
            {
                party.PartyMembers.Add(data);
                FlushParty(party.PartyId, party);
                return true;
            }
            else
                return false;
        }

        public void AddToTreasury(int amount, ITransaction transaction = null)
        {
            if (transaction != null)
            {
                transaction.StringIncrementAsync("collectedTaxes", amount);
                return;
            }

            _db.StringIncrement("collectedTaxes", amount, CommandFlags.FireAndForget);
        }

        public void Ban(int accId, string reason = "", int liftTime = -1)
        {
            var acc = new DbAccount(_db, accId)
            {
                Banned = true,
                Notes = reason,
                BanLiftTime = liftTime
            };
            acc.FlushAsync();
        }

        public void BanIp(string ip, string notes = "")
        {
            var abi = new DbIpInfo(_db, ip)
            {
                Banned = true,
                Notes = notes
            };
            abi.Flush();
        }

        public bool ChangeGuildLevel(DbGuild guild, int level)
        {
            // supported guild levels
            if (level != 1 && level != 2 && level != 3)
                return false;

            guild.Level = level;
            guild.FlushAsync();

            return true;
        }

        public bool ChangeGuildRank(DbAccount acc, int rank)
        {
            if (acc.GuildId <= 0 || !(new short[] { 0, 10, 20, 30, 40 }).Any(r => r == rank))
                return false;

            acc.GuildRank = rank;
            acc.FlushAsync();

            return true;
        }

        public void ChangePassword(string uuid, string password)
        {
            var login = new DbLoginInfo(_db, uuid);
            login.HashedPassword = GetHashedPassword(password);
            login.Flush();
        }

        public void CleanLegends() => DbLegend.Clean(_db);

        public void CreateAndSetHashToAllGuilds()
        {
            var lastGuildId = (int)_db.StringGet("nextGuildId");

            for (var i = 1; i <= lastGuildId; i++)
                _db.HashSet($"guild.{i}", "guildLootBoost", 0);
        }

        public DbCreateStatus CreateCharacter(DbAccount acc, ushort type, ushort skinType, out DbChar character)
        {
            if (_db.SetLength("alive." + acc.AccountId) >= acc.MaxCharSlot)
            {
                character = null;
                return DbCreateStatus.ReachCharLimit;
            }

            // check skin requirements
            if (skinType != 0)
            {
                var skinDesc = _resources.GameData.Skins[skinType];

                if (!acc.Skins.Contains(skinType) ||
                    skinDesc.PlayerClassType != type)
                {
                    character = null;
                    return DbCreateStatus.SkinUnavailable;
                }
            }

            var objDesc = _resources.GameData.ObjectDescs[type];
            var playerDesc = _resources.GameData.Classes[type];
            var classStats = ReadClassStats(acc);
            var unlockClass = playerDesc.Unlock?.Type;

            // check to see if account has unlocked via gold
            if (classStats.AllKeys.All(x => (ushort)(int)x != type))
            {
                // check to see if account meets unlock requirements
                if (unlockClass != null && classStats[(ushort)unlockClass].BestLevel < playerDesc.Unlock.Level)
                {
                    character = null;
                    return DbCreateStatus.Locked;
                }
            }

            var newId = (int)_db.HashIncrement(acc.Key, "nextCharId");
            var newCharacters = _resources.Settings.NewCharacters;

            character = new DbChar(acc, newId)
            {
                ObjectType = type,
                Level = newCharacters.Level,
                Experience = 0,
                Fame = 0,
                Items = InitInventory(playerDesc.Equipment),
                Stats = new int[]
                {
                    playerDesc.Stats[0].StartingValue,
                    playerDesc.Stats[1].StartingValue,
                    playerDesc.Stats[2].StartingValue,
                    playerDesc.Stats[3].StartingValue,
                    playerDesc.Stats[4].StartingValue,
                    playerDesc.Stats[5].StartingValue,
                    playerDesc.Stats[6].StartingValue,
                    playerDesc.Stats[7].StartingValue,
                },
                Health = playerDesc.Stats[0].StartingValue,
                MP = playerDesc.Stats[1].StartingValue,
                Tex1 = 0,
                Tex2 = 0,
                Skin = skinType,
                PetId = 0,
                FameStats = new byte[0],
                CreateTime = DateTime.Now,
                LastSeen = DateTime.Now
            };

            character.FlushAsync();

            _db.SetAdd("alive." + acc.AccountId, BitConverter.GetBytes(newId));

            return DbCreateStatus.OK;
        }

        public int? CreateChest(DbAccount acc, ITransaction tran = null)
        {
            if (tran == null)
                return (int)_db.HashIncrement(acc.Key, "vaultCount");

            tran.HashIncrementAsync(acc.Key, "vaultCount");

            return null;
        }

        public int CreateGiftChest(DbAccount acc) => (int)_db.HashIncrement(acc.Key, "giftCount");

        public DbAccount CreateGuestAccount(string uuid)
        {
            var newAccounts = _resources.Settings.NewAccounts;
            var acnt = new DbAccount(_db, 0)
            {
                UUID = uuid,
                Name = GuestNames[(uint)uuid.GetHashCode() % GuestNames.Length],
                Rank = 0,
                Admin = false,
                NameChosen = false,
                FirstDeath = true,
                GuildId = 0,
                GuildRank = 0,
                VaultCount = newAccounts.VaultCount,
                MaxCharSlot = newAccounts.MaxCharSlot,
                RegTime = DateTime.Now,
                Guest = true,
                StoredPotions = new int[8],
                Fame = newAccounts.Fame,
                TotalFame = newAccounts.Fame,
                Credits = newAccounts.Credits,
                TotalCredits = newAccounts.Credits,
                PassResetToken = ""
            };

            // make sure guest have all classes if they are supposed to
            var stats = new DbClassStats(acnt);

            if (newAccounts.ClassesUnlocked)
            {
                foreach (var @class in _resources.GameData.Classes.Keys)
                    stats.Unlock(@class);
                stats.FlushAsync();
            }
            else
                _db.KeyDelete("classStats.0");

            // make sure guests have all skins if they are supposed to
            if (newAccounts.SkinsUnlocked)
                acnt.Skins = (from skin in _resources.GameData.Skins.Values select skin.Type).ToArray();

            return acnt;
        }

        public DbGuildCreateStatus CreateGuild(string guildName, out DbGuild guild)
        {
            guild = null;

            if (string.IsNullOrWhiteSpace(guildName))
                return DbGuildCreateStatus.InvalidName;

            // remove excessive whitespace
            var rgx = new Regex(@"\s+");

            guildName = rgx.Replace(guildName, " ");
            guildName = guildName.Trim();

            // check if valid
            rgx = new Regex(@"^[A-Za-z\s]{1,20}$");

            if (!rgx.IsMatch(guildName))
                return DbGuildCreateStatus.InvalidName;

            // add guild to guild list
            var newGuildId = (int)_db.StringIncrement("nextGuildId");

            if (!_db.HashSet("guilds", guildName.ToUpperInvariant(), newGuildId, When.NotExists))
                return DbGuildCreateStatus.UsedName;

            // create guild data structure
            guild = new DbGuild(_db, newGuildId)
            {
                Name = guildName,
                Level = 0,
                Fame = 0,
                TotalFame = 0,
                GuildLootBoost = 0,
                GuildPoints = 0,
                GuildCurrency = 0
            };

            // save
            guild.FlushAsync();

            return DbGuildCreateStatus.OK;
        }

        public void Death(XmlData dat, DbAccount acc, DbChar character, FameStats stats, string killer)
        {
            character.Dead = true;

            var classStats = new DbClassStats(acc);
            var finalFame = stats.CalculateTotal(dat, character, classStats, out bool firstBorn); // calculate total fame given bonuses

            // save character
            character.FinalFame = finalFame;
            SaveCharacter(acc, character, classStats, acc.LockToken != null);

            var death = new DbDeath(acc, character.CharId)
            {
                ObjectType = character.ObjectType,
                Level = character.Level,
                TotalFame = finalFame,
                Killer = killer,
                FirstBorn = firstBorn,
                DeathTime = DateTime.UtcNow
            };
            death.FlushAsync();

            var idBuff = BitConverter.GetBytes(character.CharId);

            _db.SetRemoveAsync("alive." + acc.AccountId, idBuff, CommandFlags.FireAndForget);
            _db.ListLeftPushAsync("dead." + acc.AccountId, idBuff, When.Always, CommandFlags.FireAndForget);

            UpdateFame(acc, finalFame);

            var guild = new DbGuild(acc);

            if (!guild.IsNull && !acc.Admin)
            {
                UpdateGuildFame(guild, finalFame);
                UpdatePlayerGuildFame(acc, finalFame);
            }

            if (!acc.Admin)
                DbLegend.Insert(_db, acc.AccountId, character.CharId, finalFame);
        }

        public void DeleteCharacter(DbAccount acc, int charId)
        {
            _db.KeyDeleteAsync("char." + acc.AccountId + "." + charId);

            var buff = BitConverter.GetBytes(charId);

            _db.SetRemoveAsync("alive." + acc.AccountId, buff);
            _db.ListRemoveAsync("dead." + acc.AccountId, buff);
        }

        public void Dispose()
        {
            _multiplexer.Dispose();

            _config = null;
            _db = null;
            _multiplexer = null;
            _resources = null;
            _server = null;

            GC.SuppressFinalize(this);
        }

        public Task FlushParty(int partyId, object party)
        {
            var trans = _db.CreateTransaction();
            var task = trans.HashSetAsync("party", partyId, JsonConvert.SerializeObject(party));

            trans.Execute();

            return task;
        }

        public DbAccount GetAccount(int id, string field = null)
        {
            var ret = new DbAccount(_db, id, field);

            if (ret.IsNull)
                return null;

            return ret;
        }

        public DbAccount GetAccount(string uuid)
        {
            var info = new DbLoginInfo(_db, uuid);
            if (info.IsNull)
                return null;

            var ret = new DbAccount(_db, info.AccountId);
            if (ret.IsNull)
                return null;

            return ret;
        }

        public IEnumerable<int> GetAliveCharacters(DbAccount acc)
        {
            foreach (var i in _db.SetMembers("alive." + acc.AccountId))
                yield return BitConverter.ToInt32(i, 0);
        }

        /*public IDictionary<int, (int amount, IList<int> charIds)> getAllCharactersByItem(ushort item)
        {
            var entries = new Dictionary<int, (int amount, IList<int> charIds)>();
            var numAccounts = int.Parse(_db.StringGet("nextAccId"));

            for (var i = 1; i < numAccounts; i++)
            {
                var account = new DbAccount(_db, i);
                var aliveChars = GetAliveCharacters(account).ToArray();

                if (aliveChars.Length == 0)
                    continue;

                for (var j = 0; j < aliveChars.Length; j++)
                {
                    var charInv = new DbCharInv(account, aliveChars[j]);
                    var total = charInv.Items.Count(charItem => charItem == item);

                    if (total == 0)
                        continue;

                    if (entries.ContainsKey(account.AccountId))
                    {
                        var amount = entries[account.AccountId].amount + total;
                        var charIds = entries[account.AccountId].charIds;
                        charIds.Add(aliveChars[j]);

                        entries[account.AccountId] = (amount, charIds);
                    }
                    else
                        entries.Add(account.AccountId, (total, new List<int>() { aliveChars[j] }));
                }
            }

            return entries;
        }*/

        public IEnumerable<int> GetDeadCharacters(DbAccount acc)
        {
            foreach (var i in _db.ListRange("dead." + acc.AccountId, 0, int.MaxValue))
                yield return BitConverter.ToInt32(i, 0);
        }

        public DbGuild GetGuild(int id)
        {
            var ret = new DbGuild(_db, id);

            if (ret.IsNull)
                return null;

            return ret;
        }

        public DbChar[] GetLegendsBoard(string timeSpan) => DbLegend.Get(_db, timeSpan).Select(e => LoadCharacter(e.AccId, e.ChrId)).Where(e => e != null).ToArray();

        public TimeSpan? GetLockTime(DbAccount acc) => _db.KeyTimeToLive($"lock:{acc.AccountId}");

        public void Guest(DbAccount acc, bool isGuest)
        {
            acc.Guest = isGuest;
            acc.FlushAsync();
        }

        public bool HasUUID(string uuid) => _db.HashExists("logins", uuid.ToUpperInvariant());

        public void IgnoreAccount(DbAccount target, DbAccount acc, bool add)
        {
            var ignoreList = target.IgnoreList.ToList();

            if (ignoreList.Contains(acc.AccountId) && add)
                return;

            if (add)
                ignoreList.Add(acc.AccountId);
            else
                ignoreList.Remove(acc.AccountId);

            target.IgnoreList = ignoreList.ToArray();
            target.FlushAsync();
        }

        public bool IsAlive(DbChar character) => _db.SetContains("alive." + character.Account.AccountId, BitConverter.GetBytes(character.CharId));

        public bool IsIpBanned(string ip)
        {
            var abi = new DbIpInfo(_db, ip);
            return abi.Banned;
        }

        public Task<bool> IsLegend(int accId) => _db.HashExistsAsync("legend", accId);

        public Task<bool> IsMuted(string ip) => _db.KeyExistsAsync($"mutes:{ip}");

        public int LastLegendsUpdateTime()
        {
            var time = _db.StringGet("legends:updateTime");

            if (time.IsNullOrEmpty)
                return -1;

            return int.Parse(time);
        }

        public bool LeaveFromParty(IDatabase db, string name, int partyId, Database DB)
        {
            var party = DbPartySystem.Get(db, partyId);

            if (party != null)
            {
                if (party.PartyLeader.Item1 == name)
                    return false;

                foreach (var member in party.PartyMembers)
                {
                    if (member.name == name)
                    {
                        party.PartyMembers.Remove(member);
                        DB.FlushParty(party.PartyId, party);
                        var acc = DB.GetAccount(member.accid);
                        acc.PartyId = 0;
                        acc.FlushAsync();
                        acc.Reload("partyId");
                        return true;
                    }
                }
                return false;
            }
            else
                return false;
        }

        public DbChar LoadCharacter(DbAccount acc, int charId)
        {
            var ret = new DbChar(acc, charId);

            if (ret.IsNull)
                return null;
            else return ret;
        }

        public DbChar LoadCharacter(int accId, int charId)
        {
            var acc = new DbAccount(_db, accId);

            if (acc.IsNull)
                return null;

            var ret = new DbChar(acc, charId);

            if (ret.IsNull)
                return null;
            else return ret;
        }

        public AccountLock LockAccount(DbAccount acc) => new AccountLock(this, acc);

        public void LockAccount(DbAccount target, DbAccount acc, bool add)
        {
            var lockList = target.LockList.ToList();

            if (lockList.Contains(acc.AccountId) && add)
                return;

            if (add)
                lockList.Add(acc.AccountId);
            else
                lockList.Remove(acc.AccountId);

            target.LockList = lockList.ToArray();
            target.FlushAsync();
        }

        public void LogAccountByIp(string ip, int accountId)
        {
            var abi = new DbIpInfo(_db, ip);
            if (!abi.IsNull && !abi.Accounts.Contains(accountId))
                abi.Accounts.Add(accountId);
            else
                abi.Accounts = new List<int>() { accountId };
            abi.Accounts = abi.Accounts.Distinct().ToList();
            abi.Flush();
        }

        public void Mute(string ip, TimeSpan? timeSpan = null) => _db.StringSetAsync($"mutes:{ip}", "", timeSpan);

        public void PurchaseSkin(DbAccount acc, ushort skinType, int cost)
        {
            if (cost > 0)
                acc.TotalCredits = (int)_db.HashIncrement(acc.Key, "totalCredits", cost);

            acc.Credits = (int)_db.HashIncrement(acc.Key, "credits", -cost);

            // not thread safe
            var ownedSkins = acc.Skins.ToList();
            ownedSkins.Add(skinType);

            acc.Skins = ownedSkins.ToArray();
            acc.FlushAsync();
        }

        public DbClassStats ReadClassStats(DbAccount acc) => new DbClassStats(acc);

        public DbVault ReadVault(DbAccount acc) => new DbVault(acc);

        public DbRegisterStatus Register(string uuid, string password, bool isGuest, out DbAccount acc)
        {
            var newAccounts = _resources.Settings.NewAccounts;

            acc = null;

            if (!_db.HashSet("logins", uuid.ToUpperInvariant(), "{}", When.NotExists))
                return DbRegisterStatus.UsedName;

            var newAccId = (int)_db.StringIncrement("nextAccId");

            acc = new DbAccount(_db, newAccId)
            {
                UUID = uuid,
                Name = GuestNames[(uint)uuid.GetHashCode() % GuestNames.Length],
                Rank = 0,
                Admin = false,
                NameChosen = false,
                FirstDeath = true,
                GuildId = 0,
                GuildRank = 0,
                VaultCount = newAccounts.VaultCount,
                MaxCharSlot = newAccounts.MaxCharSlot,
                RegTime = DateTime.Now,
                Guest = isGuest,
                Fame = newAccounts.Fame,
                StoredPotions = new int[8],
                TotalFame = newAccounts.Fame,
                Credits = newAccounts.Credits,
                TotalCredits = newAccounts.Credits,
                PassResetToken = "",
                LastSeen = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                FuelContributed = 0
            };

            if (newAccounts.SkinsUnlocked)
                acc.Skins = (from skin in _resources.GameData.Skins.Values select skin.Type).ToArray();

            acc.FlushAsync();

            var login = new DbLoginInfo(_db, uuid);
            login.AccountId = acc.AccountId;
            login.HashedPassword = GetHashedPassword(password);
            login.Flush();

            var stats = new DbClassStats(acc);

            if (newAccounts.ClassesUnlocked)
                foreach (var @class in _resources.GameData.Classes.Keys)
                    stats.Unlock(@class);

            stats.FlushAsync();

            return DbRegisterStatus.OK;
        }

        public void ReleaseLock(DbAccount acc) => ReleaseLock(acc.AccountId, acc.LockToken);

        public void ReleaseLock(int accountId, string lockToken)
        {
            var tran = _db.CreateTransaction();
            var aKey = $"lock:{accountId}";

            tran.AddCondition(Condition.StringEqual(aKey, lockToken));
            tran.KeyDeleteAsync(aKey);
            tran.ExecuteAsync(CommandFlags.FireAndForget);
        }

        public void ReleaseLock(string key, string token)
        {
            var tran = _db.CreateTransaction();
            tran.AddCondition(Condition.StringEqual(key, token));
            tran.KeyDeleteAsync(key);
            tran.Execute();
        }

        public void ReloadAccount(DbAccount acc)
        {
            acc.FlushAsync();
            acc.Reload();
        }

        public bool RemoveFromGuild(DbAccount acc)
        {
            var guild = GetGuild(acc.GuildId);

            if (guild == null)
                return false;

            List<int> members;
            using (TimedLock.Lock(guild.MemberLock))
            {
                members = guild.Members.ToList();
                if (members.Contains(acc.AccountId))
                {
                    members.Remove(acc.AccountId);
                    guild.Members = members.ToArray();
                    guild.FlushAsync();
                }
            }

            // remove guild name from guilds if there are no members
            if (members.Count <= 0)
                _db.HashDeleteAsync("guilds", guild.Name.ToUpperInvariant(), CommandFlags.FireAndForget);

            acc.GuildId = 0;
            acc.GuildRank = 0;
            acc.GuildFame = 0;
            acc.FlushAsync();

            return true;
        }

        public bool RemoveGift(DbAccount acc, ushort item, ITransaction transaction = null)
        {
            acc.Reload("gifts");

            var gList = acc.Gifts.ToList();
            gList.Remove(item);

            var giftBytes = GetGiftBytes(gList.ToArray());

            return SetGifts(acc, giftBytes, transaction);
        }

        public Task RemoveMarketEntrySafety(DbAccount account, int id, Action<string> log = null)
        {
            var trans = _db.CreateTransaction();
            trans.HashDeleteAsync("market", id);

            var offers = account.MarketOffers.ToList();
            offers.Remove(id);

            account.MarketOffers = offers.ToArray();

            var task = account.FlushAsync(trans).ContinueWith(t =>
            {
                if (!t.IsCanceled && account != null)
                {
                    if (log != null)
                        log.Invoke($"[Amount: {account.MarketOffers.Length}] Successfully removed 1 entry (ID: {id}) of the marketplace from the account ID {account.AccountId}.");

                    account.Reload("marketOffers");
                }
            });

            trans.Execute();

            return task;
        }

        public bool RemoveParty(DbAccount leader, HashSet<DbAccount> members, int partyId)
        {
            var trans = _db.CreateTransaction();

            leader.PartyId = 0;
            leader.FlushAsync();
            leader.Reload("partyId");

            foreach (var member in members)
            {
                member.PartyId = 0;
                member.FlushAsync();
                member.Reload("partyId");
            };

            trans.HashDeleteAsync("party", partyId);
            trans.Execute();

            return true;
        }

        public bool RenameIGN(DbAccount acc, string newName, string lockToken)
        {
            var trans = _db.CreateTransaction();
            trans.AddCondition(Condition.StringEqual(NAME_LOCK, lockToken));
            trans.HashDeleteAsync("names", acc.Name.ToUpperInvariant());
            trans.HashSetAsync("names", newName.ToUpperInvariant(), acc.AccountId.ToString());

            if (!trans.Execute())
                return false;

            acc.Name = newName;
            acc.NameChosen = true;
            acc.FlushAsync();

            return true;
        }

        public bool RenameUUID(DbAccount acc, string newUuid, string lockToken)
        {
            var p = _db.HashGet("logins", acc.UUID.ToUpperInvariant());
            var trans = _db.CreateTransaction();
            trans.AddCondition(Condition.StringEqual(REG_LOCK, lockToken));
            trans.AddCondition(Condition.HashNotExists("logins", newUuid.ToUpperInvariant()));
            trans.HashDeleteAsync("logins", acc.UUID.ToUpperInvariant());
            trans.HashSetAsync("logins", newUuid.ToUpperInvariant(), p);

            if (!trans.Execute())
                return false;

            acc.UUID = newUuid;
            acc.FlushAsync();

            return true;
        }

        public bool RenewLock(DbAccount acc)
        {
            var tran = _db.CreateTransaction();
            var aKey = $"lock:{acc.AccountId}";
            tran.AddCondition(Condition.StringEqual(aKey, acc.LockToken));
            tran.KeyExpireAsync(aKey, TimeSpan.FromSeconds(_lockTTL));
            return tran.Execute();
        }

        public int ResolveId(string ign)
        {
            var val = (string)_db.HashGet("names", ign.ToUpperInvariant());
            if (val == null)
                return 0;
            return int.Parse(val);
        }

        public string ResolveIgn(int? accId) => _db.HashGet("account." + accId, "name");

        public bool SaveCharacter(DbAccount acc, DbChar character, DbClassStats stats, bool lockAcc)
        {
            var trans = _db.CreateTransaction();
            if (lockAcc)
                trans.AddCondition(Condition.StringEqual($"lock:{acc.AccountId}", acc.LockToken));
            character.FlushAsync(trans);
            stats.Update(character);
            stats.FlushAsync(trans);
            return trans.Execute();
        }

        public bool SetGuildBoard(DbGuild guild, string text)
        {
            if (guild.IsNull)
                return false;

            guild.Board = text;
            guild.FlushAsync();

            return true;
        }

        public bool SwapGift(DbAccount acc, ushort oldItem, ushort newItem, ITransaction transaction = null)
        {
            acc.Reload("gifts");

            var gList = acc.Gifts.ToList();
            gList.Remove(oldItem);
            gList.Add(newItem);

            var giftBytes = GetGiftBytes(gList.ToArray());

            return SetGifts(acc, giftBytes, transaction);
        }

        public bool UnBan(int accId)
        {
            var acc = new DbAccount(_db, accId);

            if (acc.Banned)
            {
                acc.Banned = false;
                acc.FlushAsync();
                return true;
            }

            return false;
        }

        public bool UnBanIp(string ip)
        {
            var abi = new DbIpInfo(_db, ip);

            if (!abi.IsNull && abi.Banned)
            {
                abi.Banned = false;
                abi.Flush();
                return true;
            }

            return false;
        }

        public void UnlockClass(DbAccount acc, ushort type)
        {
            var cs = ReadClassStats(acc);
            cs.Unlock(type);
            cs.FlushAsync();
        }

        public bool UnnameIGN(DbAccount acc, string lockToken)
        {
            var trans = _db.CreateTransaction();
            trans.AddCondition(Condition.StringEqual(NAME_LOCK, lockToken));
            trans.HashDeleteAsync("names", acc.Name.ToUpperInvariant());

            if (!trans.Execute())
                return false;

            acc.Name = GuestNames[acc.AccountId % GuestNames.Length];
            acc.NameChosen = false;
            acc.FlushAsync();

            return true;
        }

        public void UpdateAllCurrency()
        {
            var lastGuildId = (int)_db.StringGet("nextGuildId");

            for (var i = 1; i <= lastGuildId; i++)
                _db.HashSet($"guild.{i}", "guildCurrency", 0);
        }

        public void UpdateAllGuildPoints()
        {
            var lastGuildId = (int)_db.StringGet("nextGuildId");

            for (var i = 1; i <= lastGuildId; i++)
                _db.HashSet($"guild.{i}", "guildPoints", 0);
        }

        public void UpdateAllPlayer()
        {
            var lastaccid = (int)_db.StringGet("nextAccId");

            for (var i = 1; i <= lastaccid; i++)
                _db.HashSet($"account.{i}", "enemyKilled", 0);
        }

        public Task UpdateCredit(DbAccount acc, int amount, ITransaction transaction = null)
        {
            var trans = transaction ?? _db.CreateTransaction();

            if (amount > 0)
                trans.HashIncrementAsync(acc.Key, "totalCredits", amount).ContinueWith(t =>
                {
                    if (!t.IsCanceled)
                        acc.TotalCredits = (int)t.Result;
                });

            var task = trans.HashIncrementAsync(acc.Key, "credits", amount).ContinueWith(t =>
            {
                if (!t.IsCanceled)
                    acc.Credits = (int)t.Result;
            });

            if (transaction == null)
                trans.Execute();

            return task;
        }

        public void UpdateCurrency(int accountId, int amount, CurrencyType currency, ITransaction transaction = null)
        {
            var trans = transaction ?? _db.CreateTransaction();
            var key = $"account.{accountId}";
            var fields = CurrencyKey[currency];

            if (currency == CurrencyType.GuildFame)
            {
                var guildId = (int)_db.HashGet(key, "guildId");

                if (guildId <= 0)
                    return;

                key = $"guild.{guildId}";
            }

            if (amount > 0)
                trans.HashIncrementAsync(key, fields[0], amount);

            trans.HashIncrementAsync(key, fields[1], amount);

            if (transaction == null)
                trans.Execute();
        }

        public Task UpdateCurrency(DbAccount acc, int amount, CurrencyType currency, ITransaction transaction = null)
        {
            var trans = transaction ?? _db.CreateTransaction();
            var key = acc.Key;
            var fields = CurrencyKey[currency];

            acc.Reload("fame");
            acc.Reload("totalFame");

            if (currency == CurrencyType.GuildFame)
            {
                var guildId = (int)_db.HashGet(key, "guildId");

                if (guildId <= 0)
                    return Task.FromResult(false);

                key = $"guild.{guildId}";
            }

            // validate acc value before setting - TODO check guild fame
            var currentAmount = GetCurrencyAmount(acc, currency);

            if (currentAmount != null)
                trans.AddCondition(Condition.HashEqual(acc.Key, fields[1], currentAmount.Value));

            if (amount > 0)
                trans.HashIncrementAsync(key, fields[0], amount).ContinueWith(t =>
                {
                    if (!t.IsCanceled)
                        UpdateAccountCurrency(acc, currency, (int)t.Result, true);
                });

            var task = trans.HashIncrementAsync(key, fields[1], amount).ContinueWith(t =>
            {
                if (!t.IsCanceled)
                    UpdateAccountCurrency(acc, currency, (int)t.Result);
            });

            if (transaction == null)
                trans.Execute();

            return task;
        }

        public Task UpdateFame(DbAccount acc, int amount, ITransaction transaction = null)
        {
            var trans = transaction ?? _db.CreateTransaction();

            acc.Reload("fame");
            acc.Reload("totalFame");

            if (amount > 0)
                trans.HashIncrementAsync(acc.Key, "totalFame", amount).ContinueWith(t =>
                {
                    if (!t.IsCanceled)
                        acc.TotalFame = (int)t.Result;
                });

            var task = trans.HashIncrementAsync(acc.Key, "fame", amount).ContinueWith(t =>
            {
                if (!t.IsCanceled)
                    acc.Fame = (int)t.Result;
            });

            if (transaction == null)
                trans.Execute();

            return task;
        }

        public Task UpdateGuildFame(DbGuild guild, int amount, ITransaction transaction = null)
        {
            var guildKey = $"guild.{guild.Id}";

            var trans = transaction ?? _db.CreateTransaction();

            if (amount > 0)
                trans.HashIncrementAsync(guildKey, "totalFame", amount).ContinueWith(t =>
                {
                    if (!t.IsCanceled)
                        guild.TotalFame = (int)t.Result;
                });

            var task = trans.HashIncrementAsync(guildKey, "fame", amount).ContinueWith(t =>
            {
                if (!t.IsCanceled)
                    guild.Fame = (int)t.Result;
            });

            if (transaction == null)
                trans.Execute();

            return task;
        }

        public DbLoginStatus Verify(string uuid, string password, out DbAccount acc)
        {
            acc = null;
            if (string.IsNullOrWhiteSpace(uuid))
            {
                Log.Warn($"Invalid UUID: {uuid}");
                return DbLoginStatus.InvalidCredentials;
            }

            //check login
            var info = new DbLoginInfo(_db, uuid);

            if (info.IsNull)
                return DbLoginStatus.AccountNotExists;

            var pwd = GetHashedPassword(password);
            if (pwd != info.HashedPassword)
                return DbLoginStatus.InvalidCredentials;

            acc = new DbAccount(_db, info.AccountId);

            // make sure account has all classes if they are supposed to
            var stats = new DbClassStats(acc);

            if (_resources.Settings.NewAccounts.ClassesUnlocked)
                foreach (var @class in _resources.GameData.Classes.Keys)
                    stats.Unlock(@class);

            stats.FlushAsync();

            // make sure account has all skins if they are supposed to
            if (_resources.Settings.NewAccounts.SkinsUnlocked)
                acc.Skins = (from skin in _resources.GameData.Skins.Values select skin.Type).ToArray();

            return DbLoginStatus.OK;
        }

        protected int? GetCurrencyAmount(DbAccount acc, CurrencyType currency)
        {
            switch (currency)
            {
                case CurrencyType.Gold:
                    return acc.Credits;

                case CurrencyType.Fame:
                    return acc.Fame;

                default:
                    return null;
            }
        }

        public byte[] GetGiftBytes(Array gifts)
        {
            if (gifts.Length <= 0)
                return null;

            var buff = new byte[gifts.Length * 2];

            Buffer.BlockCopy(gifts, 0, buff, 0, buff.Length);

            return buff;
        }

        protected ushort[] InitInventory(ushort[] givenItems)
        {
            var inv = Utils.ResizeArray(givenItems, 28);
            for (var i = givenItems.Length; i < inv.Length; i++)
                inv[i] = 0xffff;
            return inv;
        }

        protected bool SetGifts(DbAccount acc, byte[] giftBytes, ITransaction transaction = null)
        {
            var currentGiftBytes = GetGiftBytes(acc.Gifts.ToArray());
            var t = transaction ?? _db.CreateTransaction();
            t.AddCondition(Condition.HashEqual(acc.Key, "gifts", currentGiftBytes));
            t.HashSetAsync(acc.Key, "gifts", giftBytes);

            return transaction == null && t.Execute();
        }

        protected void UpdateAccountCurrency(DbAccount acc, CurrencyType type, int value, bool total = false)
        {
            switch (type)
            {
                case CurrencyType.Gold:
                    if (total)
                        acc.TotalCredits = value;
                    else
                        acc.Credits = value;
                    break;

                case CurrencyType.Fame:
                    if (total)
                        acc.TotalFame = value;
                    else
                        acc.Fame = value;
                    break;
            }
        }

        protected void UpdatePlayerGuildFame(DbAccount acc, int amount) => acc.GuildFame = (int)_db.HashIncrement(acc.Key, "guildFame", amount);

        public static string GetHashedPassword(string password)
        {
            var sb = new StringBuilder();
            using (var md5 = MD5.Create())
            {
                var computedBuffer = md5.ComputeHash(Encoding.UTF8.GetBytes(password));
                for (var i = 0; i < computedBuffer.Length; i++)
                    _ = sb.Append(computedBuffer[i].ToString("X2"));

                var salt = password.Substring(0, password.Length / 2);
                var buffer = md5.ComputeHash(Encoding.UTF8.GetBytes(salt));
                for (var i = 0; i < computedBuffer.Length; i++)
                    _ = sb.Append(buffer[i].ToString("X2"));
            }
            return sb.ToString();
        }
    }
}
