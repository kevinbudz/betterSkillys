﻿using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class Decay : Behavior
    {
        private readonly int time;

        public Decay(int time = 10000) => this.time = time;

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = this.time;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
                host.World.LeaveWorld(host);
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}