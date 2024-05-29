using Shared.resources;
using System.Net.Http.Headers;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Allies = () => Behav()
        .Init("Gambler's Fate Effect",
            new State(
                new ActAsDecoy(),
                new State("0",
                    new SetAltTexture(0),
                    new TimedTransition(250, "1")
                    ),
                new State("1",
                    new SetAltTexture(1),
                    new TimedTransition(250, "2")
                    ),
                new State("2",
                    new SetAltTexture(2),
                    new TimedTransition(250, "3")
                    ),
                new State("3",
                    new SetAltTexture(3),
                    new TimedRandomTransition(250, false, "1", "4")
                    ),
                new State("4",
                    new SetAltTexture(4),
                    new TimedTransition(250, "5")
                    ),
                new State("5",
                    new SetAltTexture(5),
                    new TimedTransition(250, "6")
                    ),
                new State("6",
                    new SetAltTexture(6),
                    new TimedTransition(250, "7")
                    ),
                new State("7",
                    new SetAltTexture(7),
                     new TimedRandomTransition(250, false, "4", "decay")
                    ),
                new State("decay",
                    new Decay(0)
                    )
                )
            );
    }
}