using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class GiveTemporaryDefense : Behavior
    {
        private readonly int amount;

        public GiveTemporaryDefense(int amount)
        {
            this.amount = amount;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            if (host is Enemy)
                (host as Enemy).Defense += amount;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state) { }

        protected override void OnStateExit(Entity host, TickTime time, ref object state)
        {
            if (host is Enemy)
                (host as Enemy).Defense -= amount;
        }
    }
}
