using System;
using System.Collections.Generic;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class Grenade : Behavior
    {
        private readonly uint color;
        private readonly Cooldown coolDown;
        private readonly int damage;
        private readonly ConditionEffectIndex effect;
        private readonly int effectDuration;
        private readonly double? fixedAngle;
        private readonly float radius;
        private readonly double range;

        public Grenade(double radius, int damage, double range = 5, double? fixedAngle = null, Cooldown coolDown = new Cooldown(), ConditionEffectIndex effect = 0, int effectDuration = 0, uint color = 0xffff0000)
        {
            this.radius = (float)radius;
            this.damage = damage;
            this.range = range;
            this.fixedAngle = fixedAngle * Math.PI / 180;
            this.coolDown = coolDown.Normalize();
            this.effect = effect;
            this.effectDuration = effectDuration;
            this.color = color;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = 0;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var pkts = new List<OutgoingMessage>();
            var cool = (int)state;

            if (cool <= 0)
            {
                if (host.HasConditionEffect(ConditionEffectIndex.Stunned))
                    return;

                var enemy = host as Enemy;
                var enemyClasified = enemy.Legendary ? 50 : enemy.Epic ? 25 : enemy.Rare ? 10 : 0;
                var player = host.AttackTarget ?? host.GetNearestEntity(range, true);

                if (player != null || fixedAngle != null)
                {
                    var target = fixedAngle != null ? new Position() { X = (float)(range * Math.Cos(fixedAngle.Value)) + host.X, Y = (float)(range * Math.Sin(fixedAngle.Value)) + host.Y }
                    : new Position() { X = player.X, Y = player.Y };

                    host.World.BroadcastIfVisible(new ShowEffect() { EffectType = EffectType.Throw, Color = new ARGB(color), TargetObjectId = host.Id, Pos1 = target, Pos2 = new Position() { X = 222 } }, host);
                    host.World.StartNewTimer(1500, (world, t) =>
                    {
                        var aoe = new AoeMessage(target, radius, damage + enemyClasified, 0, 0, host.ObjectType, new ARGB(color));
                        world.BroadcastIfVisible(aoe, host);

                        world.AOE(target, radius, true, p =>
                        {
                            (p as IPlayer).Damage(damage + enemyClasified, host);
                            if (!p.HasConditionEffect(ConditionEffectIndex.Invincible) && !p.HasConditionEffect(ConditionEffectIndex.Stasis))
                                p.ApplyConditionEffect(new ConditionEffect(effect, effectDuration));
                        });
                    });
                }
                cool = coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
