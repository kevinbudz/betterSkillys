using System;
using System.Collections.Generic;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class ScaleHP : Behavior
    {
        private readonly int amountPerPlayer;
        private readonly int dist;
        private readonly bool healAfterMax;
        private readonly int maxAdditional;
        private readonly int scaleAfter;

        public ScaleHP(int amountPerPlayer, int maxAdditional, bool healAfterMax = true, int dist = 0, int scaleAfter = 1)
        {
            this.amountPerPlayer = amountPerPlayer;
            this.maxAdditional = maxAdditional;
            this.healAfterMax = healAfterMax;
            this.dist = dist;
            this.scaleAfter = scaleAfter;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = new ScaleHPState
        { pNamesCounted = new List<string>(), initialScaleAmount = scaleAfter, maxHP = 0, hitMaxHP = false, cooldown = 0 };

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var scstate = (ScaleHPState)state;

            if (scstate.cooldown <= 0)
            {
                scstate.cooldown = 1000;

                if (!(host is Enemy)) return;

                if (scstate.maxHP == 0)
                    scstate.maxHP = (host as Enemy).MaxHealth + maxAdditional;

                foreach (var i in host.World.Players)
                {
                    if (scstate.pNamesCounted.Contains(i.Value.Name))
                        continue;

                    if (dist > 0)
                    {
                        if (host.DistTo(i.Value) < dist)
                            scstate.pNamesCounted.Add(i.Value.Name);
                    }
                    else
                        scstate.pNamesCounted.Add(i.Value.Name);
                }

                var plrCount = scstate.pNamesCounted.Count;

                if (plrCount > scstate.initialScaleAmount)
                {
                    var amountInc = (plrCount - scstate.initialScaleAmount) * amountPerPlayer;

                    scstate.initialScaleAmount += plrCount - scstate.initialScaleAmount;

                    if (maxAdditional != 0)
                        amountInc = Math.Min(maxAdditional, amountInc);

                    // ex: Enemy with 4000HP / 8000HP, being increased by 1200
                    var curHp = (host as Enemy).Health;                             // ex: current hp was 4000HP
                    var hpMaximum = (host as Enemy).MaxHealth;                  // ex: max hp was 8000HP
                    var curHpPercent = (double)curHp / hpMaximum;          // ex: 0.5
                    var newHpMaximum = (host as Enemy).MaxHealth + amountInc;   // ex: max hp is now 9200HP
                    var newHp = Convert.ToInt32(newHpMaximum * curHpPercent);   // ex: current has is now 4600HP

                    if (!scstate.hitMaxHP || healAfterMax)
                    {
                        (host as Enemy).Health = newHp;
                        (host as Enemy).MaxHealth = newHpMaximum;
                    }

                    if ((host as Enemy).MaxHealth >= scstate.maxHP && maxAdditional != 0)
                    {
                        (host as Enemy).MaxHealth = scstate.maxHP;
                        scstate.hitMaxHP = true;
                    }

                    if ((host as Enemy).Health > (host as Enemy).MaxHealth)
                        (host as Enemy).Health = (host as Enemy).MaxHealth;
                }
            }
            else
                scstate.cooldown -= time.ElapsedMsDelta;

            state = scstate;
        }

        private class ScaleHPState
        {
            public int cooldown;
            public bool hitMaxHP;
            public int initialScaleAmount = 0;
            public int maxHP;
            public IList<string> pNamesCounted;
        }
    }
}
