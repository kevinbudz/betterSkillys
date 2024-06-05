using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class Decay : Behavior
    {
        int time;
        public Decay(int time = 10000)
        {
            this.time = time;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = this.time;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            int cool = (int?)state ?? -1;

            if (cool <= 0)
                if (!(host is Enemy))
                    host.World.LeaveWorld(host);
                else
                    (host as Enemy).Death(ref time);
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
