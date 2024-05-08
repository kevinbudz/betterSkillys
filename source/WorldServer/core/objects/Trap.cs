using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.objects
{
    internal class Trap : StaticObject
    {
        private const int LIFETIME = 10;

        private readonly int dmg;
        private int duration;
        private ConditionEffectIndex effect;
        private int p = 0;
        private Player player;
        private float radius;
        private int t = 0;

        public Trap(Player player, float radius, int dmg, ConditionEffectIndex eff, float effDuration) : base(player.GameServer, 0x0711, LIFETIME * 1000, true, true, false)
        {
            this.player = player;
            this.radius = radius;
            this.dmg = dmg;

            effect = eff;
            duration = (int)(effDuration * 1000);
        }

        public override void Tick(ref TickTime time)
        {
            if (t / 500 == p)
            {
                World.BroadcastIfVisible(new ShowEffect()
                {
                    EffectType = EffectType.Trap,
                    Color = new ARGB(0xff9000ff),
                    TargetObjectId = Id,
                    Pos1 = new Position() { X = radius / 2 }
                }, this);

                p++;

                if (p == LIFETIME * 2)
                {
                    Explode(time);
                    return;
                }
            }

            t += time.ElapsedMsDelta;

            var monsterNearby = false;

            this.AOE(radius / 2, false, enemy => monsterNearby = true);

            if (monsterNearby)
                Explode(time);

            base.Tick(ref time);
        }

        private void Explode(TickTime time)
        {
            World.BroadcastIfVisible(new ShowEffect()
            {
                EffectType = EffectType.AreaBlast,
                Color = new ARGB(0xff9000ff),
                TargetObjectId = Id,
                Pos1 = new Position() { X = radius }
            }, this);

            this.AOE(radius, false, enemy =>
            {
                (enemy as Enemy).Damage(player, ref time, dmg, false, false, new ConditionEffect(effect, duration));
            });

            World.LeaveWorld(this);
        }
    }
}
