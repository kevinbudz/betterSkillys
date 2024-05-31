using Shared;
using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;
using WorldServer.core.objects.inventory;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.objects
{
    partial class Player
    {
        public const int MAX_ABILITY_DIST = 14;
        public const int MAX_ABILITY_DIST_SQR = MAX_ABILITY_DIST * MAX_ABILITY_DIST;

        public const int DEFAULT_USE = 0;
        public const int START_USE = 1;
        public const int END_USE = 2;

        public static readonly ConditionEffectIndex[] NegativeEffs = new ConditionEffectIndex[]
        {
            ConditionEffectIndex.Slowed,
            ConditionEffectIndex.Paralyzed,
            ConditionEffectIndex.Weak,
            ConditionEffectIndex.Stunned,
            ConditionEffectIndex.Confused,
            ConditionEffectIndex.Blind,
            ConditionEffectIndex.Quiet,
            ConditionEffectIndex.ArmorBroken,
            ConditionEffectIndex.Bleeding,
            ConditionEffectIndex.Dazed,
            ConditionEffectIndex.Sick,
            ConditionEffectIndex.Drunk,
            ConditionEffectIndex.Hallucinating,
            ConditionEffectIndex.Hexed,
            ConditionEffectIndex.Curse,
            ConditionEffectIndex.Unstable
        };

        public void UseItem(int clientTime, TickTime time, int objId, int slot, Position pos, int useType)
        {
            var entity = World.GetEntity(objId);
            if (entity == null)
            {
                Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            if (entity is Player && objId != Id)
            {
                Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            if (World.DisableAbilities && slot == 1 && entity is Player) // ability slot
            {
                Client.Disconnect("Attempting to activate ability in a disabled world");
                return;
            }

            if (World is MarketplaceWorld)
            {   
                entity.ForceUpdate(slot);
                SendInfo("You cannot use items while in the Marketplace!");
                Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            var container = entity as IContainer;
            if (this.DistTo(entity) > 3)
            {
                entity.ForceUpdate(slot);
                Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            var containerInventory = container?.Inventory.CreateTransaction();

            // get item
            Item item = null;
            foreach (var stack in PotionStacks.Where(stack => stack.Slot == slot))
            {
                item = stack.Pop();
                if (item == null)
                    return;
                break;
            }

            if (item == null)
            {
                if (container == null)
                    return;
                item = containerInventory[slot];
            }

            if (item == null)
                return;

            if (container is GiftChest)
            {
                entity.ForceUpdate(slot);
                Client.SendPacket(new InvResult() { Result = 1 });
                SendError("Can't use items if they are in a Gift Chest.");
                return;
            }

            // make sure not trading and trying to cunsume item
            if (TradeTarget != null && item.Consumable)
                return;

            if (Mana < item.MpCost)
            {
                Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            // use item
            var slotType = 10;
            if (slot < containerInventory.Length)
            {
                slotType = container.SlotTypes[slot];

                if (item.TypeOfConsumable)
                {
                    var gameData = GameServer.Resources.GameData;
                    var db = GameServer.Database;

                    if (item.Consumable)
                    {
                        Item successor = null;
                        if (item.SuccessorId != null)
                            successor = gameData.Items[gameData.IdToObjectType[item.SuccessorId]];
                        containerInventory[slot] = successor;

                        if (container is GiftChest)
                        {
                            var trans = db.Conn.CreateTransaction();

                            if (successor != null)
                                db.SwapGift(Client.Account, item.ObjectType, successor.ObjectType, trans);
                            else
                                db.RemoveGift(Client.Account, item.ObjectType, trans);
                            trans.Execute();
                        }
                    }

                    if (!Inventory.Execute(containerInventory)) // can result in the loss of an item if inv trans fails..
                    {
                        entity.ForceUpdate(slot);
                        return;
                    }

                    if (slotType > 0)
                    {
                        FameCounter.UseAbility();
                    }
                    else
                    {
                        if (item.ActivateEffects.Any(eff => eff.Effect == ActivateEffects.Heal ||
                                                            eff.Effect == ActivateEffects.HealNova ||
                                                            eff.Effect == ActivateEffects.Magic ||
                                                            eff.Effect == ActivateEffects.MagicNova))
                        {
                            FameCounter.DrinkPot();
                        }
                    }

                    Activate(clientTime, time, item, slot, pos, objId, useType);
                    return;
                }

                if (slotType > 0)
                    FameCounter.UseAbility();
            }
            else
                FameCounter.DrinkPot();
            if (item.InvUse || item.Consumable || item.SlotType == slotType)
            {
                Activate(clientTime, time, item, slot, pos, objId, useType);
                if (item.SlotType == slotType)
                    TryAddOnPlayerEffects("ability");
            }
            else
                Client.SendPacket(new InvResult() { Result = 1 });
        }

        public static void HealDiscrete(Player player, int amount, bool magic)
        {
            if (amount <= 0)
                return;

            if (magic)
            {
                var maxMp = player.Stats[1];
                var newMp = Math.Min(maxMp, player.Mana + amount);
                if (newMp == player.Mana)
                    return;
                player.Mana = newMp;
                return;
            }

            var maxHp = player.Stats[0];
            var newHp = Math.Min(maxHp, player.Health + amount);
            if (newHp == player.Health)
                return;

            player.Health = newHp;
        }

        public static void ActivateHealHp(Player player, int amount, bool broadcastSelf = false)
        {
            if (amount <= 0)
                return;

            var maxHp = player.Stats[0];
            var newHp = Math.Min(maxHp, player.Health + amount);
            if (newHp == player.Health)
                return;

            var effect = new ShowEffect()
            {
                EffectType = EffectType.Potion,
                TargetObjectId = player.Id,
                Color = new ARGB(0xffffffff)
            };

            var notif = new Notification()
            {
                Color = new ARGB(0xff00ff00),
                ObjectId = player.Id,
                Message = "+" + (newHp - player.Health)
            };

            if (broadcastSelf)
            {
                player.Client.SendPacket(effect);
                player.Client.SendPacket(notif);

            }
            else
            {
                player.World.BroadcastIfVisible(effect, player);
                player.World.BroadcastIfVisible(notif, player);
            }

            player.Health = newHp;
        }

        public static void ActivateHealMp(Player player, int amount, bool broadcastSelf = false)
        {
            var maxMp = player.Stats[1];
            var newMp = Math.Min(maxMp, player.Mana + amount);
            if (newMp == player.Mana)
                return;

            var effect = new ShowEffect()
            {
                EffectType = EffectType.Potion,
                TargetObjectId = player.Id,
                Color = new ARGB(0xffffffff)
            };

            var notif = new Notification()
            {
                Color = new ARGB(0xff6084E0),
                ObjectId = player.Id,
                Message = "+" + (newMp - player.Mana)
            };

            if (broadcastSelf)
            {
                player.Client.SendPacket(effect);
                player.Client.SendPacket(notif);

            }
            else
            {
                player.World.BroadcastIfVisible(effect, player);
                player.World.BroadcastIfVisible(notif, player);
            }

            player.Mana = newMp;
        }

        private void OnOtherActivate(string param, Item item, Position target)
        {
            ActivateEffect[] effs;
            switch (param)
            {
                case "hit": effs = item.OnPlayerHitActivateEffects; break;
                case "shoot": effs = item.OnPlayerShootActivateEffects; break;
                case "ability": effs = item.OnPlayerAbilityActivateEffects; break;
                default: return;
            }

            foreach (var eff in effs)
            {
                switch (eff.Effect)
                {
                    case ActivateEffects.GenericActivate:
                        AEGenericActivate(item, target, eff);
                        break;
                    case ActivateEffects.Shoot: break; // handled in PlayerShoot.cs
                    case ActivateEffects.Heal:
                        AEHeal(item, target, eff);
                        break;
                    case ActivateEffects.Magic:
                        AEMagic(item, target, eff);
                        break;
                    case ActivateEffects.HealNova:
                        AEHealNova(item, target, eff);
                        break;
                    case ActivateEffects.StatBoostSelf:
                        AEStatBoostSelf(item, target, eff);
                        break;
                    case ActivateEffects.StatBoostAura:
                        AEStatBoostAura(item, target, eff);
                        break;
                    case ActivateEffects.BulletNova:
                        AEBulletNova(item, target, eff);
                        break;
                    case ActivateEffects.ConditionEffectSelf:
                        AEConditionEffectSelf(item, target, eff);
                        break;
                    case ActivateEffects.ConditionEffectAura:
                        AEConditionEffectAura(item, target, eff);
                        break;
                    case ActivateEffects.Trap:
                        AETrap(item, target, eff);
                        break;
                    case ActivateEffects.StasisBlast:
                        StasisBlast(item, target, eff);
                        break;
                    case ActivateEffects.MagicNova:
                        AEMagicNova(item, target, eff);
                        break;
                    case ActivateEffects.ClearConditionEffectAura:
                        AEClearConditionEffectAura(item, target, eff);
                        break;
                    case ActivateEffects.RemoveNegativeConditions:
                        AERemoveNegativeConditions(item, target, eff);
                        break;
                    case ActivateEffects.ClearConditionEffectSelf:
                        AEClearConditionEffectSelf(item, target, eff);
                        break;
                    case ActivateEffects.RemoveNegativeConditionsSelf:
                        AERemoveNegativeConditionSelf(item, target, eff);
                        break;
                    case ActivateEffects.Pet:
                        AEPet(item, target, eff);
                        break;
                    case ActivateEffects.ObjectToss:
                        AEObjectToss(item, target, eff);
                        break;
                    case ActivateEffects.BulletCreate:
                        SendError($"{eff.Effect} is not yet implemented");
                        break;
                    default:
                        StaticLogger.Instance.Warn("Activate effect {0} not implemented.", eff.Effect);
                        break;
                }
            }
        }

        private void Activate(int clientTime, TickTime time, Item item, int slot, Position target, int objId, int useType)
        {
            Mana -= item.MpCost;

            var entity1 = World.GetEntity(objId);

            if (entity1 is GiftChest)
            {
                SendError("You can't use items in Gift Chests");
                return;
            }

            foreach (var eff in item.ActivateEffects)
            {
                switch (eff.Effect)
                {
                    case ActivateEffects.XPBoost:
                        AEXPBoost(time, item, target, slot, objId, eff);
                        break;
                    case ActivateEffects.LDBoost:
                        AELDBoost(time, item, target, eff);
                        break;
                    case ActivateEffects.GenericActivate:
                        AEGenericActivate(item, target, eff);
                        break;
                    case ActivateEffects.Create:
                        AECreate(time, item, target, slot, eff);
                        break;
                    case ActivateEffects.Dye:
                        AEDye(time, item, target, eff);
                        break;
                    case ActivateEffects.Shoot: break; // handled in PlayerShoot.cs
                    case ActivateEffects.IncrementStat:
                        AEIncrementStat(time, item, target, eff, objId, slot);
                        break;
                    case ActivateEffects.Heal:
                        AEHeal(item, target, eff);
                        break;
                    case ActivateEffects.Magic:
                        AEMagic(item, target, eff);
                        break;
                    case ActivateEffects.HealNova:
                        AEHealNova(item, target, eff);
                        break;
                    case ActivateEffects.StatBoostSelf:
                        AEStatBoostSelf(item, target, eff);
                        break;
                    case ActivateEffects.StatBoostAura:
                        AEStatBoostAura(item, target, eff);
                        break;
                    case ActivateEffects.BulletNova:
                        AEBulletNova(item, target, eff);
                        break;
                    case ActivateEffects.ConditionEffectSelf:
                        AEConditionEffectSelf(item, target, eff);
                        break;
                    case ActivateEffects.ConditionEffectAura:
                        AEConditionEffectAura(item, target, eff);
                        break;
                    case ActivateEffects.Teleport:
                        AETeleport(time, item, target, eff);
                        break;
                    case ActivateEffects.PoisonGrenade:
                        AEPoisonGrenade(time, item, target, eff);
                        break;
                    case ActivateEffects.VampireBlast:
                        AEVampireBlast(time, item, target, eff);
                        break;
                    case ActivateEffects.Trap:
                        AETrap(item, target, eff);
                        break;
                    case ActivateEffects.StasisBlast:
                        StasisBlast(item, target, eff);
                        break;
                    case ActivateEffects.Decoy:
                        AEDecoy(item, target, eff);
                        break;
                    case ActivateEffects.Lightning:
                        AELightning(time, item, target, eff);
                        break;
                    case ActivateEffects.UnlockPortal:
                        AEUnlockPortal(time, item, target, eff);
                        break;
                    case ActivateEffects.MagicNova:
                        AEMagicNova(item, target, eff);
                        break;
                    case ActivateEffects.ClearConditionEffectAura:
                        AEClearConditionEffectAura(item, target, eff);
                        break;
                    case ActivateEffects.RemoveNegativeConditions:
                        AERemoveNegativeConditions(item, target, eff);
                        break;
                    case ActivateEffects.ClearConditionEffectSelf:
                        AEClearConditionEffectSelf(item, target, eff);
                        break;
                    case ActivateEffects.RemoveNegativeConditionsSelf:
                        AERemoveNegativeConditionSelf(item, target, eff);
                        break;
                    case ActivateEffects.ShurikenAbility:
                        AEShurikenAbility(clientTime, time, item, target, eff, useType);
                        break;
                    case ActivateEffects.PermaPet:
                        AEPermaPet(time, item, target, eff);
                        break;
                    case ActivateEffects.Pet:
                        AEPet(item, target, eff);
                        break;
                    case ActivateEffects.Backpack:
                        AEBackpack(time, item, target, slot, objId, eff);
                        break;
                    case ActivateEffects.CreatePortal:
                        AECreatePortal(time, item, target, slot, eff);
                        break;
                    case ActivateEffects.ObjectToss:
                        AEObjectToss(item, target, eff);
                        break;
                    case ActivateEffects.LevelTwenty:
                    case ActivateEffects.Unlock:
                    case ActivateEffects.MarkAndTeleport:
                    case ActivateEffects.SelfTransform:
                    case ActivateEffects.GroupTransform:
                    case ActivateEffects.Exchange:
                    case ActivateEffects.ChangeObject:
                    case ActivateEffects.UnlockPetSkin:
                    case ActivateEffects.CreatePet:
                    case ActivateEffects.TeleportToObject:
                    case ActivateEffects.MysteryPortal:
                    case ActivateEffects.KillRealmHeroes:
                    case ActivateEffects.BulletCreate:
                        SendError($"{eff.Effect} is not yet implemented");
                        break;
                    default:
                        StaticLogger.Instance.Warn("Activate effect {0} not implemented.", eff.Effect);
                        break;
                }
            }
        }

        private void AEObjectToss(Item item, Position target, ActivateEffect eff)
        {
            GameServer.Resources.GameData.IdToObjectType.TryGetValue(eff.Id, out ushort objType);
            var throwTime = eff.ThrowTime == 0 ? 1000 : eff.ThrowTime;
            if (eff.ThrowTime != -1)
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.Throw,
                    Color = new ARGB(eff.Color != 0 ? eff.Color : 0xffffffff),
                    TargetObjectId = Id,
                    Pos1 = target,
                    Duration = throwTime / 1000
                }, this);
            }

            var x = new Placeholder(GameServer, eff.ThrowTime * 1000);
            x.Move(target.X, target.Y);
            World.EnterWorld(x);

            World.StartNewTimer(eff.ThrowTime == -1 ? 1 : throwTime, (world, t) =>
            {
                world.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    Color = new ARGB(eff.Color != 0 ? eff.Color : 0xffffffff),
                    TargetObjectId = x.Id,
                    Pos1 = new Position() { X = eff.Radius },
                    Pos2 = new Position() { X = Id, Y = 255 }
                }, x);

                Entity entity = Resolve(World.GameServer, objType);
                if (entity == null)
                    return;
                if (entity is Enemy en)
                {
                    en.ApplyConditionEffect(ConditionEffectIndex.Invincible, -1);
                    en.Move(target.X, target.Y);
                    World.EnterWorld(en);
                } else
                {
                    entity.Move(target.X, target.Y);
                    World.EnterWorld(entity);
                }
            });
        }
        private void AEBackpack(TickTime time, Item item, Position target, int slot, int objId, ActivateEffect eff)
        {
            var entity = World.GetEntity(objId);
            var containerItem = entity as Container;
            if (HasBackpack)
            {
                if (containerItem != null)
                    containerItem.Inventory[slot] = item;
                else
                    Inventory[slot] = item;
                return;
            }
            HasBackpack = true;
        }

        private void AEBulletNova(Item item, Position target, ActivateEffect eff)
        {
            var numShots = eff.NumShots == 0 ? 20 : eff.NumShots;
            var projectileDesc = item.Projectiles[0];

            var shoots = new List<OutgoingMessage>(numShots);
            var allyShoots = new List<OutgoingMessage>(numShots);
            for (var i = 0; i < numShots; i++)
            {
                var nextBulletId = GetNextBulletId(1, true);

                var angle = (float)(i * (Math.PI * 2) / numShots);
                Console.WriteLine(angle);

                var damage = Random.Shared.Next(projectileDesc.MinDamage, projectileDesc.MaxDamage);
                shoots.Add(new ServerPlayerShoot(nextBulletId, Id, item.ObjectType, target, angle, damage, item.ObjectType, projectileDesc));
            }

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.Trail,
                Pos1 = target,
                TargetObjectId = Id,
                Color = new ARGB(eff.Color != 0 ? eff.Color : 0xFFFF00AA)
            }, this);
            World.BroadcastIfVisible(shoots, ref target);
        }

        private void AEClearConditionEffectAura(Item item, Position target, ActivateEffect eff)
        {
            this.AOE(eff.Range, true, player =>
            {
                var condition = eff.CheckExistingEffect;
                ConditionEffectIndex conditions = 0;
                conditions |= (ConditionEffectIndex)(1 << (Byte)condition.Value);
                if (!condition.HasValue || player.HasConditionEffect(conditions))
                    player.RemoveCondition(eff.ConditionEffect.Value);
            });
        }

        private void AEClearConditionEffectSelf(Item item, Position target, ActivateEffect eff)
        {
            var condition = eff.CheckExistingEffect;
            ConditionEffectIndex conditions = 0;

            if (condition.HasValue)
                conditions |= (ConditionEffectIndex)(1 << (Byte)condition.Value);

            if (!condition.HasValue || HasConditionEffect(conditions))
                RemoveCondition(eff.ConditionEffect.Value);
        }

        private void AEConditionEffectAura(Item item, Position target, ActivateEffect eff)
        {
            var duration = eff.DurationMS;
            var range = eff.Range;
            if (eff.UseWisMod)
            {
                duration = (int)(UseWisMod(eff.DurationSec) * 1000);
                range = UseWisMod(eff.Range);
            }

            this.AOE(range, true, player =>
            {
                player.ApplyConditionEffect(new ConditionEffect(eff.ConditionEffect.Value, duration));
            });

            var color = 0xffffffff;
            if (eff.ConditionEffect.Value == ConditionEffectIndex.Damaging)
                color = 0xffff0000;
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(color),
                Pos1 = new Position() { X = range }
            }, this);
        }

        private void AEConditionEffectSelf(Item item, Position target, ActivateEffect eff)
        {
            var duration = eff.DurationMS;
            if (eff.UseWisMod)
                duration = (int)(UseWisMod(eff.DurationSec) * 1000);

            ApplyConditionEffect(new ConditionEffect(eff.ConditionEffect.Value, duration));
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = 1 }
            }, this);
        }

        private void AECreate(TickTime time, Item item, Position target, int slot, ActivateEffect eff)
        {
            var gameData = GameServer.Resources.GameData;

            if (!gameData.IdToObjectType.TryGetValue(eff.Id, out ushort objType) ||
                !gameData.Portals.ContainsKey(objType))
                return; // object not found, ignore

            var entity = Resolve(GameServer, objType);
            var timeoutTime = gameData.Portals[objType].Timeout;

            entity.Move(X, Y);
            World.EnterWorld(entity);

            World.StartNewTimer(timeoutTime * 1000, (world, t) => world.LeaveWorld(entity));

            var openedByMsg = gameData.Portals[objType].DungeonName + " opened by " + Name + "!";
            World.Broadcast(new Notification
            {
                Color = new ARGB(0xFF00FF00),
                ObjectId = Id,
                Message = openedByMsg
            });
            World.ForeachPlayer(_ => _.SendInfo(openedByMsg));
        }

        private void AECreatePortal(TickTime time, Item item, Position target, int slot, ActivateEffect eff)
        {
            var gameData = GameServer.Resources.GameData;

            if (!gameData.IdToObjectType.TryGetValue(eff.Id, out ushort objType) ||
                !gameData.Portals.ContainsKey(objType))
                return; // object not found, ignore

            var entity = Resolve(GameServer, objType);
            var timeoutTime = gameData.Portals[objType].Timeout;

            entity.Move(X, Y);
            World.EnterWorld(entity);

            World.StartNewTimer(timeoutTime * 1000, (world, t) => world.LeaveWorld(entity));

            var openedByMsg = gameData.Portals[objType].DungeonName + " opened by " + Name + "!";
            World.Broadcast(new Notification
            {
                Color = new ARGB(0xFF00FF00),
                ObjectId = Id,
                Message = openedByMsg
            });
            World.ForeachPlayer(_ => _.SendInfo(openedByMsg));
        }

        private void AEDecoy(Item item, Position target, ActivateEffect eff)
        {
            var facing = MathF.Atan2(Y - PrevY, X - PrevX);

            var decoy = new Decoy(this, eff.DurationMS, facing, false);
            decoy.Move(X, Y);
            World.EnterWorld(decoy);

            var numShots = eff.NumShots;
            if (eff.NumShots != 0)
            {
                World.StartNewTimer(eff.DurationMS - 5, (world, t) =>
                {
                    var shots = new List<OutgoingMessage>();
                    for (var i = 0; i < numShots; i++)
                    {
                        var nextBulletId = GetNextBulletId(1, true);
                        var projectileDesc = item.Projectiles[0];
                        var angle = (float)(i * (Math.PI * 2) / numShots);

                        var damage = Random.Shared.Next(projectileDesc.MinDamage, projectileDesc.MaxDamage);

                        shots.Add(new ServerPlayerShoot(nextBulletId, Id, item.ObjectType, decoy.Position, angle, damage, item.ObjectType, projectileDesc));
                    }

                    World.BroadcastIfVisible(shots, ref target);
                });
            }
        }

        private void AEDye(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            if (item.Texture1 != 0)
                Texture1 = item.Texture1;
            if (item.Texture2 != 0)
                Texture2 = item.Texture2;
        }

        private void AEGenericActivate(Item item, Position target, ActivateEffect eff)
        {
            var targetPlayer = eff.Target.Equals("player");
            var centerPlayer = eff.Center.Equals("player");
            var duration = eff.UseWisMod ? (int)(UseWisMod(eff.DurationSec) * 1000) : eff.DurationMS;
            var range = eff.UseWisMod
                ? UseWisMod(eff.Range)
                : eff.Range;

            if (eff.ConditionEffect != null)
                World.AOE(eff.Center.Equals("mouse") ? target : new Position { X = X, Y = Y }, range, targetPlayer, entity =>
                {
                    if (!entity.HasConditionEffect(ConditionEffectIndex.Stasis) && !entity.HasConditionEffect(ConditionEffectIndex.Invincible))
                    {
                        entity.ApplyConditionEffect(eff.ConditionEffect.Value, duration);
                    }
                });

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = (EffectType)eff.VisualEffect,
                TargetObjectId = Id,
                Color = new ARGB(eff.Color),
                Pos1 = centerPlayer ? new Position() { X = range } : target,
                Pos2 = new Position() { X = target.X - range, Y = target.Y }
            }, this);
        }

        private void AEHeal(Item item, Position target, ActivateEffect eff)
        {
            if (HasConditionEffect(ConditionEffectIndex.Sick))
                return;
            ActivateHealHp(this, eff.Amount);
        }

        private void AEHealNova(Item item, Position target, ActivateEffect eff)
        {
            var amount = eff.Amount;
            var range = eff.Range;
            if (eff.UseWisMod)
            {
                amount = (int)UseWisMod(eff.Amount, 0);
                range = UseWisMod(eff.Range);
            }

            this.AOE(range, true, player =>
            {
                if (!player.HasConditionEffect(ConditionEffectIndex.Sick))
                    ActivateHealHp(player as Player, amount);
            });

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = range }
            }, this);
        }

        private void AEIncrementStat(TickTime time, Item item, Position target, ActivateEffect eff, int objId, int slot)
        {
            var idx = StatsManager.GetStatIndex((StatDataType)eff.Stats);
            var statInfo = GameServer.Resources.GameData.Classes[ObjectType].Stats;
            var amount = eff.Amount;

            if (Stats.Base[idx] >= statInfo[idx].MaxValue)
            {
                Stats.Base[idx] = statInfo[idx].MaxValue;
                var inc = idx <= 1 ? eff.Amount / 5 : eff.Amount;
                var storedAmount = AttemptToAdd(idx, inc);

                if (storedAmount != -1)
                {
                    string statname = item.DisplayName.Split(' ').Last();
                    bool checkVowel = statname.Substring(0, 1) == "A";
                    string accForVowel = checkVowel ? "n" : "";
                    switch (inc)
                    {
                        case 1:
                            SendInfo($"Added a{accForVowel} {statname} potion to your storage! [{storedAmount}/50]");
                            break;
                        case 2:
                            SendInfo($"Added two {statname} potions to your storage! [{storedAmount}/50]");
                            break;
                        default:
                            SendInfo($"Added multiple {statname} potions to your storage! [{storedAmount}/50]");
                            break;
                    }
                } 
                else
                {
                    var ent = World.GetEntity(objId);
                    if (ent is Container container)
                        container.Inventory[slot] = item;
                    else
                        Inventory[slot] = item;
                    SendError("Your potion storage is full..");
                    return;
                }
            } else
            {
                Stats.Base[idx] += amount;
                if (Stats.Base[idx] >= statInfo[idx].MaxValue)
                    Stats.Base[idx] = statInfo[idx].MaxValue;
                SendInfo($"{item.DisplayName} was consumed");
            }
        }

        private int AttemptToAdd(int idx, int amount)
        {
            var potions = Client.Account.StoredPotions;
            var acc = Client.Account;
            if (potions[idx] < 50)
                potions[idx] += amount;
            else 
                return -1;

            acc.StoredPotions = potions;
            acc.FlushAsync();
            return acc.StoredPotions[idx];
        }

        private void AELDBoost(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            //  if (LDBoostTime < 0 || (LDBoostTime > eff.DurationMS && eff.DurationMS >= 0))
            //      return;

            if (LDBoostTime < 0) //|| (LDBoostTime > eff.DurationMS && eff.DurationMS >= 0))
                return;

            if (LDBoostTime <= 0)
                SendInfo("Your Loot Drop Potion has been activated!");
            if (LDBoostTime > 0)
                SendInfo("Your Loot Drop Potion has been stacked up!");
            LDBoostTime = eff.DurationMS + LDBoostTime;
            InvokeStatChange(StatDataType.LDBoostTime, LDBoostTime / 1000, true);
        }

        private void AELightning(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            const double coneRange = Math.PI / 4;
            var mouseAngle = Math.Atan2(target.Y - Y, target.X - X);

            // get starting target
            var startTarget = this.GetNearestEntity(MAX_ABILITY_DIST, false, e => e is Enemy &&
                Math.Abs(mouseAngle - Math.Atan2(e.Y - Y, e.X - X)) <= coneRange);

            // no targets? bolt air animation
            if (startTarget == null)
            {
                var angles = new double[] { mouseAngle, mouseAngle - coneRange, mouseAngle + coneRange };
                for (var i = 0; i < 3; i++)
                {
                    var x = (int)(MAX_ABILITY_DIST * Math.Cos(angles[i])) + X;
                    var y = (int)(MAX_ABILITY_DIST * Math.Sin(angles[i])) + Y;
                    World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.Trail,
                        TargetObjectId = Id,
                        Color = new ARGB(0xffff0088),
                        Pos1 = new Position()
                        {
                            X = x,
                            Y = y
                        },
                        Pos2 = new Position() { X = 350 }
                    }, ref target);
                }
                return;
            }

            var current = startTarget;
            var targets = new Entity[eff.MaxTargets];
            for (int i = 0; i < targets.Length; i++)
            {
                targets[i] = current;
                var next = current.GetNearestEntity(10, false, e =>
                {
                    if (!(e is Enemy) ||
                        e.HasConditionEffect(ConditionEffectIndex.Invincible) ||
                        e.HasConditionEffect(ConditionEffectIndex.Stasis) ||
                        Array.IndexOf(targets, e) != -1)
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

                var prev = i == 0 ? this : targets[i - 1];

                var damage = eff.UseWisMod ? UseWisMod(eff.TotalDamage) : eff.TotalDamage;

                (targets[i] as Enemy).Damage(this, ref time, (int)damage, false);

                if (eff.ConditionEffect != null)
                    targets[i].ApplyConditionEffect(new ConditionEffect(eff.ConditionEffect.Value, (int)(eff.EffectDuration * 1000)));

                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.Lightning,
                    TargetObjectId = prev.Id,
                    Color = new ARGB(0xffff0088),
                    Pos1 = new Position()
                    {
                        X = targets[i].X,
                        Y = targets[i].Y
                    },
                    Pos2 = new Position() { X = 350 }
                }, this);
            }
        }

        private void AEMagic(Item item, Position target, ActivateEffect eff)
        {
            ActivateHealMp(this, eff.Amount);
        }

        private void AEMagicNova(Item item, Position target, ActivateEffect eff)
        {
            this.AOE(eff.Range, true, player =>
                ActivateHealMp(player as Player, eff.Amount));

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = eff.Range }
            }, this);
        }

        private void AEPet(Item item, Position target, ActivateEffect eff)
        {
            var type = GameServer.Resources.GameData.IdToObjectType[eff.ObjectId];

            var pet = new Pet(GameServer, this, type);
            pet.Move(X, Y);
            World.EnterWorld(pet);
        }

        private void AEPermaPet(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            var type = GameServer.Resources.GameData.IdToObjectType[eff.ObjectId];
            var desc = GameServer.Resources.GameData.ObjectDescs[type];

            PetId = desc.ObjectType;
            SpawnPetIfAttached(World);
        }

        private void AEPoisonGrenade(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            if (MathsUtils.DistSqr(target.X, target.Y, X, Y) > MAX_ABILITY_DIST_SQR) return;
            var impDamage = eff.ImpactDamage;
            if (eff.UseWisMod)
                impDamage = (int)UseWisMod(eff.ImpactDamage);

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.Throw,
                Color = new ARGB(eff.Color != 0 ? eff.Color : 0xffffffff),
                TargetObjectId = Id,
                Pos1 = target,
                Duration = eff.ThrowTime / 1000
            }, this);

            var x = new Placeholder(GameServer, eff.ThrowTime * 1000);
            x.Move(target.X, target.Y);
            World.EnterWorld(x);

            World.StartNewTimer(eff.ThrowTime, (world, t) =>
            {
                world.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    Color = new ARGB(eff.Color != 0 ? eff.Color : 0xffffffff),
                    TargetObjectId = x.Id,
                    Pos1 = new Position() { X = eff.Radius },
                    Pos2 = new Position() { X = Id, Y = 255 }
                }, x);

                world.AOE(target, eff.Radius, false, entity =>
                {
                    PoisonEnemy(world, (Enemy)entity, eff, eff.UseWisMod);
                    ((Enemy)entity).Damage(this, ref time, impDamage, true);
                });
            });
        }

        private void AERemoveNegativeConditions(Item item, Position target, ActivateEffect eff)
        {
            this.AOE(eff.Range, true, player =>
            {
                foreach (var effect in NegativeEffs)
                    player.RemoveCondition(effect);
            });
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = eff.Range }
            }, this);
        }

        private void AERemoveNegativeConditionSelf(Item item, Position target, ActivateEffect eff)
        {
            foreach (var effect in NegativeEffs)
                RemoveCondition(effect);
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = 1 }
            }, this);
        }

        private void AEShurikenAbility(int time, TickTime tickTime, Item item, Position target, ActivateEffect eff, int useType)
        {
            switch (useType)
            {
                case START_USE:
                    ApplyPermanentConditionEffect(ConditionEffectIndex.NinjaSpeedy);
                    break;
                case END_USE:
                    if (Mana >= item.MpEndCost)
                        Mana -= item.MpEndCost;
                    RemoveCondition(ConditionEffectIndex.NinjaSpeedy);
                    break;
            }
        }

        private void AEStatBoostAura(Item item, Position target, ActivateEffect eff)
        {
            var idx = StatsManager.GetStatIndex((StatDataType)eff.Stats);
            var amount = eff.Amount;
            var duration = eff.DurationMS;
            var range = eff.Range;
            if (eff.UseWisMod)
            {
                amount = (int)UseWisMod(eff.Amount, 0);
                duration = (int)(UseWisMod(eff.DurationSec) * 1000);
                range = UseWisMod(eff.Range);
            }

            this.AOE(range, true, player =>
            {
                if (player.HasConditionEffect(ConditionEffectIndex.HpBoost))
                    return;

                ((Player)player).Stats.Boost.ActivateBoost[idx].Push(amount, false);
                ((Player)player).Stats.ReCalculateValues();

                World.StartNewTimer(duration, (world, t) =>
                {
                    ((Player)player).Stats.Boost.ActivateBoost[idx].Pop(amount, false);
                    ((Player)player).Stats.ReCalculateValues();
                });
            });

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff),
                Pos1 = new Position() { X = range }
            }, this);
        }

        private void AEStatBoostSelf(Item item, Position target, ActivateEffect eff)
        {
            var idx = StatsManager.GetStatIndex((StatDataType)eff.Stats);
            var s = eff.Amount;
            var stack = eff.NoStack;
            Stats.Boost.ActivateBoost[idx].Push(s, stack);
            Stats.ReCalculateValues();
            World.StartNewTimer(eff.DurationMS, (world, t) =>
            {
                Stats.Boost.ActivateBoost[idx].Pop(s, stack);
                Stats.ReCalculateValues();
            });

            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.Potion,
                TargetObjectId = Id,
                Color = new ARGB(0xffffffff)
            }, this);
        }

        private void AETeleport(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            TeleportPosition(time, target, true);
        }

        private void AETrap(Item item, Position target, ActivateEffect eff)
        {
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.Throw,
                Color = new ARGB(0xff9000ff),
                TargetObjectId = Id,
                Pos1 = target
            }, ref target);

            World.StartNewTimer(1500, (world, t) =>
            {
                var trap = new Trap(this, eff.Radius, eff.TotalDamage, eff.ConditionEffect ?? ConditionEffectIndex.Slowed, eff.EffectDuration);
                trap.Move(target.X, target.Y);
                world.EnterWorld(trap);
            });
        }

        private void AEUnlockPortal(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            //var gameData = CoreServerManager.Resources.GameData;

            //// find locked portal
            //var portals = World.StaticObjects
            //    .Values.Where(_ => _ is Portal
            //    && _.ObjectDesc.ObjectId.Equals(eff.LockedName)
            //    && _.DistSqr(this) <= 9d)
            //    .Select(_ => _ as Portal);
            //if (!portals.Any())
            //    return;
            //var portal = portals.Aggregate(
            //    (curmin, x) => curmin == null || x.DistSqr(this) < curmin.DistSqr(this) ? x : curmin);
            //if (portal == null)
            //    return;

            //// get proto of world
            //if (!CoreServerManager.Resources.Worlds.Data.TryGetValue(eff.DungeonName, out ProtoWorld proto))
            //{
            //    SLogger.Instance.Error("Unable to unlock portal. \"" + eff.DungeonName + "\" does not exist.");
            //    return;
            //}

            //if (proto.portals == null || proto.portals.Length < 1)
            //{
            //    SLogger.Instance.Error("World is not associated with any portals.");
            //    return;
            //}

            //// create portal of unlocked world
            //var portalType = (ushort)proto.portals[0];
            //if (!(Resolve(CoreServerManager, portalType) is Portal uPortal))
            //{
            //    SLogger.Instance.Error("Error creating portal: {0}", portalType);
            //    return;
            //}

            //var portalDesc = gameData.Portals[portal.ObjectType];
            //var uPortalDesc = gameData.Portals[portalType];

            //// create world
            //World world;
            //if (proto.id < 0)
            //    world = CoreServerManager.WorldManager.GetWorld(proto.id);
            //else
            //{
            //    DynamicWorld.TryGetWorld(proto, Client, out world);
            //    world = CoreServerManager.WorldManager.CreateNewWorld(world ?? new World(proto));
            //}
            //uPortal.WorldInstance = world;

            //// swap portals
            //if (!portalDesc.NexusPortal || !CoreServerManager.WorldManager.PortalMonitor.RemovePortal(portal))
            //    World.LeaveWorld(portal);
            //uPortal.Move(portal.X, portal.Y);
            //uPortal.Name = uPortalDesc.DisplayId;
            //var uPortalPos = new Position() { X = portal.X - .5f, Y = portal.Y - .5f };
            //if (!uPortalDesc.NexusPortal || !CoreServerManager.WorldManager.PortalMonitor.AddPortal(world.Id, uPortal, uPortalPos))
            //    World.EnterWorld(uPortal);

            //// setup timeout
            //if (!uPortalDesc.NexusPortal)
            //{
            //    var timeoutTime = gameData.Portals[portalType].Timeout;
            //    World.Timers.Add(new WorldTimer(timeoutTime * 1000, (w, t) => w.LeaveWorld(uPortal)));
            //}

            //// announce
            //World.Broadcast(new Notification
            //{
            //    Color = new ARGB(0xFF00FF00),
            //    ObjectId = Id,
            //    Message = "Unlocked by " + Name
            //});
            //World.PlayersBroadcastAsParallel(_ => _.SendInfo($"{world.SBName} unlocked by {Name}!"));
        }

        private void AEVampireBlast(TickTime time, Item item, Position target, ActivateEffect eff)
        {
            var pkts = new List<OutgoingMessage>()
            {
                new ShowEffect()
                {
                    EffectType = EffectType.Trail,
                    TargetObjectId = Id,
                    Pos1 = target,
                    Color = new ARGB(0xFFFF0000)
                },
                new ShowEffect
                {
                    EffectType = EffectType.Diffuse,
                    Color = new ARGB(0xFFFF0000),
                    TargetObjectId = Id,
                    Pos1 = target,
                    Pos2 = new Position { X = target.X + eff.Radius, Y = target.Y }
                }
            };

            World.BroadcastIfVisible(pkts[0], ref target);
            World.BroadcastIfVisible(pkts[1], ref target);

            var totalDmg = 0;
            var effDamage = eff.UseWisMod ? UseWisMod(eff.TotalDamage) : eff.TotalDamage;
            var enemies = new List<Enemy>();

            World.AOE(target, eff.Radius, false, enemy =>
            {
                enemies.Add(enemy as Enemy);
                totalDmg += (enemy as Enemy).Damage(this, ref time, (int)effDamage, false);
            });

            var players = new List<Player>();
            this.AOE(eff.Radius, true, player =>
            {
                if (!player.HasConditionEffect(ConditionEffectIndex.Sick))
                {
                    players.Add(player as Player);
                    ActivateHealHp(player as Player, totalDmg);
                }
            });

            if (enemies.Count > 0 && players.Count > 0)
            {
                for (var i = 0; i < 5; i++)
                {
                    var a = Random.Shared.NextLength(enemies);
                    var b = Random.Shared.NextLength(players);

                    World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.Flow,
                        TargetObjectId = b.Id,
                        Pos1 = new Position() { X = a.X, Y = a.Y },
                        Color = new ARGB(0xffffffff)
                    }, ref target);
                }
            }
        }

        private void AEXPBoost(TickTime time, Item item, Position target, int slot, int objId, ActivateEffect eff)
        {
            if (XPBoostTime < 0 || (XPBoostTime > eff.DurationMS && eff.DurationMS >= 0))
                return;

            var entity = World.GetEntity(objId);
            var containerItem = entity as Container;

            if (XPBoostTime > 0 && XPBoosted)
            {
                SendInfo("You already have an XP Booster activated!");
                if (containerItem != null)
                    containerItem.Inventory[slot] = item;
                else
                    Inventory[slot] = item;
                return;
            }
            if (Level >= 20)
            {
                SendInfo("You're level 20!");
                if (containerItem != null)
                    containerItem.Inventory[slot] = item;
                else
                    Inventory[slot] = item;
                return;
            }
            XPBoostTime = eff.DurationMS;
            XPBoosted = true;
            InvokeStatChange(StatDataType.XPBoostTime, XPBoostTime / 1000, true);
        }

        private void AEHealingPoison(World world, Player player, ActivateEffect eff)
        {
            var remainingHeal = eff.TotalDamage;
            var perHeal = eff.TotalDamage * 1000 / eff.DurationMS;

            WorldTimer tmr = null;
            var x = 0;

            bool healTick(World w, TickTime t)
            {
                if (player.World == null || w == null)
                    return true;

                if (x % 4 == 0) // make sure to change this if timer delay is changed
                {
                    var thisHeal = perHeal;
                    if (remainingHeal < thisHeal)
                        thisHeal = remainingHeal;

                    ActivateHealHp(player, thisHeal);

                    remainingHeal -= thisHeal;
                    if (remainingHeal <= 0)
                        return true;
                }
                x++;

                tmr.Reset();
                return false;
            }

            tmr = world.StartNewTimer(200, healTick);
        }

        private void PoisonEnemy(World world, Enemy enemy, ActivateEffect eff, bool poisonWis)
        {
            var remainingDmg = StatsManager.DamageWithDefense(enemy, eff.TotalDamage, false, enemy.Defense);
            var perDmg = remainingDmg * 1000 / eff.DurationMS;

            if (poisonWis)
            {
                remainingDmg = (int)UseWisMod(remainingDmg);
                perDmg = (int)UseWisMod(perDmg);
            }

            WorldTimer tmr = null;
            var x = 0;

            bool poisonTick(World w, TickTime t)
            {
                if (x % 4 == 0)
                {
                    var thisDmg = perDmg;
                    if (remainingDmg < thisDmg)
                        thisDmg = remainingDmg;

                    if (enemy.Dead)
                        return false;

                    enemy?.Damage(this, ref t, thisDmg, true);
                    remainingDmg -= thisDmg;
                    if (remainingDmg <= 0)
                        return true;
                }
                x++;

                tmr.Reset();
                return false;
            }

            tmr = world.StartNewTimer(200, poisonTick);
        }

        private void StasisBlast(Item item, Position target, ActivateEffect eff)
        {
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.Concentrate,
                TargetObjectId = Id,
                Pos1 = target,
                Pos2 = new Position() { X = target.X + 3, Y = target.Y },
                Color = new ARGB(0xffffffff)
            }, ref target);

            World.AOE(target, 3, false, (Action<Entity>)(enemy =>
            {
                if (enemy.HasConditionEffect(ConditionEffectIndex.StasisImmune))
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        ObjectId = enemy.Id,
                        Color = new ARGB(0xff00ff00),
                        Message = "Immune",
                        PlayerId = Id
                    }, enemy);
                }
                else if (!enemy.HasConditionEffect(ConditionEffectIndex.Stasis) && !enemy.HasConditionEffect(ConditionEffectIndex.StasisImmune))
                {
                    enemy.ApplyConditionEffect(ConditionEffectIndex.Stasis, eff.DurationMS);

                    World.StartNewTimer(eff.DurationMS - 200, (Action<World, TickTime>)((world, t) => enemy.ApplyConditionEffect(ConditionEffectIndex.StasisImmune, 3200)));

                    World.BroadcastIfVisible(new Notification()
                    {
                        ObjectId = enemy.Id,
                        Color = new ARGB(0xffff0000),
                        Message = "Stasis",
                        PlayerId = Id
                    }, enemy);
                }
            }));
        }

        private float UseWisMod(float value, int offset = 1)
        {
            double totalWisdom = Stats.Base[7] + Stats.Boost[7];

            if (totalWisdom < 50)
                return value;

            double m = (value < 0) ? -1 : 1;
            double n = (value * totalWisdom / 150) + (value * m);
            n = Math.Floor(n * Math.Pow(100, offset)) / Math.Pow(100, offset);
            if (n - (int)n * m >= 1 / Math.Pow(100, offset) * m)
            {
                return ((int)(n * 10)) / 10.0f;
            }

            return (int)n;
        }
    }
}
