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
        private readonly int Duration;

        private Vector2 direction;
        private bool exploded = false;
        private Player Player;

        public Decoy(Player player, int duration) : base(player.GameServer, 0x0715, duration, true, true, true)
        {
            Player = player;
            Duration = duration;

            direction = new Vector2(player.X - player.PrevX, player.Y - player.PrevY);
            if (direction.LengthSquared() == 0)
                direction = GetRandDirection();
            else
                direction.Normalize();
        }

        public void Damage(int dmg, Entity src)
        { }

        public bool IsVisibleToEnemy() => true;

        public override void Tick(ref TickTime time)
        {
            if (HP > Duration - 2000)
                ValidateAndMove(X + direction.X * 1.0f * time.BehaviourTickTime, Y + direction.Y * 1.0f * time.BehaviourTickTime);

            if (HP < 250 && !exploded)
            {
                exploded = true;

                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.AreaBlast,
                    Color = new ARGB(0xffff0000),
                    TargetObjectId = Id,
                    Pos1 = new Position() { X = 1 }
                }, this);
            }

            base.Tick(ref time);
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.Texture1] = Player.Texture1;
            stats[StatDataType.Texture2] = Player.Texture2;
            base.ExportStats(stats, isOtherPlayer);
        }

        private Vector2 GetRandDirection()
        {
            var angle = Random.Shared.NextDouble() * 2 * Math.PI;
            return new Vector2((float)Math.Cos(angle), (float)Math.Sin(angle));
        }
    }
}
