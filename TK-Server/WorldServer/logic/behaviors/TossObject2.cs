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
    internal class TossObject2 : Behavior
    {
        private readonly ushort child;
        private readonly int coolDownOffset;
        private readonly bool randomToss;
        private readonly double range;
        private double? angle;
        private Cooldown coolDown;

        public TossObject2(string child, double range = 5, double? angle = null, Cooldown coolDown = new Cooldown(), int coolDownOffset = 0, bool randomToss = false)
        {
            this.child = BehaviorDb.InitGameData.IdToObjectType[child];
            this.range = range;
            this.angle = angle * Math.PI / 180;
            this.coolDown = coolDown.Normalize();
            this.coolDownOffset = coolDownOffset;
            this.randomToss = randomToss;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = coolDownOffset;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
            {
                if (host.HasConditionEffect(ConditionEffectIndex.Stunned))
                    return;

                var tossAngle = randomToss ? Random.Next(0, 360) * Math.PI / 180 : angle;

                Entity en = null;

                if (tossAngle == null)
                    en = host.GetNearestEntity(range, null);

                if (tossAngle == null && en == null)
                    return;

                var target = tossAngle == null ? new Position(en.X, en.Y) : new Position(host.X + (float)(range * Math.Cos(tossAngle.Value)), host.Y + (float)(range * Math.Sin(tossAngle.Value)));

                host.World.Broadcast(new ShowEffect
                {
                    EffectType = EffectType.Throw,
                    Color = new ARGB(0xffffbf00),
                    TargetObjectId = host.Id,
                    Pos1 = target
                });

                host.World.StartNewTimer(1500, (world, t) =>
                {
                    var entity = Entity.Resolve(world.GameServer, child);
                    entity.Move(target.X, target.Y);

                    if (entity is Enemy && host is Enemy)
                        (entity as Enemy).Terrain = (host as Enemy).Terrain;

                    world.EnterWorld(entity);
                });

                cool = coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
