using Shared;
using Shared.database.character.inventory;
using Shared.database.party;
using Shared.resources;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using WorldServer.core.net.datas;
using WorldServer.core.net.handlers;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;
using WorldServer.core.objects.inventory;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.logic;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

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

        public PotionStack[] PotionStacks { get; private set; }
        public PotionStack HealthPotionStack { get; private set; }
        public PotionStack MagicPotionStack { get; private set; }
        public RInventory DbLink { get; private set; }
        public Inventory Inventory { get; private set; }
        public FameCounter FameCounter { get; private set; }
        public ConcurrentQueue<InboundBuffer> IncomingMessages { get; private set; } = new ConcurrentQueue<InboundBuffer>();
        public Pet Pet { get; set; }
        public int PetId { get; set; }
        public int[] SlotTypes { get; private set; }
        public int? GuildInvite { get; set; }
        public bool IsInvulnerable => HasConditionEffect(ConditionEffectIndex.Paused) || HasConditionEffect(ConditionEffectIndex.Stasis) || HasConditionEffect(ConditionEffectIndex.Invincible) || HasConditionEffect(ConditionEffectIndex.Invulnerable);
        public int LDBoostTime { get; set; }
        public bool UpgradeEnabled { get; set; }
        public int XPBoostTime { get; set; }
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

        private int[] _slotEffectCooldowns = new int[4];
        private int _originalSkin;

        public StatsManager Stats;
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

        public Player(Client client)
            : base(client.GameServer, client.Character.ObjectType)
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

            UpgradeEnabled = character.UpgradeEnabled;

            Name = account.Name;
            Health = character.Health;

            XPBoostTime = character.XPBoostTime;
            LDBoostTime = character.LDBoostTime;

            var s = (ushort)character.Skin;
            if (gameData.Skins.ContainsKey(s))
            {
                SetDefaultSkin(s);
                SetDefaultSize(gameData.Skins[s].Size);
            }

            var guild = GameServer.Database.GetGuild(account.GuildId);
            if (guild?.Name != null)
            {
                Guild = guild.Name;
                GuildRank = account.GuildRank;
            }

            if (account.Size > 0)
                Size = account.Size;

            PetId = character.PetId;

            HealthPotionStack = new PotionStack(this, 254, 0x0A22, count: character.HealthStackCount, settings.MaxStackablePotions);
            MagicPotionStack = new PotionStack(this, 255, 0x0A23, count: character.MagicStackCount, settings.MaxStackablePotions);
            PotionStacks = [HealthPotionStack, MagicPotionStack];

            character.Datas ??= new ItemData[28];
            Inventory = new Inventory(this, Utils.ResizeArray(character.Items.Select(_ => (_ == 0xffff || !gameData.Items.ContainsKey(_)) ? null : gameData.Items[_]).ToArray(), 28), Utils.ResizeArray(Client.Character.Datas, 28));
            Inventory.InventoryChanged += (sender, e) => Stats.ReCalculateValues();
            SlotTypes = Utils.ResizeArray(gameData.Classes[ObjectType].SlotTypes, 28);

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
                ApplyPermanentConditionEffect(ConditionEffectIndex.Hidden);
                ApplyPermanentConditionEffect(ConditionEffectIndex.Invincible);
            }

            InitializeRank(account);
            InitializePotionStorage(account);
        }

        public override bool CanBeSeenBy(Player player)
        {
            if (IsAdmin || IsCommunityManager)
                return !HasConditionEffect(ConditionEffectIndex.Hidden);
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

        public void Death(string killer, bool rekt = false)
        {
            if (Client.State == ProtocolState.Disconnected || Dead)
                return;
            Dead = true;

            if (rekt)
            {
                GenerateGravestone(true);
                ReconnectToNexus();
                return;
            }

            if (Resurrection())
                return;

            if (TestWorld(killer))
                return;

            SaveToCharacter();
            GameServer.Database.Death(GameServer.Resources.GameData, Client.Account, Client.Character, FameCounter.Stats, killer);

            GenerateGravestone();
            AnnounceDeath(killer);

            Client.SendPacket(new DeathMessage(AccountId, Client.Character.CharId, killer));
            Client.Disconnect("Death");
        }

        public int GetCurrency(CurrencyType currency)
        {
            switch (currency)
            {
                case CurrencyType.Gold:
                    return Credits;
                case CurrencyType.Fame:
                    return CurrentFame;
                default:
                    return 0;
            }
        }

        public int GetMaxedStats()
        {
            var playerDesc = GameServer.Resources.GameData.Classes[ObjectType];
            return playerDesc.Stats.Where((t, i) => Stats.Base[i] >= t.MaxValue).Count() + (UpgradeEnabled ? playerDesc.Stats.Where((t, i) => i == 0 ? Stats.Base[i] >= t.MaxValue + 50 : i == 1 ? Stats.Base[i] >= t.MaxValue + 50 : Stats.Base[i] >= t.MaxValue + 10).Count() : 0);
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

            SetNewbiePeriod();
            InitializeUpdate();
        }

        public void HandleIO(ref TickTime time)
        {
            while (IncomingMessages.TryDequeue(out var incomingMessage))
            {
                if (incomingMessage.Client.State == ProtocolState.Disconnected)
                    break;

                var handler = MessageHandlers.GetHandler(incomingMessage.MessageId);
                if (handler == null)
                {
                    incomingMessage.Client.PacketSpamAmount++;
                    if (incomingMessage.Client.PacketSpamAmount > 32)
                        incomingMessage.Client.Disconnect($"Packet Spam: {incomingMessage.Client.IpAddress}");
                    StaticLogger.Instance.Error($"Unknown MessageId: {incomingMessage.MessageId} - {Client.IpAddress}");
                    continue;
                }

                try
                {
                    NetworkReader rdr = null;
                    if (incomingMessage.Payload.Length != 0)
                        rdr = new NetworkReader(new MemoryStream(incomingMessage.Payload));
                    handler.Handle(incomingMessage.Client, rdr, ref time);
                    rdr?.Dispose();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error processing packet ({((incomingMessage.Client.Account != null) ? incomingMessage.Client.Account.Name : "")}, {incomingMessage.Client.IpAddress})\n{ex}");
                    if (ex is not EndOfStreamException)
                        StaticLogger.Instance.Error($"Error processing packet ({((incomingMessage.Client.Account != null) ? incomingMessage.Client.Account.Name : "")}, {incomingMessage.Client.IpAddress})\n{ex}");
                    incomingMessage.Client.SendFailure("An error occurred while processing data from your client.", FailureMessage.MessageWithDisconnect);
                }
            }
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

        public void RestoreDefaultSkin() => Skin = _originalSkin;

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
            chr.Skin = _originalSkin;
            chr.FameStats = FameCounter?.Stats?.Write() ?? chr.FameStats;
            chr.LastSeen = DateTime.Now;
            chr.HealthStackCount = HealthPotionStack.Count;
            chr.MagicStackCount = MagicPotionStack.Count;
            chr.HasBackpack = HasBackpack;
            chr.PetId = PetId;
            chr.Items = Inventory.GetItemTypes();
            chr.XPBoostTime = XPBoostTime;
            chr.LDBoostTime = LDBoostTime;
            chr.UpgradeEnabled = UpgradeEnabled;
            chr.Datas = Inventory.Data.GetDatas();

            Client.Account.TotalFame = Client.Account.Fame;
            Stats.ReCalculateValues();
        }

        public void SetDefaultSkin(int skin)
        {
            _originalSkin = skin;
            Skin = skin;
        }

        public void Teleport(TickTime time, int objId, bool ignoreRestrictions = false)
        {
            if (IsInMarket && (World is NexusWorld))
            {
                SendError("You cannot teleport while inside the market.");
                RestartTPPeriod();
                return;
            }

            var obj = World.GetEntity(objId);
            if (obj == null)
            {
                SendError("Target does not exist.");
                RestartTPPeriod();
                return;
            }

            if (!ignoreRestrictions)
            {
                if (Id == objId)
                {
                    SendInfo("You are already at yourself, and always will be!");
                    return;
                }

                if (!World.AllowTeleport && !IsAdmin)
                {
                    SendError("Cannot teleport here.");
                    RestartTPPeriod();
                    return;
                }

                if (HasConditionEffect(ConditionEffectIndex.Paused))
                {
                    SendError("Cannot teleport while paused.");
                    RestartTPPeriod();
                    return;
                }

                if (obj is not Player)
                {
                    SendError("Can only teleport to players.");
                    RestartTPPeriod();
                    return;
                }

                if (obj.HasConditionEffect(ConditionEffectIndex.Invisible))
                {
                    SendError("Cannot teleport to an invisible player.");
                    RestartTPPeriod();
                    return;
                }

                if (obj.HasConditionEffect(ConditionEffectIndex.Paused))
                {
                    SendError("Cannot teleport to a paused player.");
                    RestartTPPeriod();
                    return;
                }

                if (obj.HasConditionEffect(ConditionEffectIndex.Hidden))
                {
                    SendError("Target does not exist.");
                    RestartTPPeriod();
                    return;
                }

                if (!TPCooledDown())
                {
                    SendError("Too soon to teleport again!");
                    return;
                }
            }
            
            ApplyConditionEffect(ConditionEffectIndex.Invulnerable, 2500);
            ApplyConditionEffect(ConditionEffectIndex.Stunned, 2500);
            TeleportPosition(time, obj.X, obj.Y, ignoreRestrictions);
        }

        public void TeleportPosition(TickTime time, float x, float y, bool ignoreRestrictions = false) => TeleportPosition(time, new Position() { X = x, Y = y }, ignoreRestrictions);

        public void TeleportPosition(TickTime time, Position position, bool ignoreRestrictions = false)
        {
            if (!ignoreRestrictions)
            {
                if (!TPCooledDown())
                {
                    SendError("Too soon to teleport again!");
                    return;
                }

                SetTPDisabledPeriod();
                SetNewbiePeriod();
                FameCounter.Teleport();
            }

            var id = Id;
            var tpPkts = new OutgoingMessage[]
            {
                new GotoMessage(id, position),
                new ShowEffect()
                {
                    EffectType = EffectType.Teleport,
                    TargetObjectId = id,
                    Pos1 = position,
                    Color = new ARGB(0xFFFFFFFF)
                }
            };

            World.ForeachPlayer(_ =>
            {
                _.AwaitGotoAck(time.TotalElapsedMs);
                _.Client.SendPackets(tpPkts);
            });

            UpdateTiles();
        }
        
        public bool DeltaTime;

        public override void Tick(ref TickTime time)
        {
            if (KeepAlive(time))
            {
                if (DeltaTime)
                    SendInfo($"[DeltaTime]: {World.DisplayName} -> {time.ElapsedMsDelta}");
                
                HandleBreath(ref time);

                CheckTradeTimeout(time);
                HandleQuest(time);

                HandleEffects(ref time);
                HandleRegen(ref time);

                GroundEffect(time);
                TickCooldownTimers(time);

                TickSlotCooldowns(time);
                TryApplySpecialEffects();

                FameCounter.Tick(time);

                CerberusClaws(time);
                CerberusCore(time);
            }
            base.Tick(ref time);
        }

        public bool IsInMarket { get; private set; }

        public void HandleBreath(ref TickTime time)
        {
            if (World.IdName != "Ocean Trench" || World.IdName != "Hideout of Thessal")
                return;
            if (Breath > 0)
                Breath -= 20 * time.BehaviourTickTime;
            else
                Health -= (int)(20 * time.BehaviourTickTime);

            if (Health < 0)
                Death("Suffocation");
        }

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

        private void CerberusClaws(TickTime time)
        {
            var elasped = time.TotalElapsedMs;
            if (elasped % 2000 == 0)
                Stats.ReCalculateValues();
        }

        private void CerberusCore(TickTime time)
        {
            var elasped = time.TotalElapsedMs;
            if (elasped % 15000 == 0)
                ApplyConditionEffect(ConditionEffectIndex.Berserk, 5000);
        }

        //private string CheckRankAPI(int accID, int charID)
        //{
        //    var httpWebRequest = (HttpWebRequest)WebRequest.Create($"https://tkr.gg/api/getRank");
        //    httpWebRequest.ContentType = "application/json";
        //    httpWebRequest.Method = "POST";

        //    using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
        //    {
        //        string json = new JavaScriptSerializer().Serialize(new APIRank()
        //        {
        //            accID = accID,
        //            charID = charID
        //        });
        //        streamWriter.Write(json);
        //        streamWriter.Flush();
        //        streamWriter.Close();
        //    }

        //    try
        //    {
        //        var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
        //        using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
        //        {
        //            var result = streamReader.ReadToEnd();
        //            var data = JsonConvert.DeserializeObject<APIResp>(result);
        //            if (!result.Contains("200")) //200 is normal result, if it doesn't contains it, somethingb bad happened
        //                Console.WriteLine(result);
        //            return data.charRank;
        //        }
        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine(e);
        //        return "n/a";
        //    }
        //}

        private void AnnounceDeath(string killer)
        {
            var maxed = GetMaxedStats();
            var deathMessage = Name + " (" + maxed + "/8, " + Client.Character.Fame + ") has been killed by " + killer + "! ";

            if ((maxed >= 6 || Fame >= 1000) && !IsAdmin)
            {
                var worlds = GameServer.WorldManager.GetWorlds();
                foreach(var world in worlds)
                    world.ForeachPlayer(_ => _.DeathNotif(deathMessage));
                return;
            }

            var pGuild = Client.Account.GuildId;

            // guild case, only for level 20
            if (pGuild > 0 && Level == 20)
            {
                var worlds = GameServer.WorldManager.GetWorlds();
                foreach (var world in worlds)
                    world.ForeachPlayer(_ =>
                    {
                        if (_.Client.Account.GuildId == pGuild)
                            _.DeathNotif(deathMessage);
                    });
                World.ForeachPlayer(_ =>
                {
                    if (_.Client.Account.GuildId != pGuild)
                        _.DeathNotif(deathMessage);
                });
            }
            else
                // guild less case
                World.ForeachPlayer(_ => _.DeathNotif(deathMessage));
        }

        private void GenerateGravestone(bool phantomDeath = false)
        {
            var playerDesc = GameServer.Resources.GameData.Classes[ObjectType];

            var maxed = playerDesc.Stats.Where((t, i) => Stats.Base[i] >= t.MaxValue).Count();
           
            ushort objType;
            int? time = null;
            switch (maxed)
            {
                case 8: objType = 0x0735; break;
                case 7: objType = 0x0734; break;
                case 6: objType = 0x072b; break;
                case 5: objType = 0x072a; break;
                case 4: objType = 0x0729; break;
                case 3: objType = 0x0728; break;
                case 2: objType = 0x0727; break;
                case 1: objType = 0x0726; break;
                default:
                    objType = 0x0725;
                    time = 300000;
                    if (Level < 20)
                    {
                        objType = 0x0724;
                        time = 60000;
                    }
                    if (Level <= 1)
                    {
                        objType = 0x0723;
                        time = 30000;
                    }
                    break;
            }

            var deathMessage = Name + " (" + maxed + (UpgradeEnabled ? "/16, " : "/8, ") + Client.Character.Fame + ")";

            var obj = new StaticObject(GameServer, objType, time, true, true, false);
            obj.Move(X, Y);
            obj.Name = (!phantomDeath) ? deathMessage : $"{Name} got rekt";
            World.EnterWorld(obj);
        }

        private double HealthRegenCarry;
        private double ManaRegenCarry;

        private void HandleRegen(ref TickTime time)
        {
            var maxHP = Stats[0];
            if(CanHpRegen() && Health < maxHP)
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
            if (CanMpRegen() && Mana < maxMP)
            {
                var wisdomStat = Stats[7];

                ManaRegenCarry += (1.0 + (0.24 * wisdomStat)) * time.DeltaTime;

                if (HasConditionEffect(ConditionEffectIndex.MPTRegeneration))
                    ManaRegenCarry += 20.0 * time.DeltaTime;

                var regen = (int)Math.Ceiling(ManaRegenCarry);
                if (regen > 0)
                {
                    Mana = Math.Min(Mana + regen, maxMP);
                    ManaRegenCarry -= regen;
                }
            }
        }

        private void ReconnectToNexus()
        {
            Health = Stats[0];
            Mana = Stats[1];
            Client.Reconnect(new Reconnect()
            {
                Host = "",
                Port = GameServer.Configuration.serverInfo.port,
                GameId = World.NEXUS_ID,
                Name = "Nexus"
            });
            var party = DbPartySystem.Get(Client.Account.Database, Client.Account.PartyId);
            if (party != null && party.PartyLeader.Item1 == Client.Account.Name && party.PartyLeader.Item2 == Client.Account.AccountId)
                party.WorldId = -1;
        }

        private bool Resurrection()
        {
            for (int i = 0; i < 4; i++)
            {
                var item = Inventory[i];

                if (item == null || !item.Resurrects)
                    continue;

                Inventory[i] = null;
                World.ForeachPlayer(_ => _.SendInfo($"{Name}'s {item.DisplayName} breaks and he disappears"));
                ReconnectToNexus();
                return true;
            }
            return false;
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

        private bool TestWorld(string killer)
        {
            if (!(World is TestWorld))
                return false;
            GenerateGravestone();
            ReconnectToNexus();
            return true;
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
