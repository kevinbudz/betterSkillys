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
        .Init("Pirate Ally",
            new State(
                new Decay(5000),
                new State("attack",
                    new AllyCharge(1, 10, 1),
                    new AllyShoot(10, 1, projectileIndex: 0, coolDown: 500),
                    new NoEntityWithinAllyTransition(10, false, "wander")
                    ),
                new State("wander",
                    new AllyFollow(1, 10, 1.5),
                    new EntityWithinAllyTransition(10, "attack")
                    )
                )
            )
        .Init("CR Friendly Cnidarian",
            new State(
                new State("0",
                    new SetAltTexture(0),
                    new TimedTransition(1000, "1")
                    ),
                new State("1",
                    new AllyAOE(600, 2, 0xffa447),
                    new SetAltTexture(1),
                    new TimedTransition(1000, "2")
                    ),
                new State("2",
                    new SetAltTexture(0),
                    new TimedTransition(1000, "3")
                    ),
                new State("3",
                    new AllyAOE(600, 2, 0xffa447),
                    new SetAltTexture(1),
                    new TimedTransition(1000, "4")
                    ),
                new State("4",
                    new SetAltTexture(0),
                    new TimedTransition(1000, "5")
                    ),
                new State("5",
                    new AllyAOE(600, 2, 0xffa447),
                    new SetAltTexture(1),
                    new TimedTransition(1000, "decay")
                    ),
                new State("decay",
                    new Decay(0)
                    )
                )
            )
        .Init("Cranium Effect",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new AllyDamage(150, 5, 200),
                new AllyFollow(1, 10, 1),
                new State("0",
                    new AllyLightning(250, 0x9F2B68),
                    new TimedTransition(1000, "1")
                    ),
                new State("1",
                    new AllyLightning(250, 0x9F2B68),
                    new TimedTransition(1000, "2")
                    ),
                new State("2",
                    new AllyLightning(250, 0x9F2B68),
                    new TimedTransition(1000, "3")
                    ),
                new State("3",
                    new AllyLightning(250, 0x9F2B68),
                    new TimedTransition(1000, "4")
                    ),
                new State("4",
                    new AllyLightning(250, 0x9F2B68),
                    new TimedTransition(1000, "decay")
                    ),
                new State("decay",
                    new Decay(0)
                    )
                )
            )
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
                    new TimedRandomTransition(250, false, "0", "4")
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
                    new SetAltTexture(4),
                    new Decay(250)
                    )
                )
            );
    }
}