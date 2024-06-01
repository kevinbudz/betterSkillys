using Shared.resources;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using WorldServer.core;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;
using static System.Net.Mime.MediaTypeNames;

namespace WorldServer.logic.behaviors
{
    internal class AllyAOE : Behavior
    {
        private readonly uint _color;
        private readonly int _minDamage;
        private readonly int _maxDamage;
        private readonly float _radius;
        private readonly int _coolDown;

        public AllyAOE(int minDamage, int maxDamage, float radius, uint color = 0, int cooldown = 0) 
        {
            _minDamage = minDamage;
            _maxDamage = maxDamage;
            _radius = radius;
            _color = color;
            _coolDown = cooldown;
        }
        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = _coolDown;
        }
        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;
            if (cool <= 0)
            {
                if (host == null)
                    return;
                var world = host.World;
                world.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    Color = new ARGB(_color != 0 ? _color : 0xffffffff),
                    TargetObjectId = host.Id,
                    Pos1 = new Position() { X = _radius },
                    Pos2 = new Position() { X = host.Id, Y = 255 }
                }, host);

                var player = host.World.Players.GetValueOrDefault(host.AllyOwnerId);
                if (player == null)
                    return;
                world.AOE(host.Position, _radius, false, entity =>
                {
                    if (entity is Enemy en)
                        en.Damage(player, ref time, Random.Next(_minDamage, _maxDamage), true);
                });
                cool = _coolDown;
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
