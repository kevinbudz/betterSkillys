using Shared.resources;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using WorldServer.core;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class AllyDamage : Behavior
    {
        private readonly int _damage;
        private readonly int _radius;
        private readonly int _coolDown;

        public AllyDamage(int damage, int radius, int cooldown)
        {
            _damage = damage;
            _radius = radius;
            _coolDown = cooldown;
        }
        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = _coolDown;
        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            int cool = (int)state;
            if (cool <= 0)
            {
                var player = host.World.Players.GetValueOrDefault(host.AllyOwnerId);
                if (player == null)
                    return;
                foreach (var entity in host.GetNearestEntities(_radius, 0, false))
                {
                    if (entity is Enemy en)
                        en.Damage(player, ref time, _damage, false);
                }
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
