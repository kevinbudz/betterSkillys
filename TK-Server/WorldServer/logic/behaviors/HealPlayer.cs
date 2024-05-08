using System;
using System.Linq;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class HealPlayer : Behavior
    {
        private readonly int _healAmount;
        private readonly double _range;
        private Cooldown _coolDown;

        public HealPlayer(double range, Cooldown coolDown = new Cooldown(), int healAmount = 100)
        {
            _range = range;
            _coolDown = coolDown.Normalize();
            _healAmount = healAmount;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = 0;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
            {
                foreach (var entity in host.GetNearestEntities(_range, null, true).OfType<Player>())
                {
                    if (entity == null || entity.World == null)
                        continue;

                    if (host.AttackTarget != null && host.AttackTarget != entity || entity.HasConditionEffect(ConditionEffectIndex.Sick))
                        continue;

                    var maxHp = entity.Stats[0];
                    var newHp = Math.Min(entity.HP + _healAmount, maxHp);

                    if (newHp != entity.HP)
                    {
                        var n = newHp - entity.HP;

                        entity.HP = newHp;
                        entity.World.BroadcastIfVisible(new ShowEffect() { EffectType = EffectType.Potion, TargetObjectId = entity.Id, Color = new ARGB(0xffffffff) }, entity);
                        entity.World.BroadcastIfVisible(new ShowEffect()
                        {
                            EffectType = EffectType.Trail,
                            TargetObjectId = host.Id,
                            Pos1 = new Position { X = entity.X, Y = entity.Y },
                            Color = new ARGB(0xffffffff)
                        }, host);
                        entity.World.BroadcastIfVisible(new Notification() { ObjectId = entity.Id, Message = "+" + n, Color = new ARGB(0xff00ff00) }, entity);
                    }
                }

                cool = _coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
