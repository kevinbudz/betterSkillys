using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class JumpToRandomOffset : CycleBehavior
    {
        private readonly int maxX;
        private readonly int maxY;
        private readonly int minX;
        private readonly int minY;

        public JumpToRandomOffset(int minX, int maxX, int minY, int maxY)
        {
            this.minX = minX;
            this.maxX = maxX;
            this.minY = minY;
            this.maxY = maxY;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => host.Move(host.X + Random.Next(minX, maxX), host.Y + Random.Next(minY, maxY));

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
