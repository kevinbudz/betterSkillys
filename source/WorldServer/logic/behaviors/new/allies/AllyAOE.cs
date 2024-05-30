using Shared.resources;
using System;
using System.Drawing;
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
    internal class AllyAOE : Behavior
    {
        private readonly uint _color;
        private readonly int _damage;
        private readonly float _radius;

        public AllyAOE(int damage, float radius, uint color = 0) 
        {
            _damage = damage;
            _radius = radius;
            _color = color;
        }
        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var world = host.World;
            world.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                Color = new ARGB(_color != 0 ? _color : 0xffffffff),
                TargetObjectId = host.Id,
                Pos1 = new Position() { X = _radius },
                Pos2 = new Position() { X = host.Id, Y = 255 }
            }, host);
            world.AOE(host.Position, _radius, false, entity =>
            {
                ((Enemy)entity).Damage(host.AttackTarget, ref time, _damage, true);
            });
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
        }
    }
}
