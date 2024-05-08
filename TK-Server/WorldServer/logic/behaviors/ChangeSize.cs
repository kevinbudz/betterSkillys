using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class ChangeSize : Behavior
    {
        private readonly int rate;
        private readonly int target;

        public ChangeSize(int rate, int target)
        {
            this.rate = rate;
            this.target = target;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = 0;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
            {
                var size = host.Size;

                if (size != target)
                {
                    size += rate;

                    if (rate > 0 && size > target || rate < 0 && size < target)
                        size = target;

                    host.Size = size;
                }

                cool = 150;
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
