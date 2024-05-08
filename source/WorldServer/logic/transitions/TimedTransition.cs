using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.transitions
{
    internal class TimedTransition : Transition
    {
        //State storage: cooldown timer

        private readonly int time;
        private readonly bool randomized;

        public TimedTransition(int time, string targetState, bool randomized = false)
            : base(targetState)
        {
            this.time = time;
            this.randomized = randomized;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            int cool;
            if (state == null) cool = randomized ? Random.Next(this.time) : this.time;
            else cool = (int)state;

            bool ret = false;
            if (cool <= 0)
            {
                ret = true;
                cool = this.time;
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
            return ret;
        }
    }
}
