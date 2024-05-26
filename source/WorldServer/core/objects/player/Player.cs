using Shared;
using Shared.database;
using Shared.database.party;
using Shared.resources;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;
using WorldServer.core.objects.inventory;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.logic;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    internal interface IPlayer
    {
        void Damage(int dmg, Entity src);
        bool IsVisibleToEnemy();
    }

    public partial class Player : Character, IContainer, IPlayer
    {
        public Client Client { get; private set; }

        public bool ShowDeltaTimeLog { get; set; }
        public FameCounter FameCounter { get; private set; }
        public ConcurrentQueue<InboundBuffer> IncomingMessages { get; private set; } = new ConcurrentQueue<InboundBuffer>();
        public Pet Pet { get; set; }
        public int PetId { get; set; }
        public int[] SlotTypes { get; private set; }
        public int? GuildInvite { get; set; }
        public bool IsInvulnerable => HasConditionEffect(ConditionEffectIndex.Paused) || HasConditionEffect(ConditionEffectIndex.Stasis) || HasConditionEffect(ConditionEffectIndex.Invincible) || HasConditionEffect(ConditionEffectIndex.Invulnerable);
        public int LDBoostTime { get; set; }
        public int XPBoostTime { get; set; }

        public bool IsHidden { get; set; }

        public double Breath
        {
            get => _breath;
            set
            {
                OxygenBar = (int)value;
                _breath = value;
            }
        }
        private double _breath;

        public StatsManager Stats { get; private set; }

        public bool Muted { get; set; }


        private StatTypeValue<int> _accountId;
        public int AccountId
        {
            get => _accountId.GetValue(); 
			set => _accountId.SetValue(value);
        }

        private StatTypeValue<int> _baseStat;
        public int BaseStat
        {
            get => _baseStat.GetValue(); 
			set => _baseStat.SetValue(value);
        }

        private StatTypeValue<int> _colorchat;
        public int ColorChat
        {
            get => _colorchat.GetValue(); 
			set => _colorchat.SetValue(value);
        }

        private StatTypeValue<int> _colornamechat;
        public int ColorNameChat
        {
            get => _colornamechat.GetValue();
			set => _colornamechat.SetValue(value);
        }

        private StatTypeValue<int> _credits;
        public int Credits
        {
            get => _credits.GetValue(); 
			set => _credits.SetValue(value);
        }

        private StatTypeValue<int> _currentFame;
        public int CurrentFame
        {
            get => _currentFame.GetValue();
			set => _currentFame.SetValue(value);
        }

        private StatTypeValue<int> _experience;
        public int Experience
        {
            get => _experience.GetValue();
			set => _experience.SetValue(value);
        }

        private StatTypeValue<int> _experienceGoal;
        public int ExperienceGoal
        {
            get => _experienceGoal.GetValue();
			set => _experienceGoal.SetValue(value);
        }

        private StatTypeValue<int> _fame;
        public int Fame
        {
            get => _fame.GetValue();
			set => _fame.SetValue(value);
        }

        private StatTypeValue<int> _fameGoal;
        public int FameGoal
        {
            get => _fameGoal.GetValue();
			set => _fameGoal.SetValue(value);
        }

        private StatTypeValue<int> _glow;
        public int Glow
        {
            get => _glow.GetValue();
			set => _glow.SetValue(value);
        }

        private StatTypeValue<string> _guild;
        public string Guild
        {
            get => _guild.GetValue();
			set => _guild?.SetValue(value);
        }

        private StatTypeValue<int> _guildRank;
        public int GuildRank
        {
            get => _guildRank.GetValue();
			set => _guildRank.SetValue(value);
        }

        private StatTypeValue<bool> _hasBackpack;
        public bool HasBackpack
        {
            get => _hasBackpack.GetValue();
			set => _hasBackpack.SetValue(value);
        }

        private StatTypeValue<int> _level;
        public int Level
        {
            get => _level.GetValue();
			set => _level.SetValue(value);
        }

        private StatTypeValue<int> _mp;
        public int Mana
        {
            get => _mp.GetValue();
			set => _mp.SetValue(value);
        }

        private StatTypeValue<bool> _nameChosen;
        public bool NameChosen
        {
            get => _nameChosen.GetValue();
			set => _nameChosen.SetValue(value);
        }

        private StatTypeValue<int> _oxygenBar;
        public int OxygenBar
        {
            get => _oxygenBar.GetValue();
			set => _oxygenBar.SetValue(value);
        }

        private StatTypeValue<int> _skin;
        public int Skin
        {
            get => _skin.GetValue();
			set => _skin.SetValue(value);
        }

        private StatTypeValue<int> _stars;
        public int Stars
        {
            get => _stars.GetValue();
			set => _stars.SetValue(value);
        }

        private StatTypeValue<int> _texture1;
        public int Texture1
        {
            get => _texture1.GetValue();
			set => _texture1.SetValue(value);
        }

        private StatTypeValue<int> _texture2;
        public int Texture2
        {
            get => _texture2.GetValue();
			set => _texture2.SetValue(value);
        }

        private StatTypeValue<bool> _xpBoosted;
        public bool XPBoosted
        {
            get => _xpBoosted.GetValue();
			set => _xpBoosted.SetValue(value);
        }

        private StatTypeValue<int> _partyId;
        public int PartyId
        {
            get => _partyId.GetValue();
			set => _partyId.SetValue(value);
        }

        public Player(GameServer gameServer, Client client, ushort objectType)
            : base(gameServer, objectType)
        {
            Client = client;
         
            var settings = GameServer.Resources.Settings;
            var gameData = GameServer.Resources.GameData;
            var account = Client.Account;
            var character = client.Character;

            _accountId = new StatTypeValue<int>(this, StatDataType.AccountId, account.AccountId, true);
            _experience = new StatTypeValue<int>(this, StatDataType.Experience, character.Experience, true);
            _experienceGoal = new StatTypeValue<int>(this, StatDataType.ExperienceGoal, 0, true);
            _level = new StatTypeValue<int>(this, StatDataType.Level, character.Level);
            _currentFame = new StatTypeValue<int>(this, StatDataType.CurrentFame, account.Fame, true);
            _fame = new StatTypeValue<int>(this, StatDataType.Fame, character.Fame, true);
            _fameGoal = new StatTypeValue<int>(this, StatDataType.FameGoal, 0, true);
            _stars = new StatTypeValue<int>(this, StatDataType.Stars, 0);
            _guild = new StatTypeValue<string>(this, StatDataType.GuildName, "");
            _guildRank = new StatTypeValue<int>(this, StatDataType.GuildRank, -1);
            _credits = new StatTypeValue<int>(this, StatDataType.Credits, account.Credits, true);
            _nameChosen = new StatTypeValue<bool>(this, StatDataType.NameChosen, account.NameChosen, false, v => account?.NameChosen ?? v);
            _texture1 = new StatTypeValue<int>(this, StatDataType.Texture1, character.Tex1);
            _texture2 = new StatTypeValue<int>(this, StatDataType.Texture2, character.Tex2);
            _skin = new StatTypeValue<int>(this, StatDataType.Skin, 0);
            _glow = new StatTypeValue<int>(this, StatDataType.Glow, 0);
            _xpBoosted = new StatTypeValue<bool>(this, StatDataType.XPBoost, character.XPBoostTime != 0, true);
            _mp = new StatTypeValue<int>(this, StatDataType.Mana, character.MP);
            _hasBackpack = new StatTypeValue<bool>(this, StatDataType.HasBackpack, character.HasBackpack, true);
            _oxygenBar = new StatTypeValue<int>(this, StatDataType.OxygenBar, -1, true);
            _baseStat = new StatTypeValue<int>(this, StatDataType.BaseStat, account.SetBaseStat, true);
            _colornamechat = new StatTypeValue<int>(this, StatDataType.ColorNameChat, 0);
            _colorchat = new StatTypeValue<int>(this, StatDataType.ColorChat, 0);
            _partyId = new StatTypeValue<int>(this, StatDataType.PartyId, account.PartyId, true);

            Name = account.Name;
            Health = character.Health;

            XPBoostTime = character.XPBoostTime;
            LDBoostTime = character.LDBoostTime;

            var skinType = (ushort)character.Skin;
            if (gameData.Skins.ContainsKey(skinType))
            {
                Skin = character.Skin;
                Size = gameData.Skins[skinType].Size;
            }

            var guild = GameServer.Database.GetGuild(account.GuildId);
            if (guild?.Name != null)
            {
                Guild = guild.Name;
                GuildRank = account.GuildRank;
            }

            PetId = character.PetId;

            InitializePotionStacks(character, settings);
            InitializeInventory(gameData, character);

            Stats = new StatsManager(this);

            _ = GameServer.Database.IsMuted(client.IpAddress).ContinueWith(t =>
            {
                Muted = !Client.Rank.IsAdmin && t.IsCompleted && t.Result;
            });

            _ = GameServer.Database.IsLegend(AccountId).ContinueWith(t =>
            {
                Glow = t.Result && account.GlowColor == 0 ? 0xFF0000 : account.GlowColor;
            });

            if (account.Hidden)
            {
                IsHidden = true;
                ApplyPermanentConditionEffect(ConditionEffectIndex.Invincible);
            }

            InitializeRank(account);
            InitializePotionStorage(account);
        }

        public override bool CanBeSeenBy(Player player)
        {
            if (IsAdmin || IsCommunityManager)
                return !IsHidden;
            return true;
        }

        public void Damage(int dmg, Entity src)
        {
            if (IsInvulnerable)
                return;

            dmg = (int)Stats.GetDefenseDamage(dmg, false);
            if (!HasConditionEffect(ConditionEffectIndex.Invulnerable))
                Health -= dmg;

            World.BroadcastIfVisibleExclude(new DamageMessage()
            {
                TargetId = Id,
                Effects = 0,
                DamageAmount = dmg,
                Kill = Health <= 0,
                BulletId = 0,
                ObjectId = src.Id
            }, this, this);

            if (Health <= 0)
                Death(src.ObjectDesc.DisplayId ?? src.ObjectDesc.IdName, src.Spawned);
        }

        public int GetCurrency(CurrencyType currency) => currency switch
        {
            CurrencyType.Gold => Credits,
            CurrencyType.Fame => CurrentFame,
            _ => 0,
        };

        public int GetMaxedStats()
        {
            var playerDesc = GameServer.Resources.GameData.Classes[ObjectType];
            return playerDesc.Stats.Where((t, i) => Stats.Base[i] >= t.MaxValue).Count();
        }

        public override void Init(World owner)
        {
            base.Init(owner);

            // spawn pet if player has one attached
            SpawnPetIfAttached(owner);

            FameCounter = new FameCounter(this);
            FameGoal = GetFameGoal(FameCounter.ClassStats[ObjectType].BestFame);
            ExperienceGoal = GetExpGoal(Client.Character.Level);
            Stars = GetStars();

            if (owner.IdName.Equals("Ocean Trench"))
                Breath = 100;
            if (owner is NexusWorld)
            {
                var settings = Client.GameServer.Configuration.serverSettings;
                if (settings.lootEvent > 0)
                    if (settings.expEvent > 0)
                        SendInfo($"A server wide event is giving you a a {Math.Round(settings.lootEvent * 100, 0)}% loot boost and {Math.Round(settings.expEvent * 100, 0)}% XP boost.");
                    else
                        SendInfo($"A server wide event is giving you a {Math.Round(settings.lootEvent * 100, 0)}% loot boost.");
                if (owner.isWeekend)
                    SendInfo($"It's the weekend! You've been given an additional {Math.Round(settings.wkndBoost * 100, 0)}% loot boost.");
            }
            ResetNewbiePeriod();
            InitializeUpdate();
        }

        public void Reconnect(World world)
        {
            if (world == null)
            {
                SendError("Portal Not Implemented!");
                return;
            }

            Client.Reconnect(new Reconnect()
            {
                Host = "",
                Port = GameServer.Configuration.serverInfo.port,
                GameId = world.Id,
                Name = world.IdName
            });

            var party = DbPartySystem.Get(Client.Account.Database, Client.Account.PartyId);
            if (party != null && party.PartyLeader.Item1 == Client.Account.Name && party.PartyLeader.Item2 == Client.Account.AccountId)
                party.WorldId = -1;
        }

        public void SaveToCharacter()
        {
            if (Client == null || Client.Character == null) 
                return;

            var chr = Client.Character;
            chr.Level = Level;
            chr.Experience = Experience;
            chr.Fame = Fame;
            chr.Health = Health <= 0 ? 1 : Health;
            chr.MP = Mana;
            chr.Stats = Stats.Base.GetStats();
            chr.Tex1 = Texture1;
            chr.Tex2 = Texture2;
            chr.Skin = Skin;
            chr.FameStats = FameCounter?.Stats?.Write() ?? chr.FameStats;
            chr.LastSeen = DateTime.Now;
            chr.HealthStackCount = HealthPotionStack.Count;
            chr.MagicStackCount = MagicPotionStack.Count;
            chr.HasBackpack = HasBackpack;
            chr.PetId = PetId;
            chr.Items = Inventory.GetItemTypes();
            chr.XPBoostTime = XPBoostTime;
            chr.LDBoostTime = LDBoostTime;
            chr.Datas = Inventory.Data.GetDatas();

            Client.Account.TotalFame = Client.Account.Fame;
            Stats.ReCalculateValues();
        }

        public override void Tick(ref TickTime time)
        {
            if (KeepAlive(time))
            {
                if (ShowDeltaTimeLog)
                    SendInfo($"[DeltaTime]: {World.DisplayName} -> {time.ElapsedMsDelta}");

                HandleOxygen(time);

                CheckTradeTimeout(time);
                HandleQuest(time);

                HandleEffects(ref time);
                HandleRegen(ref time);

                GroundEffect(time);
                TickCooldownTimers(time);

                TickSlotCooldowns(time);
                TryApplySpecialEffects(ref time);

                FameCounter.Tick(time);
            }
            base.Tick(ref time);
        }

        public bool IsInMarket { get; private set; }

        // todo rename these damn things
        public bool CanApplySlotEffect(int slot)
        {
            return _slotEffectCooldowns[slot] >= 0;
        }

        internal void SetSlotEffectCooldown(int time, int slot)
        {
            _slotEffectCooldowns[slot] = time * 1000;
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            base.ExportStats(stats, isOtherPlayer);
            if (!isOtherPlayer)
            {
                ExportSelf(stats);
                ExportOther(stats);
                return;
            }
            ExportOther(stats);
        }

        private void ExportSelf(IDictionary<StatDataType, object> stats)
        {
            stats[StatDataType.Inventory4] = Inventory[4]?.ObjectType ?? -1;
            stats[StatDataType.Inventory5] = Inventory[5]?.ObjectType ?? -1;
            stats[StatDataType.Inventory6] = Inventory[6]?.ObjectType ?? -1;
            stats[StatDataType.Inventory7] = Inventory[7]?.ObjectType ?? -1;
            stats[StatDataType.Inventory8] = Inventory[8]?.ObjectType ?? -1;
            stats[StatDataType.Inventory9] = Inventory[9]?.ObjectType ?? -1;
            stats[StatDataType.Inventory10] = Inventory[10]?.ObjectType ?? -1;
            stats[StatDataType.Inventory11] = Inventory[11]?.ObjectType ?? -1;
            stats[StatDataType.BackPack0] = Inventory[12]?.ObjectType ?? -1;
            stats[StatDataType.BackPack1] = Inventory[13]?.ObjectType ?? -1;
            stats[StatDataType.BackPack2] = Inventory[14]?.ObjectType ?? -1;
            stats[StatDataType.BackPack3] = Inventory[15]?.ObjectType ?? -1;
            stats[StatDataType.BackPack4] = Inventory[16]?.ObjectType ?? -1;
            stats[StatDataType.BackPack5] = Inventory[17]?.ObjectType ?? -1;
            stats[StatDataType.BackPack6] = Inventory[18]?.ObjectType ?? -1;
            stats[StatDataType.BackPack7] = Inventory[19]?.ObjectType ?? -1;
            stats[StatDataType.Attack] = Stats[2];
            stats[StatDataType.Defense] = Stats[3];
            stats[StatDataType.Speed] = Stats[4];
            stats[StatDataType.Dexterity] = Stats[5];
            stats[StatDataType.Vitality] = Stats[6];
            stats[StatDataType.Wisdom] = Stats[7];
            stats[StatDataType.AttackBonus] = Stats.Boost[2];
            stats[StatDataType.DefenseBonus] = Stats.Boost[3];
            stats[StatDataType.SpeedBonus] = Stats.Boost[4];
            stats[StatDataType.DexterityBonus] = Stats.Boost[5];
            stats[StatDataType.VitalityBonus] = Stats.Boost[6];
            stats[StatDataType.WisdomBonus] = Stats.Boost[7];
            stats[StatDataType.HealthStackCount] = HealthPotionStack.Count;
            stats[StatDataType.MagicStackCount] = MagicPotionStack.Count;
            stats[StatDataType.HasBackpack] = HasBackpack ? 1 : 0;
            stats[StatDataType.LDBoostTime] = LDBoostTime / 1000;
            stats[StatDataType.XPBoost] = (XPBoostTime != 0) ? 1 : 0;
            stats[StatDataType.XPBoostTime] = XPBoostTime / 1000;
            stats[StatDataType.BaseStat] = Client?.Account?.SetBaseStat ?? 0;
            stats[StatDataType.InventoryData4] = Inventory.Data[4]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData5] = Inventory.Data[5]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData6] = Inventory.Data[6]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData7] = Inventory.Data[7]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData8] = Inventory.Data[8]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData9] = Inventory.Data[9]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData10] = Inventory.Data[10]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData11] = Inventory.Data[11]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData0] = Inventory.Data[12]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData1] = Inventory.Data[13]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData2] = Inventory.Data[14]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData3] = Inventory.Data[15]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData4] = Inventory.Data[16]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData5] = Inventory.Data[17]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData6] = Inventory.Data[18]?.GetData() ?? "{}";
            stats[StatDataType.BackPackData7] = Inventory.Data[19]?.GetData() ?? "{}";
            stats[StatDataType.Credits] = Credits;
            if (World is VaultWorld)
            {
                stats[StatDataType.SPS_LIFE_COUNT] = SPSLifeCount;
                stats[StatDataType.SPS_MANA_COUNT] = SPSManaCount;
                stats[StatDataType.SPS_ATTACK_COUNT] = SPSAttackCount;
                stats[StatDataType.SPS_DEFENSE_COUNT] = SPSDefenseCount;
                stats[StatDataType.SPS_DEXTERITY_COUNT] = SPSDexterityCount;
                stats[StatDataType.SPS_WISDOM_COUNT] = SPSWisdomCount;
                stats[StatDataType.SPS_SPEED_COUNT] = SPSSpeedCount;
                stats[StatDataType.SPS_VITALITY_COUNT] = SPSVitalityCount;
                stats[StatDataType.SPS_LIFE_COUNT_MAX] = SPSLifeCountMax;
                stats[StatDataType.SPS_MANA_COUNT_MAX] = SPSManaCountMax;
                stats[StatDataType.SPS_ATTACK_COUNT_MAX] = SPSAttackCountMax;
                stats[StatDataType.SPS_DEFENSE_COUNT_MAX] = SPSDefenseCountMax;
                stats[StatDataType.SPS_DEXTERITY_COUNT_MAX] = SPSDexterityCountMax;
                stats[StatDataType.SPS_WISDOM_COUNT_MAX] = SPSWisdomCountMax;
                stats[StatDataType.SPS_SPEED_COUNT_MAX] = SPSSpeedCountMax;
                stats[StatDataType.SPS_VITALITY_COUNT_MAX] = SPSVitalityCountMax;
            }
        }

        // minimal export for other players
        // things we wont see or need to know dont get exported
        private void ExportOther(IDictionary<StatDataType, object> stats)
        {
            stats[StatDataType.AccountId] = AccountId;
            stats[StatDataType.Experience] = Experience - GetLevelExp(Level);
            stats[StatDataType.ExperienceGoal] = ExperienceGoal;
            stats[StatDataType.Level] = Level;
            stats[StatDataType.CurrentFame] = CurrentFame;
            stats[StatDataType.Fame] = Fame;
            stats[StatDataType.FameGoal] = FameGoal;
            stats[StatDataType.Stars] = Stars;
            stats[StatDataType.GuildName] = Guild;
            stats[StatDataType.GuildRank] = GuildRank;
            stats[StatDataType.NameChosen] = (Client.Account?.NameChosen ?? NameChosen) ? 1 : 0;
            stats[StatDataType.Texture1] = Texture1;
            stats[StatDataType.Texture2] = Texture2;
            stats[StatDataType.Skin] = Skin;
            stats[StatDataType.Glow] = Glow;
            stats[StatDataType.Mana] = Mana;
            stats[StatDataType.Inventory0] = Inventory[0]?.ObjectType ?? -1;
            stats[StatDataType.Inventory1] = Inventory[1]?.ObjectType ?? -1;
            stats[StatDataType.Inventory2] = Inventory[2]?.ObjectType ?? -1;
            stats[StatDataType.Inventory3] = Inventory[3]?.ObjectType ?? -1;
            stats[StatDataType.Inventory4] = Inventory[4]?.ObjectType ?? -1;
            stats[StatDataType.MaximumHealth] = Stats[0];
            stats[StatDataType.MaximumMana] = Stats[1];
            stats[StatDataType.HealthBoost] = Stats.Boost[0];
            stats[StatDataType.ManaBoost] = Stats.Boost[1];
            stats[StatDataType.OxygenBar] = OxygenBar;
            stats[StatDataType.ColorNameChat] = ColorNameChat;
            stats[StatDataType.ColorChat] = ColorChat;
            stats[StatDataType.PartyId] = Client.Account.PartyId;
            stats[StatDataType.InventoryData0] = Inventory.Data[0]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData1] = Inventory.Data[1]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData2] = Inventory.Data[2]?.GetData() ?? "{}";
            stats[StatDataType.InventoryData3] = Inventory.Data[3]?.GetData() ?? "{}";
        }

        private double HealthRegenCarry;
        private double ManaRegenCarry;

        private void HandleRegen(ref TickTime time)
        {
            var maxHP = Stats[0];
            if(CanRegenerateHealth() && Health < maxHP)
            {
                var vitalityStat = Stats[6];

                HealthRegenCarry += (1.0 + (0.36 * vitalityStat)) * time.DeltaTime;
                if (HasConditionEffect(ConditionEffectIndex.Healing))
                    HealthRegenCarry += 20.0 * time.DeltaTime;

                var regen = (int)Math.Ceiling(HealthRegenCarry);
                if (regen > 0)
                {
                    Health = Math.Min(Health + regen, maxHP);
                    HealthRegenCarry -= regen;
                }
            }

            var maxMP = Stats[1];
            if (CanRegenerateMana() && Mana < maxMP)
            {
                var wisdomStat = Stats[7];

                ManaRegenCarry += (1.0 + (0.24 * wisdomStat)) * time.DeltaTime;

                var regen = (int)Math.Ceiling(ManaRegenCarry);
                if (regen > 0)
                {
                    Mana = Math.Min(Mana + regen, maxMP);
                    ManaRegenCarry -= regen;
                }
            }
        }

        private void SpawnPetIfAttached(World owner)
        {
            // despawn old pet if found
            if (Pet != null)
                owner.LeaveWorld(Pet);

            if (Client.Account.Hidden)
                return;

            // create new pet
            var petId = PetId;
            if (petId != 0)
            {
                //var pet = new Pet(GameServer, this, (ushort)petId);
                //pet.Move(X, Y);
                //owner.EnterWorld(pet);
                //pet.SetDefaultSize(pet.ObjectDesc.Size);
                //Pet = pet;
            }
        }

        private void TickCooldownTimers(TickTime time)
        {
            var dt = time.ElapsedMsDelta;
            if (World is VaultWorld || World is NexusWorld || World.InstanceType == WorldResourceInstanceType.Guild || World.Id == 10)
                return;
            
            if (XPBoostTime > 0)
            {    
                if (Level >= 20)
                    XPBoostTime = 0;

                XPBoostTime = Math.Max(XPBoostTime - dt, 0);
                if (XPBoostTime == 0)
                    XPBoosted = false;
            }

            if (LDBoostTime > 0)
                LDBoostTime = Math.Max(LDBoostTime - dt, 0);
        }

        private void TickSlotCooldowns(TickTime time)
        {
            var dt = time.ElapsedMsDelta;
            for (var slot = 0; slot < 4; slot++)
                _slotEffectCooldowns[slot] = Math.Max(_slotEffectCooldowns[slot] - dt, 0);
        }
    }
}
