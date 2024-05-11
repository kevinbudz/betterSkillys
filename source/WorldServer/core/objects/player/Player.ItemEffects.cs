using Shared;
using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.net.datas;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private readonly int[] _slotEffectCooldowns = new int[4];

        private void CerberusClaws(ref TickTime time)
        {
            var elasped = time.TotalElapsedMs;
            if (elasped % 2000 == 0)
                Stats.ReCalculateValues();
        }

        private void CerberusCore(ref TickTime time)
        {
            var elasped = time.TotalElapsedMs;
            if (elasped % 15000 == 0)
                ApplyConditionEffect(ConditionEffectIndex.Berserk, 5000);
        }

        private void TryApplySpecialEffects(ref TickTime time)
        {
            for (var slot = 0; slot < 4; slot++)
            {
                if (!CanApplySlotEffect(slot))
                    continue;

                var item = Inventory[slot];
                if (item == null || !item.Legendary && !item.Mythical)
                    continue;

                if (item.Lucky)
                    LuckyEffects(item, slot);

                if (item.Mythical)
                    RevengeEffects(item, slot);

                if (item.Legendary)
                    TryApplyLegendaryEffects(item, slot);
            }

            CerberusClaws(ref time);
            CerberusCore(ref time);
        }

        private void LuckyEffects(Item item, int slot)
        {
            if (Random.Shared.NextDouble() < 0.1)
            {
                SetSlotEffectCooldown(20, slot);

                for (var j = 0; j < 8; j++)
                    Stats.Boost.ActivateBoost[j].Push(j == 0 || j == 1 ? 100 : 15, false);

                Stats.ReCalculateValues();
                World.StartNewTimer(5000, (world, t) =>
                {
                    for (var i = 0; i < 8; i++)
                        Stats.Boost.ActivateBoost[i].Pop(i == 0 || i == 1 ? 100 : 15, false);
                    Stats.ReCalculateValues();
                });

                World.BroadcastIfVisible(new Notification()
                {
                    Message = "Boosted!",
                    Color = new ARGB(0xFF00FF00),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);
            }
        }

        private void TryAddOnEnemyHitEffect(ref TickTime tickTime, Enemy entity, ProjectileDesc projectileDesc)
        {
            for (var slot = 0; slot < 4; slot++)
            {
                if (!CanApplySlotEffect(slot))
                    continue;

                var item = Inventory[slot];
                if (item == null || !item.Legendary && !item.Mythical)
                    continue;

                if (item.Demonized)
                    Demonized(entity, slot);

                if (item.Vampiric)
                    VampireBlast(entity, slot, ref tickTime, entity, projectileDesc.MultiHit);

                if (item.Electrify)
                    Electrify(slot, ref tickTime, entity);
            }
        }

        public void Demonized(Enemy entity, int slot)
        {
            if (Random.Shared.NextDouble() < 0.3)
                return;

            SetSlotEffectCooldown(4, slot);

            entity.ApplyConditionEffect(ConditionEffectIndex.Curse, 5000);

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = entity.Id,
                Color = new ARGB(0xFFFFFF00),
                Pos1 = new Position() { X = 1.5f }
            }, this);

            World.BroadcastIfVisible(new Notification()
            {
                ObjectId = Id,
                PlayerId = Id,
                Message = "Demonized!",
                Color = new ARGB(0xFFFF0000)
            }, this);
        }

        public void VampireBlast(Enemy entity, int slot, ref TickTime time, Entity firstHit, bool multi)
        {
            var chance = 0.03;
            chance -= Inventory[0].NumProjectiles / 3 / 100;
            chance = multi ? chance / 1.5 : chance;

            if (Random.Shared.NextDouble() < chance)
                return;

            var procPos = firstHit.Position;
            var pkts = new List<OutgoingMessage>()
            {
                new ShowEffect()
                {
                    EffectType = EffectType.Trail,
                    TargetObjectId = firstHit.Id,
                    Pos1 = Position,
                    Color = new ARGB(0xFFFF0000)
                },
                new ShowEffect
                {
                    EffectType = EffectType.Diffuse,
                    Color = new ARGB(0xFFFF0000),
                    TargetObjectId = Id,
                    Pos1 = firstHit.Position,
                    Pos2 = new Position { X = firstHit.X + 3, Y = firstHit.Y }
                },
                new Notification
                {
                    Message = "Vampiric!",
                    Color = new ARGB(0xFFD336B3),
                    ObjectId = firstHit.Id,
                    PlayerId = Id
                }
            };

            World.BroadcastIfVisible(pkts[0], this);
            World.BroadcastIfVisible(pkts[1], this);

            var totalDmg = 300;
            var enemies = new List<Enemy>();

            var t = time;
            World.AOE(procPos, 3, false, enemy =>
            {
                enemies.Add(enemy as Enemy);
                totalDmg += (enemy as Enemy).Damage(this, ref t, totalDmg, false);
            });

            if (!HasConditionEffect(ConditionEffectIndex.Sick))
                ActivateHealHp(this, 50);

            if (Health < MaxHealth && enemies.Count > 0)
            {
                for (var i = 0; i < 5; i++)
                {
                    var a = Random.Shared.NextLength(enemies);

                    World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.Flow,
                        TargetObjectId = Id,
                        Pos1 = new Position() { X = a.X, Y = a.Y },
                        Color = new ARGB(0xffffffff)
                    }, this);
                }
            }
        }

        public void Electrify(int slot, ref TickTime time, Entity firstHit)
        {
            if (Random.Shared.NextDouble() < 0.03)
                return;

            SetSlotEffectCooldown(10, slot);

            var current = firstHit;
            var targets = new Entity[5];

            for (var i = 0; i < targets.Length; i++)
            {
                targets[i] = current;

                var next = current.GetNearestEntity(10, false, e =>
                {
                    if (!(e is Enemy) || e.HasConditionEffect(ConditionEffectIndex.Invincible) || e.HasConditionEffect(ConditionEffectIndex.Stasis) || Array.IndexOf(targets, e) != -1)
                        return false;
                    return true;
                });

                if (next == null)
                    break;

                current = next;
            }

            for (var i = 0; i < targets.Length; i++)
            {
                if (targets[i] == null)
                    break;

                var damage = 1000;

                (targets[i] as Enemy).Damage(this, ref time, damage, false);
                targets[i].ApplyConditionEffect(ConditionEffectIndex.Slowed, 3000);

                var prev = i == 0 ? this : targets[i - 1];
                var notprev = targets[i];
                var pkts = new List<OutgoingMessage>
                {
                    new ShowEffect()
                    {
                        EffectType = EffectType.Lightning,
                        TargetObjectId = prev.Id,
                        Color = new ARGB(0xFFFFFF00),
                        Pos1 = new Position()
                        {
                            X = targets[i].X,
                            Y = targets[i].Y
                        },
                        Pos2 = new Position() { X = 350 }
                    },
                    new Notification
                    {
                        Color = new ARGB(0xFFFFFF00),
                        ObjectId = notprev.Id,
                        PlayerId = Id,
                        Message = "Electrified!"
                    }
                };

                World.BroadcastIfVisible(pkts[0], this);
                World.BroadcastIfVisible(pkts[1], this);
            }
        }

        private void TryAddOnPlayerHitEffect()
        {
            for (var slot = 0; slot < 4; slot++)
            {
                if (!CanApplySlotEffect(slot))
                    continue;

                var item = Inventory[slot];
                if (item == null || !item.Legendary && !item.Mythical)
                    continue;

                if (item.MonkeyKingsWrath)
                    MonkeyKingsWrath(slot);

                if (item.GodTouch)
                    GodTouch(slot);

                if (item.GodBless)
                    GodBless(slot);

                if (item.Clarification)
                    Clarification(slot);
            }
        }

        private void RevengeEffects(Item item, int slot)
        {
            if (item.Insanity)
            {
                if (Random.Shared.NextDouble() < 0.05 && CanApplySlotEffect(slot))
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Insanity!",
                        Color = new ARGB(0xFFFF0000),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);

                    SetSlotEffectCooldown(10, slot);
                    ApplyConditionEffect(ConditionEffectIndex.Berserk, 3000);
                    ApplyConditionEffect(ConditionEffectIndex.Damaging, 3000);
                }
            }

            if (item.HolyProtection)
            {
                if (Random.Shared.NextDouble() < 0.1 && CanApplySlotEffect(slot))
                {
                    if (!(HasConditionEffect(ConditionEffectIndex.Quiet)
                        || HasConditionEffect(ConditionEffectIndex.Weak)
                        || HasConditionEffect(ConditionEffectIndex.Slowed)
                        || HasConditionEffect(ConditionEffectIndex.Sick)
                        || HasConditionEffect(ConditionEffectIndex.Dazed)
                        || HasConditionEffect(ConditionEffectIndex.Stunned)
                        || HasConditionEffect(ConditionEffectIndex.Blind)
                        || HasConditionEffect(ConditionEffectIndex.Hallucinating)
                        || HasConditionEffect(ConditionEffectIndex.Drunk)
                        || HasConditionEffect(ConditionEffectIndex.Confused)
                        || HasConditionEffect(ConditionEffectIndex.Paralyzed)
                        || HasConditionEffect(ConditionEffectIndex.Bleeding)
                        || HasConditionEffect(ConditionEffectIndex.Hexed)
                        || HasConditionEffect(ConditionEffectIndex.Unstable)
                        || HasConditionEffect(ConditionEffectIndex.Curse)
                        || HasConditionEffect(ConditionEffectIndex.Petrify)
                        || HasConditionEffect(ConditionEffectIndex.Darkness)))
                        return;
                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Holy Protection!",
                        Color = new ARGB(0xFFFFFFFF),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);

                    SetSlotEffectCooldown(7, slot);

                    foreach (var effect in NegativeEffs)
                        RemoveCondition(effect);
                }
            }
        }

        private void SonicBlaster(int slot)
        {
            if (CanApplySlotEffect(slot))
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    TargetObjectId = Id,
                    Color = new ARGB(0xff6F00C0),
                    Pos1 = new Position() { X = 3 }
                }, this);

                World.BroadcastIfVisible(new Notification()
                {
                    Message = "Sonic Blaster!",
                    Color = new ARGB(0xFF9300FF),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);

                ApplyConditionEffect(ConditionEffectIndex.Invisible, 4000);
                ApplyConditionEffect(ConditionEffectIndex.Speedy, 4000);
                SetSlotEffectCooldown(30, slot);
            }
        }

        private void TryApplyLegendaryEffects(Item item, int slot)
        {
            var Slot = slot;

            if (item.OutOfOneMind)
            {
                if (Random.Shared.NextDouble() < 0.02 && CanApplySlotEffect(Slot))
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Out of One's Mind!",
                        Color = new ARGB(0xFF00D5D8),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);

                    ApplyConditionEffect(ConditionEffectIndex.Berserk, 3000);
                    SetSlotEffectCooldown(10, Slot);
                }
            }

            if (item.SteamRoller)
            {
                if (Random.Shared.NextDouble() < 0.05 && CanApplySlotEffect(Slot))
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Steam Roller!",
                        Color = new ARGB(0xFF717171),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);

                    ApplyConditionEffect(ConditionEffectIndex.Armored, 5000);
                    SetSlotEffectCooldown(10, Slot);
                }
            }

            if (item.Mutilate)
            {
                if (Random.Shared.NextDouble() < 0.08 && CanApplySlotEffect(Slot))
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Mutilate!",
                        Color = new ARGB(0xFFFF4600),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);

                    ApplyConditionEffect(ConditionEffectIndex.Damaging, 3000);
                    SetSlotEffectCooldown(10, Slot);
                }
            }
        }

        private void MonkeyKingsWrath(int slot)
        {
            if (Random.Shared.NextDouble() < .5 && CanApplySlotEffect(slot))// 50 % chance
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    TargetObjectId = Id,
                    Color = new ARGB(0xffff0000),
                    Pos1 = new Position() { X = 3 }
                }, this);

                World.BroadcastIfVisible(new Notification()
                {
                    Message = "Monkey King's Wrath!",
                    Color = new ARGB(0xFFFF0000),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);
                Client.SendPacket(new GlobalNotificationMessage(0, "monkeyKing"));
                SetSlotEffectCooldown(10, slot);
            }
        }

        private void GodBless(int slot)
        {
            if (Random.Shared.NextDouble() < 0.07 && CanApplySlotEffect(slot))
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    TargetObjectId = Id,
                    Color = new ARGB(0xffA1A1A1),
                    Pos1 = new Position() { X = 3 }
                }, this);
                World.BroadcastIfVisible(new Notification()
                {
                    Message = "God Bless!",
                    Color = new ARGB(0xFFFFFFFF),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);

                ApplyConditionEffect(ConditionEffectIndex.Invulnerable, 3000);
                SetSlotEffectCooldown(10, slot);
            }
        }

        private void GodTouch(int slot)
        {
            if (Random.Shared.NextDouble() < 0.02 && CanApplySlotEffect(slot))
            {
                ActivateHealHp(this, 25 * Stats[0] / 100);
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    TargetObjectId = Id,
                    Color = new ARGB(0xffffffff),
                    Pos1 = new Position() { X = 3 }
                }, this);

                World.BroadcastIfVisible(new Notification()
                {
                    Message = "God Touch!",
                    Color = new ARGB(0xFFFFFFFF),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);
                SetSlotEffectCooldown(30, slot);
            }
        }


        private void Clarification(int slot)
        {
            if (Random.Shared.NextDouble() < 0.1 && CanApplySlotEffect(slot))
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    TargetObjectId = Id,
                    Color = new ARGB(0xff00A6FF),
                    Pos1 = new Position() { X = 3 }
                }, this);

                World.BroadcastIfVisible(new Notification()
                {
                    Message = "Clarification!",
                    Color = new ARGB(0xFF00A6FF),
                    PlayerId = Id,
                    ObjectId = Id
                }, this);

                ActivateHealMp(this, 30 * Stats[1] / 100);
                SetSlotEffectCooldown(10, slot);
            }
        }

        private void EternalEffects(Item item, int slot)
        {
            if (item.MonkeyKingsWrath)
            {
                if (Random.Shared.NextDouble() < .5 && CanApplySlotEffect(slot))// 50 % chance
                {
                    Size = 100;
                    SetSlotEffectCooldown(10, slot);
                    World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.AreaBlast,
                        TargetObjectId = Id,
                        Color = new ARGB(0xFF98ff98),
                        Pos1 = new Position() { X = 3 }
                    }, this);

                    World.BroadcastIfVisible(new Notification()
                    {
                        Message = "Monkey King's Wrath!",
                        Color = new ARGB(0xFF98ff98),
                        PlayerId = Id,
                        ObjectId = Id
                    }, this);
                    //TO BE DECIDED
                    Size = 300;
                }
            }
        }

    }
}
