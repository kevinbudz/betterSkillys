using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    public class EnemyAOE : Behavior
    {
        private readonly ARGB color;
        private readonly int maxDamage;
        private readonly int minDamage;
        private readonly bool noDef;
        private readonly bool players;
        private readonly float radius;

        public EnemyAOE(double radius, bool players, int minDamage, int maxDamage, bool noDef, uint color)
        {
            this.radius = (float)radius;
            this.players = players;
            this.minDamage = minDamage;
            this.maxDamage = maxDamage;
            this.noDef = noDef;
            this.color = new ARGB(color);
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var pos = new Position(host.X, host.Y);
            var damage = Random.Next(minDamage, maxDamage);

            host.World.AOE(pos, radius, players, enemy =>
            {
                if (!players)
                {
                    var aoe = new AoeMessage(pos, radius, damage, 0, 0, host.ObjectType, color);
                    host.World.BroadcastIfVisible(aoe, host);
                }
            });
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
