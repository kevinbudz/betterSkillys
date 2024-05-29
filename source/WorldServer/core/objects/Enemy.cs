using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.net.stats;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    public class Enemy : Character
    {
        private float _bleeding = 0;

        protected StatTypeValue<int> _defense;
        public int Defense
        {
            get => _defense.GetValue();
            set => _defense.SetValue(value);
        }

        private StatTypeValue<int> _glowcolor;
        public int GlowEnemy
        {
            get => _glowcolor.GetValue();
            set => _glowcolor.SetValue(value);
        }

        public DamageCounter DamageCounter { get; private set; }
        public Enemy ParentEntity { get; set; }

        public TerrainType Terrain { get; set; }

        public bool IsEpic { get; set; }
        public bool IsLegendary { get; set; }
        public bool IsRare { get; set; }
        
        public Enemy(GameServer manager, ushort objType)
            : base(manager, objType)
        {
            DamageCounter = new DamageCounter(this);
            _glowcolor = new StatTypeValue<int>(this, StatDataType.GlowEnemy, 0);
            _defense = new StatTypeValue<int>(this, StatDataType.Defense, ObjectDesc.Defense);
        }

        public override void Init(World owner)
        {
            base.Init(owner);
            if (ObjectDesc.Quest || ObjectDesc.Hero || ObjectDesc.Encounter)
                ClasifyEnemy();
        }

        public override void Tick(ref TickTime time)
        {
            if (Health == 0 && !Dead)
                Death(ref time);

            if (HasConditionEffect(ConditionEffectIndex.Bleeding))
            {
                if (_bleeding > 1)
                {
                    Health -= (int)_bleeding;
                    _bleeding -= (int)_bleeding;
                }

                _bleeding += time.DeltaTime * 5;
            }

            base.Tick(ref time);
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            base.ExportStats(stats, isOtherPlayer);
            stats[StatDataType.GlowEnemy] = GlowEnemy;
        }

        public void ClasifyEnemy()
        {
            var chance = Random.Shared.NextDouble();
            if (chance < 0.2)
            {
                var type = Random.Shared.Next(0, 3);
                switch (type)
                {
                    case 2:
                        {
                            IsLegendary = true;
                            GlowEnemy = 0xD865A5;
                        }
                        break;
                    case 1:
                        {
                            IsEpic = true;
                            GlowEnemy = 0xC183AF;
                        }
                        break;
                    case 0:
                        {
                            IsRare = true;
                            GlowEnemy = 0x82D9BC;
                        }
                        break;
                }

                Size += (type + 1) * 25;
                MaxHealth *= type + 1;
                Health = MaxHealth;
            }
        }

        public void ClasifyEnemyJson(string clasify)
        {
            var clasified = clasify.ToLowerInvariant();

            if (clasified == "legendary")
            {
                IsLegendary = true;

                Size = Size <= 0 ? Size : Random.Shared.Next(Size + 200, Size + 300);

                MaxHealth *= 2;
                Health = MaxHealth;
                Defense += 10;
                GlowEnemy = 0xD865A5;
            }
            else if (clasified == "epic")
            {
                IsEpic = true;

                Size = Size <= 0 ? Size : Random.Shared.Next(Size + 100, Size + 200);

                MaxHealth = (int)Math.Round(MaxHealth * 1.5, 0);
                Health = MaxHealth;
                Defense += 5;
                GlowEnemy = 0xC183AF;
            }
            else if (clasified == "rare")
            {
                IsRare = true;

                Size = Size <= 0 ? Size : Random.Shared.Next(Size, Size + 100);

                MaxHealth = (int)Math.Round(MaxHealth * 1.25, 0);
                Defense += 3;
                GlowEnemy = 0x82D9BC;
            }
        }

        public int Damage(Player from, ref TickTime time, int dmg, bool noDef, bool itsPoison = false, params ConditionEffect[] effs)
        {
            if (!itsPoison && HasConditionEffect(ConditionEffectIndex.Invincible))
                return 0;

            if (!HasConditionEffect(ConditionEffectIndex.Paused) && !HasConditionEffect(ConditionEffectIndex.Stasis))
            {
                var def = Defense;
                var dmgd = StatsManager.DamageWithDefense(this, dmg, noDef, def);

                var effDmg = dmgd;

                if (effDmg > Health)
                    effDmg = Health;

                if (!HasConditionEffect(ConditionEffectIndex.Invulnerable))
                    Health -= effDmg;

                ApplyConditionEffect(effs);
                World.BroadcastIfVisible(new DamageMessage()
                {
                    TargetId = Id,
                    Effects = 0,
                    DamageAmount = effDmg,
                    Kill = Health < 0,
                    BulletId = 0,
                    ObjectId = from.Id
                }, this);

                DamageCounter?.HitBy(from, effDmg);

                if (Health < 0 && World != null)
                    Death(ref time);

                return effDmg;
            }

            return 0;
        }

        public event EventHandler<BehaviorEventArgs> OnDeath;

        public void Death(ref TickTime time)
        {
            if (!Dead)
            {
                DamageCounter.Death();
                CurrentState?.OnDeath(this, ref time);
                if (GameServer.BehaviorDb.Definitions.TryGetValue(ObjectType, out var loot))
                    loot.Item2?.Handle(this, time);
            }
            World.LeaveWorld(this);
        }
    }
}
