using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    public class ProcEvent : Behavior
    {
        public readonly string[] nestNames = ["Yellow Beehemoth", "Blue Beehemoth", "Red Beehemoth"];
        // add different strings accordingly.

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            if (host.World is RealmWorld rw)
            {
                if (nestNames.Contains(host.Name))
                    rw.RealmManager.OnProcEvent("EH Event Hive", (host as Enemy).DamageCounter.LastHitter);
                // else if (___.Contains(host.Name)) { }
            }
        }
        protected override void TickCore(Entity host, TickTime time, ref object state) { }
    }
}
