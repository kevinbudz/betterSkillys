using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class Prioritize : Behavior
    {
        private CycleBehavior[] children;

        public Prioritize(params CycleBehavior[] children) => this.children = children;

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = -1;

            foreach (var i in children)
                i.OnStateEntry(host, time);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var index = state == null ? -1 : (int)state;

            if (index < 0)    //select
            {
                index = 0;

                for (var i = 0; i < children.Length; i++)
                {
                    children[i].Tick(host, time);

                    if (children[i].Status == CycleStatus.InProgress)
                    {
                        index = i;
                        break;
                    }
                }
            }
            else                //run a cycle
            {
                children[index].Tick(host, time);

                if (children[index].Status == CycleStatus.Completed || children[index].Status == CycleStatus.NotStarted)
                    index = -1;
            }

            state = index;
        }
    }
}
