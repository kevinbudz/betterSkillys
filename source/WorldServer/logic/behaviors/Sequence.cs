using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    //replacement for simple sequential state transition
    internal class Sequence : Behavior
    {
        //State storage: index

        CycleBehavior[] children;
        public Sequence(params CycleBehavior[] children)
        {
            this.children = children;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            foreach (var i in children)
                i.OnStateEntry(host, time);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            int index;
            if (state == null) index = 0;
            else index = (int)state;

            children[index].Tick(host, time);
            if (children[index].Status == CycleStatus.Completed ||
                children[index].Status == CycleStatus.NotStarted)
            {
                index++;
                if (index == children.Length) index = 0;
            }

            state = index;
        }
    }
}
