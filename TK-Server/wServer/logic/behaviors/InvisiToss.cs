﻿using common.resources;
using System;
using wServer.core;
using wServer.core.objects;

namespace wServer.logic.behaviors
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
                if (host.HasConditionEffect(ConditionEffects.Stunned))
                    return;

                var target = new Position { X = host.X + (float)(range * Math.Cos(angle.Value)), Y = host.Y + (float)(range * Math.Sin(angle.Value)) };

                host.World.Timers.Add(new WorldTimer(0, (world, t) =>
                {
                    var entity = Entity.Resolve(world.GameServer, child);

                    if (host.Spawned)
                        entity.Spawned = true;

                    entity.Move(target.X, target.Y);
                    (entity as Enemy).Terrain = (host as Enemy).Terrain;

                    world.EnterWorld(entity);
                }));

                cool = coolDown.Next(Random);
            }
            else
                cool -= time.ElaspedMsDelta;

            state = cool;
        }
    }
}
