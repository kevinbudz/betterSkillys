using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class RemoveEntity : Behavior
    {
        private readonly string children;
        private readonly float dist;

        public RemoveEntity(double dist, string children)
        {
            this.dist = (float)dist;
            this.children = children;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            foreach (var entity in host.GetNearestEntitiesByName(dist, children).OfType<Enemy>())
                entity.Expunge();
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
