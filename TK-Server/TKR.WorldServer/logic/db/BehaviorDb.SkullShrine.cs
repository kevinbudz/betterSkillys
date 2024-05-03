using TKR.Shared.resources;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.transitions;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ SkullShrine = () => Behav()
        .Init("Skull Shrine",
            new State(
                new ScaleHP2(35),
                new Shoot(30, 13, 10, coolDown: 600, predictive: 1), // add prediction after fixing it...
                new Reproduce("Red Flaming Skull", 40, 20, coolDown: 300),
                new Reproduce("Blue Flaming Skull", 40, 20, coolDown: 300)
                ),
            new Threshold(0.001,
                new ItemLoot("Potion of Attack", 1),
                new ItemLoot("Potion of Dexterity", 1),
                new ItemLoot("Potion of Wisdom", 1),
                new ItemLoot("Potion of Attack", 0.5),
                new ItemLoot("Potion of Dexterity", 0.5),
                new ItemLoot("Potion of Wisdom", 0.5),
                new TierLoot(10, ItemType.Weapon, 0.12),
                new TierLoot(11, ItemType.Weapon, 0.09),
                new TierLoot(4, ItemType.Ring, 0.07),
                new TierLoot(5, ItemType.Ring, 0.03),
                new TierLoot(11, ItemType.Armor, 0.12),
                new TierLoot(12, ItemType.Armor, 0.09),
                new TierLoot(4, ItemType.Ability, 0.07),
                new TierLoot(5, ItemType.Ability, 0.03)
                ),
            new Threshold(0.01,
                new ItemLoot("Orb of Conflict", 0.001, threshold: 0.03)
                )
            )
        .Init("Red Flaming Skull",
            new State(
                new State("Orbit Skull Shrine",
                    new Prioritize(
                        new Orbit(4, 10, 40, "Skull Shrine", .6, 10, orbitClockwise: null),
                        new Protect(1, "Skull Shrine", 30, 15, 15),
                        new Wander(.4)
                        ),
                    new EntityNotExistsTransition("Skull Shrine", 40, "Wander")
                    ),
                new State("Wander",
                    new Wander(.3)
                    ),
                new Shoot(12, 2, 10, coolDown: 750)
                )
            )
        .Init("Blue Flaming Skull",
            new State(
                new State("Orbit Skull Shrine",
                    new Orbit(4, 10, 40, "Skull Shrine", .6, 10, orbitClockwise: null),
                    new EntityNotExistsTransition("Skull Shrine", 40, "Wander")
                    ),
                new State("Wander",
                    new Wander(0.5)
                    ),
                new Shoot(12, 2, 10, coolDown: 750)
                )
            );
    }
}
