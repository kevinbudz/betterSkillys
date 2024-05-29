using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.logic;
using WorldServer.utils;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class ScaleDefense : Behavior
    {
        private readonly double AmountPerPerson;
        private readonly double Range;

        public ScaleDefense(double perPerson, double range = 25.0)
        {
            AmountPerPerson = perPerson;
            Range = range;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = new DefScaleState() { pNamesCounted = new List<string>(), cooldown = 0 };

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var defScaleState = (DefScaleState)state;

            if (defScaleState == null)
                return;

            if (defScaleState.cooldown <= 0)
            {
                defScaleState.cooldown = 1000;

                if (!(host is Enemy))
                    return;

                var enemy = host as Enemy;
                foreach (var player in host.GetNearestEntities(Range, null, true).OfType<Player>())
                    if (!defScaleState.pNamesCounted.Contains(player.Name))
                        defScaleState.pNamesCounted.Add(player.Name);

                var playerCount = defScaleState.pNamesCounted.Count;
                var amountInc = (playerCount - 1) * AmountPerPerson;
                enemy.Defense = enemy.ObjectDesc.Defense + (int)Math.Ceiling(amountInc);
            }
            else
                defScaleState.cooldown -= time.ElapsedMsDelta;

            state = defScaleState;
        }

        private class DefScaleState
        {
            public int cooldown;
            public IList<string> pNamesCounted;
        }
    }

    internal class ScaleHP2 : Behavior
    {
        private readonly int _percentage;
        private readonly double _range;
        private readonly int _scaleAfter;

        public ScaleHP2(int amount, int scaleStart = 0, double range = 25.0)
        {
            _percentage = amount;
            _range = range;
            _scaleAfter = scaleStart;
        }

        // test
        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = new ScaleHPState { pNamesCounted = new List<string>(), initialItemScaleAmount = 0, initialScaleAmount = _scaleAfter, cooldown = 0 };

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var scstate = (ScaleHPState)state;

            if (scstate == null)
                return;

            if (scstate.cooldown <= 0)
            {
                scstate.cooldown = 1000;

                if (!(host is Enemy))
                    return;

                var enemy = host as Enemy;
                var plrCount = 0;
                var itemCount = 0;

                foreach (var player in host.GetNearestEntities(_range, null, true).OfType<Player>())
                {
                    if (scstate.pNamesCounted.Contains(player.Name))
                        continue;

                    if (_range > 0)
                    {
                        if (host.DistTo(player) < _range)
                        {
                            /*for (var i = 0; i < 4; i++)
                            {
                                var item = player.Inventory[i];

                                if (item == null || !item.Legendary && !item.Mythical)
                                    continue;
                                if (i == 0)
                                    itemCount = itemCount + 19;
                                itemCount = itemCount + 4;
                            }*/
                            scstate.pNamesCounted.Add(player.Name);
                        }
                    }
                    else
                        scstate.pNamesCounted.Add(player.Name);
                }

                plrCount = scstate.pNamesCounted.Count;

                if (plrCount > scstate.initialScaleAmount)
                {
                    var amountPerPlayer = _percentage * enemy.ObjectDesc.MaxHP / 100;
                    var amountInc = (plrCount - scstate.initialScaleAmount) * amountPerPlayer;
                    amountInc += (itemCount - scstate.initialItemScaleAmount) * enemy.ObjectDesc.MaxHP / 40;
                    //Console.WriteLine(itemCount + " - "+scstate.initialItemScaleAmount + " * "+enemy.ObjectDesc.MaxHP + " / 25 = " + (itemCount - scstate.initialItemScaleAmount) * enemy.ObjectDesc.MaxHP / 50);

                    scstate.initialScaleAmount += plrCount - scstate.initialScaleAmount;
                    scstate.initialItemScaleAmount += itemCount - scstate.initialItemScaleAmount;

                    var newHpMaximum = enemy.MaxHealth + amountInc;

                    enemy.Health += amountInc;
                    enemy.MaxHealth = newHpMaximum;
                }
            }
            else
                scstate.cooldown -= time.ElapsedMsDelta;

            state = scstate;
        }

        private class ScaleHPState
        {
            public int cooldown;
            public int initialScaleAmount = 0;
            public int initialItemScaleAmount = 0;
            public IList<string> pNamesCounted;
        }
    }
}
