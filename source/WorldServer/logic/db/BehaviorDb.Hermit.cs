using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Hermit = () => Behav()
        .Init("Hermit God",
            new State(
                new ScaleHP2(20),
                new PlaceMap("setpieces/hermit/spawn.jm", true),
                new PlaceMapAtDeath("setpieces/hermit/death.jm", true),
                new OrderOnDeath(20, "Hermit God Tentacle Spawner", "Die", 1),
                new OrderOnDeath(20, "Hermit God Drop", "Die", 1),
                new State("Spawn Tentacle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new SetAltTexture(2),
                    new Order(20, "Hermit God Tentacle Spawner", "Tentacle"),
                    new TimedTransition(1000, "Sleep")
                    ),
                new State("Sleep",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(20, "Hermit God Tentacle Spawner", "Minions"),
                    new TimedTransition(1000, "Waiting")
                    ),
                new State("Waiting",
                    new SetAltTexture(3),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new EntityNotExistsTransition("Hermit God Tentacle", 20, "Wake")
                    ),
                new State("Wake",
                    new SetAltTexture(2),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TossObject("Hermit Minion", 10, angle: 0),
                    new TossObject("Hermit Minion", 10, angle: 45),
                    new TossObject("Hermit Minion", 10, angle: 90),
                    new TossObject("Hermit Minion", 10, angle: 135),
                    new TossObject("Hermit Minion", 10, angle: 180),
                    new TossObject("Hermit Minion", 10, angle: 225),
                    new TossObject("Hermit Minion", 10, angle: 270),
                    new TossObject("Hermit Minion", 10, angle: 315),
                    new TimedTransition(500, "Spawn Whirlpool")
                    ),
                new State("Spawn Whirlpool",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(20, "Hermit God Tentacle Spawner", "Whirlpool"),
                    new TimedTransition(1000, "Attack1")
                    ),
                new State("Attack1",
                    new SetAltTexture(0),
                    new Prioritize(
                        new Wander(1),
                        new StayCloseToSpawn(1, 5)
                        ),
                    new Shoot(20, count: 3, shootAngle: 5, coolDown: 300),
                    new TimedTransition(6000, "Attack2")
                    ),
                new State("Attack2",
                    new Prioritize(
                        new Wander(1),
                        new StayCloseToSpawn(1, 5)
                        ),
                    new Order(20, "Whirlpool", "Die"),
                    new Shoot(20, count: 2, defaultAngle: 10, fixedAngle: 0, rotateAngle: 45, projectileIndex: 1,
                        coolDown: 500),
                    new Shoot(20, count: 2, defaultAngle: 10, fixedAngle: 180, rotateAngle: 45, projectileIndex: 1,
                        coolDown: 500),
                    new TimedTransition(6000, "Spawn Tentacle")
                    )
                ),
                new Threshold(0.005,
                    LootTemplates.BasicDrop()
                ),
                new Threshold(0.005,
                    LootTemplates.BasicPots()
                ),
                new Threshold(0.01,
                    new ItemLoot("Helm of the Juggernaut", 0.001, threshold: 0.03)
                )
            )
        .Init("Hermit Minion",
            new State(
                new Prioritize(
                    new Follow(1, 4, 1),
                    new Orbit(4, 10, 15, "Hermit God", speedVariance: .2, radiusVariance: 1.5),
                    new Wander(0.5)
                    ),
                new Shoot(12, count: 3, shootAngle: 10, coolDown: 700),
                new Shoot(12, count: 2, shootAngle: 20, projectileIndex: 1, coolDown: 1300, predictive: 0.8)
                ),
            new ItemLoot("Health Potion", 0.1),
            new ItemLoot("Magic Potion", 0.1)
            )
        .Init("Whirlpool",
            new State(
                new State("Attack",
                    new EntityNotExistsTransition("Hermit God", 100, "Die"),
                    new Prioritize(
                        new Orbit(4, 6, 10, "Hermit God")
                        ),
                    new Shoot(10, 1, fixedAngle: 0, rotateAngle: 30, coolDown: 400)
                    ),
                new State("Die",
                    new Shoot(3, 8, fixedAngle: 360 / 8),
                    new Suicide()
                    )
                )
            )
        .Init("Hermit God Tentacle",
            new State(
                new State("Attack",
                    new Prioritize(
                        new Orbit(3, 5, 15, "Hermit God", speedVariance: .2)
                        ),
                    new Shoot(8, count: 8, shootAngle: 360 / 8, coolDown: 500),
                    new HpLessTransition(0.05, "dead1")
                    ),
                new State("dead1",
                    new Suicide()
                )
            )
        )
        .Init("Hermit God Tentacle Spawner",
            new State(
                new State("Waiting Order",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("Tentacle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Spawn("Hermit God Tentacle", 1),
                    new TimedTransition(500, "Waiting Order")
                    ),
                new State("Whirlpool",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Spawn("Whirlpool", 1),
                    new TimedTransition(500, "Waiting Order")
                    ),
                new State("Minions",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Spawn("Hermit Minion", 1, coolDown: 1000),
                    new TimedTransition(2000, "Waiting Order")
                    ),
                new State("Die",
                    new Suicide()
                    )
                )
            )
        .Init("Hermit God Drop",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new State("Waiting"),
                new State("Die",
                    new Suicide()
                    )
                )
            )
        .Init("Hermit portal maker",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new DropPortalOnDeath("Ocean Trench Portal", 1),
                new State("Wait",
                    new EntityNotExistsTransition("Hermit God", 50, "Transform")
                    ),
                new State("Transform",
                    new Suicide()
                    )
                )
            )
        ;
    }
}