using System;
using System.Collections.Generic;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    internal class Decoy : StaticObject, IPlayer
    {
        private readonly Player _player;
        private readonly int _duration;

        private Vector2 _direction;
        private bool _exploded = false;

        public Decoy(Player player, int duration, float angle) 
            : base(player.GameServer, 0x0715, duration, true, true, true)
        {
            _player = player;
            _duration = duration;
            _direction = new Vector2(MathF.Cos(angle), MathF.Sin(angle));
        }

        public bool IsVisibleToEnemy() => true;
        public void Damage(int dmg, Entity src) { }

        public override void Tick(ref TickTime time)
        {
            if (Health > _duration - 2000)
                ValidateAndMove(X + _direction.X * time.BehaviourTickTime, Y + _direction.Y * time.BehaviourTickTime);

            if (Health < 250 && !_exploded)
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    Color = new ARGB(0xffff0000),
                    TargetObjectId = Id,
                    Pos1 = new Position() { X = 1 }
                }, this);

                _exploded = true;
            }

            base.Tick(ref time);
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.Texture1] = _player.Texture1;
            stats[StatDataType.Texture2] = _player.Texture2;
            base.ExportStats(stats, isOtherPlayer);
        }
    }
}
