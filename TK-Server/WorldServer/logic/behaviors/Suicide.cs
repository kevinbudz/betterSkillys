using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class Suicide : Behavior
    {
        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if (!(host is Enemy))
                throw new NotSupportedException("Use Decay instead");

            (host as Enemy).Death(ref time);
        }
    }
}
