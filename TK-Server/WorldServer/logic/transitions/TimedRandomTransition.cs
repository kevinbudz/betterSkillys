using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.transitions
{
    internal class TimedRandomTransition : Transition
    {
        //State storage: cooldown timer

        private readonly int _time;
        private readonly bool Randomized;

        public TimedRandomTransition(int time, bool randomizedTime = false, params string[] states)
            : base(states)
        {
            _time = time;
            Randomized = randomizedTime;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            int cool;

            if (state == null)
                cool = Randomized ?
                    Random.Next(_time) :
                    _time;
            else
                cool = (int)state;

            if (cool <= 0)
            {
                state = _time;
                SelectedState = Random.Next(TargetStates.Length);
                return true;
            }

            cool -= time.ElapsedMsDelta;
            state = cool;
            return false;
        }
    }
}
