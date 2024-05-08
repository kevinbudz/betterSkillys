using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    public sealed class RestoresBreathBehavior : Behavior
    {
        private readonly double Radius;
        private readonly double RadiusSqr;
        private readonly double Speed;

        public RestoresBreathBehavior(double radius = 1.0, double speed = 50.0)
        {
            Radius = radius;
            RadiusSqr = radius * radius;
            Speed = speed;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var players = host.World.PlayersCollision.HitTest(host.X, host.Y, Radius);

            foreach (var o in players)
            {
                if (!(o is Player))
                    continue;

                var player = o as Player;
                var distSq = player.SqDistTo(host);
                if (distSq < RadiusSqr)
                    player.Breath = Math.Min(100.0, player.Breath + time.DeltaTime * Speed);
            }
        }
    }
}
