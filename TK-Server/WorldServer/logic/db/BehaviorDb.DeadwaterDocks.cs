using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ DeadwaterDocks = () => Behav()
        .Init("Deadwater Docks Parrot",
            new State(
                new EntityNotExistsTransition("Jon Bilgewater the Pirate King", 90000, "rip"),
                new State("CircleOrWander",
                    new Prioritize(
                        new Orbit(3, 2, 5, "Parrot Cage"),
                        new Wander(1)
                        )
                    ),
                new State("Orbit&HealJon",
                    new Orbit(3, 2, 20, "Jon Bilgewater the Pirate King"),
                    new HealSelf(coolDown: 2000, amount: 100)

                    ),
                new State("rip",
                    new Suicide()
                    )
                )
            )
        .Init("Parrot Cage",
            new State(
                new EntityNotExistsTransition("Jon Bilgewater the Pirate King", 90000, "NoSpawn"),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("NoSpawn"
                    ),
                new State("SpawnParrots",
                    new Reproduce("Deadwater Docks Parrot", densityRadius: 5, densityMax: 5, coolDown: 2500)
                    )
                )
            )
        .Init("Deadwater Docks Lieutenant",
            new State(
                new Follow(2, 8, 1),
                new Shoot(8, 1, 10, coolDown: 1000),
                new TossObject("Bottled Evil Water", angle: null, coolDown: 6750)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Veteran",
            new State(
                new Follow(1, 8, 1),
                new Shoot(8, 1, 10, coolDown: 500)
                ),
            new TierLoot(10, ItemType.Weapon, 0.05),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Admiral",
            new State(
                new Follow(2, 8, 1),
                new Shoot(8, 3, 10, coolDown: 1325)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Brawler",
            new State(
                new Follow(1.5, 8, 1),
                new Shoot(8, 1, 10, coolDown: 350)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Sailor",
            new State(
                new Follow(1.3, 8, 1),
                new Shoot(8, 1, 10, coolDown: 525)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Commander",
            new State(
                new Follow(0.90, 8, 1),
                new Shoot(8, 1, 10, coolDown: 900),
                new TossObject("Bottled Evil Water", angle: null, coolDown: 8750)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )
        .Init("Deadwater Docks Captain",
            new State(
                new Follow(0.47, 8, 1),
                new Shoot(8, 1, 10, coolDown: 3500)
                ),
            new ItemLoot("Magic Potion", 0.1),
            new ItemLoot("Health Potion", 0.1)
            )

        .Init("Jon Bilgewater the Pirate King",
            new State(
                new ScaleHP2(20),
                new RealmPortalDrop(),
                new State("default",
                    new PlayerWithinTransition(8, "coinphase")
                    ),
                new State(
                    new Order(90, "Parrot Cage", "SpawnParrots"),
                    new DamageTakenTransition(32500, "gotoSpawn"),
                    new State("coinphase",
                        new Wander(1),
                        new Shoot(10, count: 1, projectileIndex: 0, coolDown: 1200),
                        new TimedTransition(4500, "cannonballs")
                        ),
                    new State("cannonballs",
                        new Follow(1.5, 8, coolDown: 1000),
                        new Shoot(10, count: 7, shootAngle: 30, projectileIndex: 1, coolDown: 1000),
                        new TimedTransition(5000, "coinphase")
                        )
                    ),

                new State("gotoSpawn",
                    new ReturnToSpawn(speed: 1),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ConditionEffectBehavior(ConditionEffectIndex.StunImmune),
                    new TimedTransition(3500, "blastcannonballs")
                    ),
                new State("blastcannonballs",
                    new ConditionEffectBehavior(ConditionEffectIndex.StunImmune),
                    new Order(90, "Deadwater Docks Parrot", "CircleOrWander"),
                    new Shoot(10, count: 7, shootAngle: 30, projectileIndex: 1, coolDown: 1750),
                    new TimedTransition(6000, "parrotcircle")
                    ),
                new State("parrotcircle",
                    new ConditionEffectBehavior(ConditionEffectIndex.StunImmune),
                    new Order(90, "Deadwater Docks Parrot", "Orbit&HealJon"),
                    new TimedTransition(6000, "blastcannonballs")
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Potion of Speed", 1),
                new ItemLoot("Potion of Dexterity", 1),
                new ItemLoot("Potion of Speed", 0.5),
                new ItemLoot("Potion of Dexterity", 0.5),
                new ItemLoot("Potion of Life", 1),
                new ItemLoot("Potion of Life", 0.5),
                new TierLoot(13, ItemType.Weapon, 0.1),
                new TierLoot(6, ItemType.Ability, 0.1),
                new TierLoot(12, ItemType.Armor, 0.1),
                new TierLoot(13, ItemType.Armor, 0.05),
                new TierLoot(5, ItemType.Ring, 0.1),
                new ItemLoot("Pirate King's Cutlass", 0.001),
                new ItemLoot("Deadwater Docks Key", 0.01, 0, 0.03)
                )
            )
        ;
    }
}
