using System;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class MarbleSeal : Behavior
    {
        private readonly int amount;
        private readonly double range;
        private Cooldown coolDown;

        public MarbleSeal(double range, int amount, Cooldown coolDown = new Cooldown())
        {
            this.range = (float)range;
            this.amount = amount;
            this.coolDown = coolDown.Normalize();
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = 0;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;
            var ents = host.GetNearestEntities(range, null);

            foreach (var en in ents)
                if (en is Player p)
                {
                    p.ApplyConditionEffect(ConditionEffectIndex.Damaging, 500);
                    p.ApplyConditionEffect(ConditionEffectIndex.Armored, 500);
                }

            if (cool <= 0)
            {
                foreach (var en in ents)
                {
                    if (en is Player p)
                    {
                        if (host.AttackTarget != null && host.AttackTarget != p || p.HasConditionEffect(ConditionEffectIndex.Sick))
                            continue;

                        var maxHp = p.Stats[0];
                        var newHp = Math.Min(p.Health + 50, maxHp);

                        if (newHp != p.Health)
                        {
                            var n = newHp - p.Health;

                            p.Health = newHp;
                            p.World.BroadcastIfVisible(new ShowEffect() { EffectType = EffectType.Potion, TargetObjectId = p.Id, Color = new ARGB(0xffffffff) }, p);
                            p.World.BroadcastIfVisible(new ShowEffect()
                            {
                                EffectType = EffectType.Trail,
                                TargetObjectId = host.Id,
                                Pos1 = new Position { X = p.X, Y = p.Y },
                                Color = new ARGB(0xffffffff)
                            }, host);
                            p.World.BroadcastIfVisible(new Notification()
                            { ObjectId = p.Id, Message = "+" + n, Color = new ARGB(0xff00ff00) }, p);
                        }
                    }
                }

                cool = coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;

            cool = coolDown.Next(Random);

            return;
        }
    }
}
