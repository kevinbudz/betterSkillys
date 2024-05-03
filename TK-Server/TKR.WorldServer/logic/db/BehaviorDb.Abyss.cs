using TKR.Shared.resources;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.transitions;
using TKR.WorldServer.logic.behaviors.@new.movements;
namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Abyss = () => Behav()
            .Init("Malphas Protector",
                new State(
                    new Shoot(radius: 5, count: 3, shootAngle: 5, projectileIndex: 0, predictive: 0.45, coolDown: 1200),
                    new Orbit(speed: 3.2, radius: 9, acquireRange: 20, target: "Archdemon Malphas", speedVariance: 0, radiusVariance: 0, orbitClockwise: true)
                    ),
                new Threshold(0.01,
                    new ItemLoot(item: "Magic Potion", probability: 0.06),
                    new ItemLoot(item: "Health Potion", probability: 0.04)
                    )
            )
         .Init("Brute Warrior of the Abyss",
                new State(
                    new Prioritize(
                        new Follow(1, 8, 1),
                        new Wander(0.25)
                        ),
                    new Shoot(8, 3, shootAngle: 10, coolDown: 500)
                    ),
                new ItemLoot("Spirit Salve Tome", 0.02),
                new Threshold(0.5,
                    new ItemLoot("Glass Sword", 0.01),
                    new ItemLoot("Ring of Greater Dexterity", 0.01),
                    new ItemLoot("Magesteel Quiver", 0.01)
                    )
            )
        .Init("Imp of the Abyss",
                new State(
                    new Wander(0.875),
                    new Shoot(8, 5, 10, coolDown: 1000)
                    ),
                new ItemLoot("Health Potion", 0.1),
                new ItemLoot("Magic Potion", 0.1),
                new Threshold(0.5,
                    new ItemLoot("Cloak of the Red Agent", 0.01)
                    )
            )
            .Init("Demon of the Abyss",
                new State(
                    new Prioritize(
                        new Follow(1, 8, 5),
                        new Wander(0.25)
                        ),
                    new Shoot(8, 3, shootAngle: 10, coolDown: 1000)
                    ),
                new ItemLoot("Fire Bow", 0.05),
                new Threshold(0.5,
                    new ItemLoot("Mithril Armor", 0.01)
                    )
            )
            .Init("Demon Warrior of the Abyss",
                new State(
                    new Prioritize(
                        new Follow(1, 8, 5),
                        new Wander(0.25)
                        ),
                    new Shoot(8, 3, shootAngle: 10, coolDown: 1000)
                    ),
                new ItemLoot("Fire Sword", 0.025),
                new ItemLoot("Steel Shield", 0.025)
            )
            .Init("Demon Mage of the Abyss",
                new State(
                    new Prioritize(
                        new Follow(1, 8, 5),
                        new Wander(0.25)
                        ),
                    new Shoot(8, 3, shootAngle: 10, coolDown: 1000)
                    ),
                new ItemLoot("Fire Nova Spell", 0.02),
                new Threshold(0.1,
                    new ItemLoot("Wand of Dark Magic", 0.01),
                    new ItemLoot("Avenger Staff", 0.01),
                    new ItemLoot("Robe of the Invoker", 0.01),
                    new ItemLoot("Essence Tap Skull", 0.01),
                    new ItemLoot("Demonhunter Trap", 0.01)
                    )
            )
            .Init("Brute of the Abyss",
                new State(
                    new Prioritize(
                        new Follow(1.5, 8, 1),
                        new Wander(0.25)
                        ),
                    new Shoot(8, 3, shootAngle: 10, coolDown: 500)
                    ),
                new ItemLoot("Health Potion", 0.1),
                new Threshold(0.1,
                    new ItemLoot("Obsidian Dagger", 0.02),
                    new ItemLoot("Steel Helm", 0.02)
                    )
            )
            .Init("Malphas Missile",
                new State(
                    new State("Start",
                        new TimedTransition(time: 50, targetState: "Attacking")
                        ),
                    new State("Attacking",
                        new Follow(speed: 1.1, acquireRange: 10, range: 0.2),
                        new PlayerWithinTransition(dist: 1.3, targetState: "FlashBeforeExplode"),
                        new TimedTransition(time: 5000, targetState: "FlashBeforeExplode")
                        ),
                    new State("FlashBeforeExplode",
                        new Flash(color: 0xFFFFFF, flashPeriod: 0.1, flashRepeats: 6),
                        new TimedTransition(time: 600, targetState: "Explode")
                        ),
                    new State("Explode",
                        new Shoot(radius: 0, count: 8, shootAngle: 45, projectileIndex: 0, fixedAngle: 0),
                        new Suicide()
                        )
                    )
            )
        .Init("Malphas Flamer",
                new State(
                    new State("Attacking",
                        new State("Charge",
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 0.1)
                                ),
                            new PlayerWithinTransition(dist: 2, targetState: "Bullet1", seeInvis: true)
                            ),
                        new State("Bullet1",
                            new Flash(color: 0xFFAA00, flashPeriod: 0.2, flashRepeats: 20),
                            new Shoot(radius: 8, coolDown: 200),
                            new TimedTransition(time: 4000, targetState: "Wait1")
                            ),
                        new State("Wait1",
                            new Charge(speed: 3, range: 20, coolDown: 600)
                            ),
                        new HpLessTransition(threshold: 0.2, targetState: "FlashBeforeExplode")
                    ),
                    new State("FlashBeforeExplode",
                        new Flash(color: 0xFF0000, flashPeriod: 0.75, flashRepeats: 1),
                        new TimedTransition(time: 300, targetState: "Explode")
                        ),
                    new State("Explode",
                        new Shoot(radius: 0, count: 8, shootAngle: 45, defaultAngle: 0),
                        new Decay(time: 100)
                        )
                    ),
                new Threshold(0.01,
                    new ItemLoot("Health Potion", 0.1),
                    new ItemLoot("Magic Potion", 0.1)
                    )
            )
            .Init("Archdemon Malphas",
                new State(
                    new ScaleHP2(30),
                    new DropPortalOnDeath("Realm Portal", 100),
                    new State("start_the_fun",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new PlayerWithinTransition(dist: 11, targetState: "he_is_never_alone", seeInvis: true)
                        ),
                    new State("he_is_never_alone",
                        new State("Missile_Fire",
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.1, range: 1),
                                new Shoot(10, count: 2, shootAngle: 20, predictive: 0.7, coolDown: 300),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),

                                new Follow(speed: 0.3, acquireRange: 8, range: 2)
                                ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, angleOffset: 1, predictive: 0.15, coolDown: 900),
                            new Reproduce(children: "Malphas Missile", densityRadius: 24, densityMax: 4, coolDown: 1800),
                            new State("invulnerable1",
                                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                                new TimedTransition(time: 2000, targetState: "vulnerable")
                                ),
                            new State("vulnerable",
                                new TimedTransition(time: 4000, targetState: "invulnerable2")
                                ),
                            new State("invulnerable2",
                                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable)
                                ),
                            new TimedTransition(time: 9000, targetState: "Pause1")
                            ),
                        new State("Pause1",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.4, range: 5),
                                new Wander(speed: 0.4)
                                ),
                            new TimedTransition(time: 2500, targetState: "Small_target")
                            ),
                        new State("Small_target",
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.8, range: 5),
                                new Wander(speed: 0.8),
                                 new Shoot(12, projectileIndex: 2, count: 2, shootAngle: 72, predictive: 0.5, coolDown: 550)

                                ),
                            new Shoot(radius: 0, count: 3, shootAngle: 60, projectileIndex: 1, fixedAngle: 0, coolDown: 1200),
                            new Shoot(radius: 8, count: 1, angleOffset: 0.6, predictive: 0.15, coolDown: 900),
                            new TimedTransition(time: 12000, targetState: "Size_matters")
                            ),
                        new State("Size_matters",
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.2, range: 5),
                                new Wander(speed: 0.2)
                                ),
                            new State("Growbig",
                                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                                new TimedTransition(time: 1800, targetState: "Shot_rotation1")
                                ),
                            new State("Shot_rotation1",
                                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                                new Shoot(radius: 8, count: 1, projectileIndex: 2, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 0, count: 2, shootAngle: 120, projectileIndex: 3, angleOffset: 0.7, defaultAngle: 0, coolDown: 700),
                                new TimedTransition(time: 1400, targetState: "Shot_rotation2")
                                ),
                            new State("Shot_rotation2",
                                new Shoot(radius: 8, count: 2, projectileIndex: 2, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 8, count: 2, projectileIndex: 2, predictive: 0.25, coolDown: 2000),
                                new Shoot(radius: 0, count: 2, shootAngle: 120, projectileIndex: 3, angleOffset: 0.7, defaultAngle: 40, coolDown: 700),
                                new TimedTransition(time: 1400, targetState: "Shot_rotation3")
                                ),
                            new State("Shot_rotation3",
                                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                                new Shoot(radius: 8, count: 1, projectileIndex: 2, predictive: 0.2, coolDown: 900),
                                new Shoot(radius: 2, count: 3, shootAngle: 120, projectileIndex: 3, angleOffset: 0.7, defaultAngle: 80, coolDown: 700),
                                new TimedTransition(time: 1400, targetState: "Shot_rotation1")
                                ),
                            new TimedTransition(time: 13000, targetState: "Pause2")
                            ),
                        new State("Pause2",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.4, range: 5),
                                new Wander(speed: 0.4)
                                ),
                            new TimedTransition(time: 2500, targetState: "Bring_on_the_flamers")
                            ),
                        new State("Bring_on_the_flamers",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new Prioritize(
                                new StayCloseToSpawn(speed: 0.4, range: 5),
                                new Follow(speed: 0.4, acquireRange: 9, range: 2)
                                ),
                            new Shoot(radius: 8, count: 1, predictive: 0.25, coolDown: 2100),
                            new Shoot(10, count: 5, shootAngle: 20, predictive: 1, coolDown: 700),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                                 new Shoot(10, count: 5, shootAngle: 20, predictive: 1, coolDown: 300),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                                 new Shoot(10, count: 5, shootAngle: 20, predictive: 1, coolDown: 300),
                                new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.2, coolDown: 900),
                            new TimedTransition(time: 8000, targetState: "Temporary_exhaustion")
                            ),
                        new State("Temporary_exhaustion",
                            new Flash(color: 0x484848, flashPeriod: 0.6, flashRepeats: 5),
                            new StayBack(speed: 0.4, distance: 4),
                            new TimedTransition(time: 3200, targetState: "Missile_Fire")
                            )
                        )
                    //new GroundTransformOnDeath("Red Checker Board", 1)
                    ),
                new Threshold(0.005,
                    new TierLoot(10, ItemType.Weapon, .07),
                    new TierLoot(11, ItemType.Weapon, .07),
                    new TierLoot(4, ItemType.Ability, .07),
                    new TierLoot(5, ItemType.Ability, .07),
                    new TierLoot(11, ItemType.Armor, .07),
                    new TierLoot(12, ItemType.Armor, .07),
                    new TierLoot(4, ItemType.Ring, .07),
                    new TierLoot(5, ItemType.Ring, .07)
                    ),
                new Threshold(0.01,
                    new ItemLoot("Demon Blade", 0.007),
                    new ItemLoot(item: "Potion of Vitality", probability: 1),
                    new ItemLoot(item: "Potion of Defense", probability: 1)
                )
            );
    }
}