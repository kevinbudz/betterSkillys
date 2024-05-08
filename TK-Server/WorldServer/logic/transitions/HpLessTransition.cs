using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.transitions
{
    internal class HpLessTransition : Transition
    {
        //State storage: none

        private readonly double threshold;

        public HpLessTransition(double threshold, string targetState)
            : base(targetState)
        {
            this.threshold = threshold;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            return (double)(host as Enemy).HP / (host as Enemy).MaximumHP < threshold;
        }
    }
}
