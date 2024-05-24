using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;
using WorldServer.logic.behaviors.@new.movements;
namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Hive = () => Behav()
        .Init("TH Queen Bee",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new PlayerWithinTransition(8, "start")
                    ),
                new State("start",
                    new Wander(0.7),
                    new EnemyAOE(5, true, 45, 55, false, color: 0xffaa00),
                    new Shoot(10, 6, 60, 0, coolDown: 2000),
                    new TimedTransition(5000, "buffer")
                    ),
                new State("buffer",
                    new Flash(0xffaaa00, 1, 2),
                    new TimedTransition(2000, "alternate")
                    ),
                new State("alternate",
                    new Follow(0.5, 10, 2),
                    new Shoot(10, 5, 10, 1, coolDown: 2000),
                    new TimedTransition(4000, "start")
                    )
                ),
                new Threshold(0.05,
                    new ItemLoot("Potion of Dexterity", 1),
                    new ItemLoot("Bottled Honey", 0.5),
                    new ItemLoot("HoneyScepter", 0.05),
                    new ItemLoot("Orb of Sweet Demise", 0.05)
                ),
                new Threshold(0.05,
                    LootTemplates.MountainDrop()
                )
            )
        .Init("TH Maggots",
            new State(
                new Wander(0.8),
                new Shoot(10, 1, null, 0, coolDown: 1000)
                )
            )
        .Init("TH Small Bees",
            new State(
                new Follow(0.8, 10, 0.5),
                new Shoot(10, 1, null, 0, coolDown: 1000)
                )
            )
        .Init("TH Fat Bees",
            new State(
                new Wander(0.7),
                new Shoot(10, 1, null, 0, coolDown: 1000)
                )
            )
        .Init("TH Red Fat Bees",
            new State(
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, null, 0, coolDown: 1000)
                )
            )
        .Init("TH Maggot Egg1",
            new State(
                new TransformOnDeath("TH Maggots", 3, 4)
                )
            )
        .Init("TH Maggot Egg2",
            new State(
                new TransformOnDeath("TH Maggots", 3, 4)
                )
            )
        .Init("TH Maggot Egg3",
            new State(
                new TransformOnDeath("TH Maggots", 3, 4)
                )
            )
        .Init("TH Mini Hive",
            new State(
                new TimedRandomTransition(500, false, "small", "red", "normal"),
                new State("small",
                    new TransformOnDeath("TH Small Bees", 2, 3)
                    ),
                new State("red",
                    new TransformOnDeath("TH Red Fat Bees", 2, 2)
                    ),
                new State("normal",
                    new TransformOnDeath("TH Fat Bees", 2, 2)
                    )
                ),
                new ItemLoot("Bottled Honey", 0.25)
            );
    }
}