using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class InvisiToss : Behavior
    {
        private readonly ushort child;
        private readonly int coolDownOffset;
        private readonly double range;
        private double? angle;
        private Cooldown coolDown;

        public InvisiToss(string child, double range = 5, double? angle = null, Cooldown coolDown = new Cooldown(), int coolDownOffset = 0)
        {
            this.child = BehaviorDb.InitGameData.IdToObjectType[child];
            this.range = range;
            this.angle = angle * Math.PI / 180;
            this.coolDown = coolDown.Normalize();
            this.coolDownOffset = coolDownOffset;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = coolDownOffset;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
            {
                if (host.HasConditionEffect(ConditionEffectIndex.Stunned))
                    return;

                var target = new Position { X = host.X + (float)(range * Math.Cos(angle.Value)), Y = host.Y + (float)(range * Math.Sin(angle.Value)) };

                var entity = Entity.Resolve(host.GameServer, child);

                if (host.Spawned)
                    entity.Spawned = true;

                entity.Move(target.X, target.Y);
                (entity as Enemy).Terrain = (host as Enemy).Terrain;

                host.World.EnterWorld(entity);

                cool = coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
