using TKR.Shared.resources;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.transitions;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ CubeGod = () => Behav()
        .Init("Cube God",
            new State(
                new ScaleHP2(20),
                new State("Start",
                    new Wander(0.3),
                    new TossObject2("Cube Overseer", 3, coolDown: 99999, randomToss: true),
                    new TossObject2("Cube Overseer", 4, coolDown: 99999, randomToss: true),
                    new TossObject2("Cube Blaster", 1, coolDown: 99999, randomToss: true),
                    new TossObject2("Cube Blaster", 5, coolDown: 99999, randomToss: true),
                    new TossObject2("Cube Defender", 3, coolDown: 99999, randomToss: true),
                    new TossObject2("Cube Defender", 4, coolDown: 99999, randomToss: true),
                    new Shoot(30, 9, 10, 0, predictive: 1.5, coolDown: 750),
                    new Shoot(30, 4, 10, 1, predictive: 1.5, coolDown: 1500),
                    new HpLessTransition(0.06, "SpawnMed")
                    ),
                new State("SpawnMed",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Flash(0xFF0000, 1, 4),
                    new TimedTransition(4000, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                   )
                ),
            new Threshold(0.03,
                new ItemLoot("Dirk of Cronus", 0.001)
                ),
            new Threshold(.005,
                LootTemplates.BasicDrop()
                ),
            new Threshold(.005,
                LootTemplates.BasicPots()
                )
            )
        .Init("Cube Overseer",
                new State(
                    new Prioritize(
                        new Orbit(.375, 10, 30, "Cube God", .075, 5),
                        new Wander(.375)
                        ),
                    new Reproduce("Cube Defender", 12, 10, coolDown: 1000),
                    new Reproduce("Cube Blaster", 30, 10, coolDown: 1000),
                    new Shoot(10, 4, 10, 0, coolDown: 750),
                    new Shoot(10, projectileIndex: 1, coolDown: 1500)
                    ),
                new Threshold(.01,
                    new ItemLoot("Fire Sword", .05)
                    )
            )
            .Init("Cube Defender",
                new State(
                    new Prioritize(
                        new Orbit(1.05, 5, 15, "Cube Overseer", .15, 3),
                        new Wander(1.05)
                        ),
                    new Shoot(10, coolDown: 500)
                    )
            )
            .Init("Cube Blaster",
                new State(
                    new State("Orbit",
                        new Prioritize(
                            new Orbit(1.05, 7.5, 40, "Cube Overseer", .15, 3),
                            new Wander(1.05)
                            ),
                        new EntityNotExistsTransition("Cube Overseer", 10, "Follow")
                        ),
                    new State("Follow",
                        new Prioritize(
                            new Follow(.75, 10, 1, 5000),
                            new Wander(1.05)
                            ),
                        new EntityNotExistsTransition("Cube Defender", 10, "Orbit"),
                        new TimedTransition(5000, "Orbit")
                        ),
                    new Shoot(10, 2, 10, 1, predictive: 1, coolDown: 500),
                    new Shoot(10, predictive: 1, coolDown: 1500)
                    )
            );
    }
}
