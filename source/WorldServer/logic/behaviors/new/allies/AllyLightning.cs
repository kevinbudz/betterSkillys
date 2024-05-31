using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    public class AllyLightning : Behavior
    {
        private readonly uint _color;
        private readonly int _damage;
        private readonly float _coolDown;
        public AllyLightning(int damage, uint color, int cooldown = 0) 
        {
            _color = color;
            _damage = damage;
            _coolDown = cooldown;
        }
        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = _coolDown;
        }
        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int?)state ?? -1;
            if (cool <= 0)
            {
                const double coneRange = Math.PI / 4;

                // get starting target
                var entAngle = 0;
                var startTarget = host.GetNearestEntity(10, false, e => e is Enemy &&
                    Math.Abs(entAngle - Math.Atan2(e.Y - host.Y, e.X - host.X)) <= coneRange);

                if (startTarget == null)
                    return;

                var current = startTarget;
                var targets = new Entity[5];
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

                    var prev = i == 0 ? host : targets[i - 1];

                    var damage = _damage;

                    var player = host.World.Players.GetValueOrDefault(host.AllyOwnerId);
                    if (player == null)
                        return;
                    (targets[i] as Enemy).Damage(player, ref time, (int)damage, false);

                    host.World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.Lightning,
                        TargetObjectId = prev.Id,
                        Color = _color != 0 ? new ARGB(_color) : new ARGB(0xffff0088),
                        Pos1 = new Position()
                        {
                            X = targets[i].X,
                            Y = targets[i].Y
                        },
                        Pos2 = new Position() { X = 350 }
                    }, host);
                }
            }
            else
                cool -= time.ElapsedMsDelta;
            state = cool;
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
        }
    }
}
