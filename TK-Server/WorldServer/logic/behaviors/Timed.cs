using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class Timed : CycleBehavior
    {
        private readonly Behavior[] behaviors;
        private readonly int period;

        public Timed(int period, params Behavior[] behaviors)
        {
            this.behaviors = behaviors;
            this.period = period;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            foreach (var behavior in behaviors)
                behavior.OnStateEntry(host, time);

            state = period;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var period = (int)state;

            foreach (var behavior in behaviors)
            {
                behavior.Tick(host, time);

                Status = CycleStatus.InProgress;

                period -= time.ElapsedMsDelta;

                if (period <= 0)
                {
                    period = this.period;

                    Status = CycleStatus.Completed;

                    if (behavior is Prioritize)
                        host.StateStorage[behavior] = -1;
                }
            }

            state = period;
        }
    }
}
