using TKR.Shared.resources;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.transitions;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Highland = () => Behav()
        .Init("Minotaur",
            new State(
                new State("idle",
                    //new StayAbove(0.6, 160),
                    new PlayerWithinTransition(10, "charge")
                    ),
                new State("charge",
                    new Prioritize(
                        //new StayAbove(0.6, 160),
                        new Follow(6, acquireRange: 11, range: 1.6)
                        ),
                    new TimedTransition(200, "spam_blades")
                    ),
                new State("spam_blades",
                    new Shoot(8, projectileIndex: 0, count: 1, coolDown: 100000, coolDownOffset: 1000),
                    new Shoot(8, projectileIndex: 0, count: 2, shootAngle: 16, coolDown: 100000,
                        coolDownOffset: 1200),
                    new Shoot(8, projectileIndex: 0, count: 3, predictive: 0.2, coolDown: 100000,
                        coolDownOffset: 1600),
                    new Shoot(8, projectileIndex: 0, count: 1, shootAngle: 24, coolDown: 100000,
                        coolDownOffset: 2200),
                    new Shoot(8, projectileIndex: 0, count: 2, predictive: 0.2, coolDown: 100000,
                        coolDownOffset: 2800),
                    new Shoot(8, projectileIndex: 0, count: 3, shootAngle: 16, coolDown: 100000,
                        coolDownOffset: 3200),
                    new Prioritize(
                        //new StayAbove(0.6, 160),
                        new Wander(0.6)
                        ),
                    new TimedTransition(4400, "blade_ring")
                    ),
                new State("blade_ring",
                    new Shoot(7, fixedAngle: 0, count: 12, shootAngle: 30, coolDown: 800, projectileIndex: 1,
                        coolDownOffset: 600),
                    new Shoot(7, fixedAngle: 15, count: 6, shootAngle: 60, coolDown: 800, projectileIndex: 2,
                        coolDownOffset: 1000),
                    new Prioritize(
                        //new StayAbove(0.6, 160),
                        new Follow(0.6, acquireRange: 10, range: 1),
                        new Wander(0.6)
                        ),
                    new TimedTransition(3500, "pause")
                    ),
                new State("pause",
                    new Prioritize(
                        //new StayAbove(0.6, 160),
                        new Wander(0.6)
                        ),
                    new TimedTransition(1000, "idle")
                    )
                ),
            new Threshold(.01,
                new TierLoot(5, ItemType.Weapon, 0.26),
                new TierLoot(6, ItemType.Weapon, 0.18),
                new TierLoot(7, ItemType.Weapon, 0.10),
                new TierLoot(5, ItemType.Armor, 0.26),
                new TierLoot(6, ItemType.Armor, 0.18),
                new TierLoot(7, ItemType.Armor, 0.10),
                new TierLoot(3, ItemType.Ring, 0.10),
                new TierLoot(3, ItemType.Ability, 0.2)
                )
            )
        .Init("Ogre King",
            new State(
                new Spawn("Ogre Warrior", maxChildren: 4, coolDown: 12000, givesNoXp: false),
                new Spawn("Ogre Mage", maxChildren: 2, coolDown: 16000, givesNoXp: false),
                new Spawn("Ogre Wizard", maxChildren: 2, coolDown: 20000, givesNoXp: false),
                new State("idle",
                    new Prioritize(
                        //new StayAbove(0.3, 160),
                        new Wander(0.3)
                        ),
                    new PlayerWithinTransition(10, "grenade_blade_combo")
                    ),
                new State("grenade_blade_combo",
                    new State("grenade1",
                        new Grenade(3, 60, coolDown: 100000),
                        new Prioritize(
                            //new StayAbove(0.3, 160),
                            new Wander(0.3)
                            ),
                        new TimedTransition(2000, "grenade2")
                        ),
                    new State("grenade2",
                        new Grenade(3, 60, coolDown: 100000),
                        new Prioritize(
                            //new StayAbove(0.5, 160),
                            new Wander(0.5)
                            ),
                        new TimedTransition(3000, "slow_follow")
                        ),
                    new State("slow_follow",
                        new Shoot(13, coolDown: 1000),
                        new Prioritize(
                            //new StayAbove(0.4, 160),
                            new Follow(0.4, acquireRange: 9, range: 3.5, duration: 4),
                            new Wander(0.4)
                            ),
                        new TimedTransition(4000, "grenade1")
                        ),
                    new HpLessTransition(0.45, "furious")
                    ),
                new State("furious",
                    new Grenade(2.4, 55, range: 9, coolDown: 1500),
                    new Prioritize(
                        //new StayAbove(0.6, 160),
                        new Wander(0.6)
                        ),
                    new TimedTransition(12000, "idle")
                    )
                ),
            new Threshold(.01,
                new TierLoot(4, ItemType.Weapon, 0.2),
                new TierLoot(5, ItemType.Weapon, 0.1),
                new TierLoot(4, ItemType.Armor, 0.2),
                new TierLoot(5, ItemType.Armor, 0.15),
                new TierLoot(6, ItemType.Armor, 0.10),
                new TierLoot(2, ItemType.Ring, 0.15),
                new TierLoot(2, ItemType.Ability, 0.18)
                )
            )
        .Init("Ogre Warrior",
            new State(
                new Shoot(3, predictive: 0.5),
                new Prioritize(
                    // new StayAbove(1.2, 160),
                    new Protect(1.2, "Ogre King", acquireRange: 15, protectionRange: 10, reprotectRange: 5),
                    new Follow(1.4, acquireRange: 10.5, range: 1.6, duration: 2600, coolDown: 2200),
                    new Orbit(0.6, 6),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Ogre Mage",
            new State(
                new Shoot(10, predictive: 0.3),
                new Prioritize(
                    //new StayAbove(1.2, 160),
                    new Protect(1.2, "Ogre King", acquireRange: 30, protectionRange: 10, reprotectRange: 1),
                    new Orbit(0.5, 6),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Ogre Wizard",
            new State(
                new Shoot(10, coolDown: 300),
                new Prioritize(
                    //new StayAbove(1.2, 160),
                    new Protect(1.2, "Ogre King", acquireRange: 30, protectionRange: 10, reprotectRange: 1),
                    new Orbit(0.5, 6),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Lizard God",
            new State(
                new Spawn("Night Elf Archer", maxChildren: 4, givesNoXp: false),
                new Spawn("Night Elf Warrior", maxChildren: 3, givesNoXp: false),
                new Spawn("Night Elf Mage", maxChildren: 2, givesNoXp: false),
                new Spawn("Night Elf Veteran", maxChildren: 2, givesNoXp: false),
                new Spawn("Night Elf King", maxChildren: 1, givesNoXp: false),
                new Prioritize(
                    //new StayAbove(0.3, 160),
                    new Follow(1, range: 7),
                    new Wander(0.4)
                    ),
                new State("idle",
                    new PlayerWithinTransition(10.2, "normal_attack")
                    ),
                new State("normal_attack",
                    new Shoot(10, count: 3, shootAngle: 3, predictive: 0.5),
                    new TimedTransition(4000, "if_cloaked")
                    ),
                new State("if_cloaked",
                    new Shoot(10, count: 8, shootAngle: 45, fixedAngle: 20, coolDown: 1600, coolDownOffset: 400),
                    new Shoot(10, count: 8, shootAngle: 45, fixedAngle: 42, coolDown: 1600, coolDownOffset: 1200),
                    new PlayerWithinTransition(10, "normal_attack")
                    )
                ),
            new Threshold(.01,
                new TierLoot(5, ItemType.Weapon, 0.28),
                new TierLoot(6, ItemType.Weapon, 0.20),
                new TierLoot(7, ItemType.Weapon, 0.10),
                new TierLoot(5, ItemType.Armor, 0.26),
                new TierLoot(6, ItemType.Armor, 0.18),
                new TierLoot(7, ItemType.Armor, 0.10),
                new TierLoot(3, ItemType.Ring, 0.15),
                new TierLoot(3, ItemType.Ability, 0.15)
                )
            )
        .Init("Night Elf Archer",
            new State(
                new Shoot(10, predictive: 1),
                new Prioritize(
                    //new StayAbove(0.4, 160),
                    new Follow(1.5, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Night Elf Warrior",
            new State(
                new Shoot(3, predictive: 1),
                new Prioritize(
                    //new StayAbove(0.4, 160),
                    new Follow(1.5, range: 1),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Night Elf Mage",
            new State(
                new Shoot(10, predictive: 1),
                new Prioritize(
                    //new StayAbove(0.4, 160),
                    new Follow(1.5, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Night Elf Veteran",
            new State(
                new Shoot(10, predictive: 1),
                new Prioritize(
                    //new StayAbove(0.4, 160),
                    new Follow(1.5, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Night Elf King",
            new State(
                new Shoot(10, predictive: 1),
                new Prioritize(
                    //new StayAbove(0.4, 160),
                    new Follow(1.5, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Undead Dwarf God",
            new State(
                new Spawn("Undead Dwarf Warrior", maxChildren: 3, givesNoXp: false),
                new Spawn("Undead Dwarf Axebearer", maxChildren: 3, givesNoXp: false),
                new Spawn("Undead Dwarf Mage", maxChildren: 3, givesNoXp: false),
                new Spawn("Undead Dwarf King", maxChildren: 2, givesNoXp: false),
                new Spawn("Soulless Dwarf", maxChildren: 1, givesNoXp: false),
                new Prioritize(
                    //new StayAbove(0.3, 160),
                    new Follow(1, range: 7),
                    new Wander(0.4)
                    ),
                new Shoot(10, projectileIndex: 0, count: 3, shootAngle: 15),
                new Shoot(10, projectileIndex: 1, predictive: 0.5, coolDown: 1200)
                ),
            new Threshold(.01,
                new TierLoot(5, ItemType.Weapon, 0.26),
                new TierLoot(6, ItemType.Weapon, 0.18),
                new TierLoot(7, ItemType.Weapon, 0.1),
                new TierLoot(5, ItemType.Armor, 0.26),
                new TierLoot(6, ItemType.Armor, 0.18),
                new TierLoot(7, ItemType.Armor, 0.1),
                new TierLoot(3, ItemType.Ring, 0.1),
                new TierLoot(3, ItemType.Ability, 0.2)
                )
            )
        .Init("Undead Dwarf Warrior",
            new State(
                new Shoot(3),
                new Prioritize(
                    //new StayAbove(1, 160),
                    new Follow(1, range: 1),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Undead Dwarf Axebearer",
            new State(
                new Shoot(3),
                new Prioritize(
                    //new StayAbove(1, 160),
                    new Follow(1, range: 1),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Undead Dwarf Mage",
            new State(
                new State("circle_player",
                    new Shoot(8, predictive: 0.3, coolDown: 1000, coolDownOffset: 500),
                    new Prioritize(
                        //new StayAbove(0.7, 160),
                        new Protect(0.7, "Undead Dwarf King", acquireRange: 11, protectionRange: 10,
                            reprotectRange: 3),
                        new Orbit(0.7, 3.5, acquireRange: 11),
                        new Wander(0.7)
                        ),
                    new TimedTransition(3500, "circle_king")
                    ),
                new State("circle_king",
                    new Shoot(8, count: 5, shootAngle: 72, defaultAngle: 20, predictive: 0.3, coolDown: 1600,
                        coolDownOffset: 500),
                    new Shoot(8, count: 5, shootAngle: 72, defaultAngle: 33, predictive: 0.3, coolDown: 1600,
                        coolDownOffset: 1300),
                    new Prioritize(
                        // new StayAbove(0.7, 160),
                        new Orbit(1.2, 2.5, target: "Undead Dwarf King", acquireRange: 12, radiusVariance: 0.1,
                            speedVariance: 0.1),
                        new Wander(0.7)
                        ),
                    new TimedTransition(3500, "circle_player")
                    )
                )
            )
        .Init("Undead Dwarf King",
            new State(
                new Shoot(3),
                new Prioritize(
                    //new StayAbove(1, 160),
                    new Follow(0.8, range: 1.4),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Soulless Dwarf",
            new State(
                new Shoot(10),
                new State("idle",
                    new PlayerWithinTransition(10.5, "run1")
                    ),
                new State("run1",
                    new Prioritize(
                        //new StayAbove(0.4, 160),
                        new Protect(1.1, "Undead Dwarf God", acquireRange: 16, protectionRange: 10,
                            reprotectRange: 1),
                        new Wander(0.4)
                        ),
                    new TimedTransition(2000, "run2")
                    ),
                new State("run2",
                    new Prioritize(
                        //new StayAbove(0.4, 160),
                        new StayBack(0.8, distance: 4),
                        new Wander(0.4)
                        ),
                    new TimedTransition(1400, "run3")
                    ),
                new State("run3",
                    new Prioritize(
                        //new StayAbove(0.4, 160),
                        new Protect(1, "Undead Dwarf King", acquireRange: 16, protectionRange: 2, reprotectRange: 2),
                        new Protect(1, "Undead Dwarf Axebearer", acquireRange: 16, protectionRange: 2,
                            reprotectRange: 2),
                        new Protect(1, "Undead Dwarf Warrior", acquireRange: 16, protectionRange: 2,
                            reprotectRange: 2),
                        new Wander(0.4)
                        ),
                    new TimedTransition(2000, "idle")
                    )
                )
            )
        .Init("Flayer God",
            new State(
                new Spawn("Flayer", maxChildren: 2, givesNoXp: false),
                new Spawn("Flayer Veteran", maxChildren: 3, givesNoXp: false),
                new Reproduce("Flayer God", densityMax: 2),
                new Prioritize(
                    //new StayAbove(0.4, 155),
                    new Follow(1, range: 7),
                    new Wander(0.4)
                    ),
                new Shoot(10, projectileIndex: 0, predictive: 0.5, coolDown: 400),
                new Shoot(10, projectileIndex: 1, predictive: 1)
                ),
            new Threshold(.01,
                new TierLoot(5, ItemType.Weapon, 0.26),
                new TierLoot(6, ItemType.Weapon, 0.18),
                new TierLoot(7, ItemType.Weapon, 0.1),
                new TierLoot(5, ItemType.Armor, 0.26),
                new TierLoot(6, ItemType.Armor, 0.18),
                new TierLoot(7, ItemType.Armor, 0.1),
                new TierLoot(3, ItemType.Ring, 0.15),
                new TierLoot(3, ItemType.Ability, 0.15)
                )
            )
        .Init("Flayer",
            new State(
                new Shoot(10, predictive: 0.5),
                new Prioritize(
                    //new StayAbove(1, 155),
                    new Follow(1.2, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Flayer Veteran",
            new State(
                new Shoot(10, predictive: 0.5),
                new Prioritize(
                    //new StayAbove(1, 155),
                    new Follow(1.2, range: 7),
                    new Wander(0.4)
                    )
                )
            )
        .Init("Flamer King",
            new State(
                new Spawn("Flamer", maxChildren: 5, coolDown: 10000, givesNoXp: false),
                new State("Attacking",
                    new State("Charge",
                        new Follow(0.7, range: 0.1),
                        new PlayerWithinTransition(2, "Bullet")
                        ),
                    new State("Bullet",
                        new Flash(0xffffaa00, 0.2, 20),
                        new ChangeSize(20, 140),
                        new Shoot(8, coolDown: 200),
                        new TimedTransition(4000, "Wait")
                        ),
                    new State("Wait",
                        new ChangeSize(-20, 80),
                        new TimedTransition(500, "Charge")
                        ),
                    new HpLessTransition(0.2, "FlashBeforeExplode")
                    ),
                new State("FlashBeforeExplode",
                    new Flash(0xffff0000, 1, 1),
                    new TimedTransition(300, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Decay(0)
                    )
                ),

            new TierLoot(2, ItemType.Ring, 0.04)
            )
        .Init("Flamer",
            new State(
                new State("Attacking",
                    new State("Charge",
                        new Prioritize(
                            new Protect(0.7, "Flamer King"),
                            new Follow(0.7, range: 0.1)
                            ),
                        new PlayerWithinTransition(2, "Bullet")
                        ),
                    new State("Bullet",
                        new Flash(0xffffaa00, 0.2, 20),
                        new ChangeSize(20, 130),
                        new Shoot(8, coolDown: 200),
                        new TimedTransition(4000, "Wait")
                        ),
                    new State("Wait",
                        new ChangeSize(-20, 70),
                        new TimedTransition(600, "Charge")
                        ),
                    new HpLessTransition(0.2, "FlashBeforeExplode")
                    ),
                new State("FlashBeforeExplode",
                    new Flash(0xffff0000, 1, 1),
                    new TimedTransition(300, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Decay(0)
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.04)
            )
        .Init("Dragon Egg",
            new State(
                new TransformOnDeath("White Dragon Whelp", probability: 0.3),
                new TransformOnDeath("Juvenile White Dragon", probability: 0.2),
                new TransformOnDeath("Adult White Dragon", probability: 0.1)
                )
            )
        .Init("White Dragon Whelp",
            new State(
                new Shoot(10, count: 2, shootAngle: 20, predictive: 0.3, coolDown: 750),
                new Prioritize(
                    //new StayAbove(1, 150),
                    new Follow(2, range: 2.5, acquireRange: 10.5, duration: 2200, coolDown: 3200),
                    new Wander(0.9)
                    )
                )
            )
        .Init("Juvenile White Dragon",
            new State(
                new Shoot(10, count: 2, shootAngle: 20, predictive: 0.3, coolDown: 750),
                new Prioritize(
                    //new StayAbove(9, 150),
                    new Follow(1.8, range: 2.2, acquireRange: 10.5, duration: 3000, coolDown: 3000),
                    new Wander(0.75)
                    )
                ),
            new Threshold(.01,
                new TierLoot(7, ItemType.Weapon, 0.01),
                new TierLoot(7, ItemType.Armor, 0.02),
                new TierLoot(6, ItemType.Armor, 0.07)
                )
            )
        .Init("Adult White Dragon",
            new State(
                new Shoot(10, count: 3, shootAngle: 15, predictive: 0.3, coolDown: 750),
                new Prioritize(
                    //new StayAbove(9, 150),
                    new Follow(1.4, range: 1.8, acquireRange: 10.5, duration: 4000, coolDown: 2000),
                    new Wander(0.75)
                    )
                ),
            new Threshold(.01,
                new TierLoot(7, ItemType.Armor, 0.05),
                new ItemLoot("Seal of the Divine", 0.015),
                new ItemLoot("White Drake Egg", 0.004)
                )
            )
        .Init("Shield Orc Shield",
            new State(
                new Prioritize(
                    new Orbit(1, 3, target: "Shield Orc Flooder"),
                    new Wander(0.1)
                    ),
                new State("Attacking",
                    new State("Attack",
                        new Flash(0xff000000, 10, 100),
                        new Shoot(10, coolDown: 500),
                        new HpLessTransition(0.5, "Heal"),
                        new EntityNotExistsTransition("Shield Orc Key", 7, "Idling")
                        ),
                    new State("Heal",
                        new HealGroup(7, "Shield Orcs", coolDown: 500),
                        new TimedTransition(500, "Attack"),
                        new EntityNotExistsTransition("Shield Orc Key", 7, "Idling")
                        )
                    ),
                new State("Flash",
                    new Flash(0xff0000, 1, 1),
                    new TimedTransition(300, "Idling")
                    ),
                new State("Idling")
                ),

            new TierLoot(2, ItemType.Ring, 0.01)
            )
        .Init("Shield Orc Flooder",
            new State(
                new Prioritize(
                    new Wander(0.1)
                    ),
                new State("Attacking",
                    new State("Attack",
                        new Flash(0xff000000, 10, 100),
                        new Shoot(10, coolDown: 500),
                        new HpLessTransition(0.5, "Heal"),
                        new EntityNotExistsTransition("Shield Orc Key", 7, "Idling")
                        ),
                    new State("Heal",
                        new HealGroup(7, "Shield Orcs", coolDown: 500),
                        new TimedTransition(500, "Attack"),
                        new EntityNotExistsTransition("Shield Orc Key", 7, "Idling")
                        )
                    ),
                new State("Flash",
                    new Flash(0xff0000, 1, 1),
                    new TimedTransition(300, "Idling")
                    ),
                new State("Idling")
                ),

            new TierLoot(4, ItemType.Ability, 0.01)
            )
        .Init("Shield Orc Key",
            new State(
                new Spawn("Shield Orc Flooder", maxChildren: 1, initialSpawn: 1, coolDown: 10000, givesNoXp: false),
                new Spawn("Shield Orc Shield", maxChildren: 1, initialSpawn: 1, coolDown: 10000, givesNoXp: false),
                new Spawn("Shield Orc Shield", maxChildren: 1, initialSpawn: 1, coolDown: 10000, givesNoXp: false),
                new State("Start",
                    new TimedTransition(500, "Attacking")
                    ),
                new State("Attacking",
                    new Orbit(1, 3, target: "Shield Orc Flooder"),
                    new Order(7, "Shield Orc Flooder", "Attacking"),
                    new Order(7, "Shield Orc Shield", "Attacking"),
                    new HpLessTransition(0.5, "FlashBeforeExplode")
                    ),
                new State("FlashBeforeExplode",
                    new Order(7, "Shield Orc Flooder", "Flash"),
                    new Order(7, "Shield Orc Shield", "Flash"),
                    new Flash(0xff0000, 1, 1),
                    new TimedTransition(300, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Decay(0)
                    )
                ),

            new TierLoot(4, ItemType.Armor, 0.01)
            )
        .Init("Left Horizontal Trap",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                new State("weak_effect",
                    new Shoot(1, fixedAngle: 0, projectileIndex: 1, coolDown: 200),
                    new TimedTransition(2000, "blind_effect")
                    ),
                new State("blind_effect",
                    new Shoot(1, fixedAngle: 0, projectileIndex: 2, coolDown: 200),
                    new TimedTransition(2000, "pierce_effect")
                    ),
                new State("pierce_effect",
                    new Shoot(1, fixedAngle: 0, projectileIndex: 3, coolDown: 200),
                    new TimedTransition(2000, "weak_effect")
                    ),
                new Decay(6000)
                )
            )
        .Init("Top Vertical Trap",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                new State("weak_effect",
                    new Shoot(1, fixedAngle: 90, projectileIndex: 1, coolDown: 200),
                    new TimedTransition(2000, "blind_effect")
                    ),
                new State("blind_effect",
                    new Shoot(1, fixedAngle: 90, projectileIndex: 2, coolDown: 200),
                    new TimedTransition(2000, "pierce_effect")
                    ),
                new State("pierce_effect",
                    new Shoot(1, fixedAngle: 90, projectileIndex: 3, coolDown: 200),
                    new TimedTransition(2000, "weak_effect")
                    ),
                new Decay(6000)
                )
            )
        .Init("45-225 Diagonal Trap",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                new State("weak_effect",
                    new Shoot(1, fixedAngle: 45, projectileIndex: 1, coolDown: 200),
                    new TimedTransition(2000, "blind_effect")
                    ),
                new State("blind_effect",
                    new Shoot(1, fixedAngle: 45, projectileIndex: 2, coolDown: 200),
                    new TimedTransition(2000, "pierce_effect")
                    ),
                new State("pierce_effect",
                    new Shoot(1, fixedAngle: 45, projectileIndex: 3, coolDown: 200),
                    new TimedTransition(2000, "weak_effect")
                    ),
                new Decay(6000)
                )
            )
        .Init("135-315 Diagonal Trap",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                new State("weak_effect",
                    new Shoot(1, fixedAngle: 135, projectileIndex: 1, coolDown: 200),
                    new TimedTransition(2000, "blind_effect")
                    ),
                new State("blind_effect",
                    new Shoot(1, fixedAngle: 135, projectileIndex: 2, coolDown: 200),
                    new TimedTransition(2000, "pierce_effect")
                    ),
                new State("pierce_effect",
                    new Shoot(1, fixedAngle: 135, projectileIndex: 3, coolDown: 200),
                    new TimedTransition(2000, "weak_effect")
                    ),
                new Decay(6000)
                )
            )
        .Init("Urgle",
            new State(
                new DropPortalOnDeath("Spider Den Portal", 0.9),
                new Prioritize(
                    new StayCloseToSpawn(0.8, 3),
                    new Wander(0.5)
                    ),
                new Shoot(8, predictive: 0.3),
                new State("idle",
                    new PlayerWithinTransition(10.5, "toss_horizontal_traps")
                    ),
                new State("toss_horizontal_traps",
                    new TossObject("Left Horizontal Trap", range: 9, angle: 230, coolDown: 100000),
                    new TossObject("Left Horizontal Trap", range: 10, angle: 180, coolDown: 100000),
                    new TossObject("Left Horizontal Trap", range: 9, angle: 140, coolDown: 100000),
                    new TimedTransition(1000, "toss_vertical_traps")
                    ),
                new State("toss_vertical_traps",
                    new TossObject("Top Vertical Trap", range: 8, angle: 200, coolDown: 100000),
                    new TossObject("Top Vertical Trap", range: 10, angle: 240, coolDown: 100000),
                    new TossObject("Top Vertical Trap", range: 10, angle: 280, coolDown: 100000),
                    new TossObject("Top Vertical Trap", range: 8, angle: 320, coolDown: 100000),
                    new TimedTransition(1000, "toss_diagonal_traps")
                    ),
                new State("toss_diagonal_traps",
                    new TossObject("45-225 Diagonal Trap", range: 2, angle: 45, coolDown: 100000),
                    new TossObject("45-225 Diagonal Trap", range: 7, angle: 45, coolDown: 100000),
                    new TossObject("45-225 Diagonal Trap", range: 11, angle: 225, coolDown: 100000),
                    new TossObject("45-225 Diagonal Trap", range: 6, angle: 225, coolDown: 100000),
                    new TossObject("135-315 Diagonal Trap", range: 2, angle: 135, coolDown: 100000),
                    new TossObject("135-315 Diagonal Trap", range: 7, angle: 135, coolDown: 100000),
                    new TossObject("135-315 Diagonal Trap", range: 11, angle: 315, coolDown: 100000),
                    new TossObject("135-315 Diagonal Trap", range: 6, angle: 315, coolDown: 100000),
                    new TimedTransition(1000, "wait")
                    ),
                new State("wait",
                    new TimedTransition(2400, "idle")
                    )
                ),
            new Threshold(.01,
                new TierLoot(5, ItemType.Weapon, 0.26),
                new TierLoot(6, ItemType.Weapon, 0.18),
                new TierLoot(7, ItemType.Weapon, 0.1),
                new TierLoot(5, ItemType.Armor, 0.26),
                new TierLoot(6, ItemType.Armor, 0.18),
                new TierLoot(7, ItemType.Armor, 0.1),
                new TierLoot(3, ItemType.Ring, 0.15),
                new TierLoot(3, ItemType.Ability, 0.15)
                )
            )
        .Init("Kage Kami",
            new State(
                new ScaleHP2(30),
                new DropPortalOnDeath("Manor of the Immortals Portal", 1.0),
                /*            new State("Grave", // Bug
                new SetAltTexture(0),
                new HpLessTransition(.90,"yay i am good")
                ),*/
                new State("yay i am good",
                    new Taunt(0.5, "Kyoufu no kage!"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(20, 120),
                    new SetAltTexture(1),
                    new TimedTransition(2000, "Attack")
                    ),
                new State("Attack",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, false, 0),
                    new Wander(0.4),
                    new SetAltTexture(1),
                    new TimedTransition(5000, "Charge"),
                    new TossObject("Specter Mine", coolDown: 2000),
                    new State("Shoot1",
                        new Shoot(0, count: 1, defaultAngle: 0, rotateAngle: 30, coolDown: 300, projectileIndex: 1),
                        new Shoot(0, count: 1, defaultAngle: 180, rotateAngle: 30, coolDown: 300, projectileIndex: 1),
                        new TimedTransition(1000, "Shoot2")
                        ),
                    new State("Shoot2",
                        new Shoot(20, count: 2, shootAngle: 180, coolDown: 400, projectileIndex: 1),
                        new TimedTransition(400, "Shoot1")
                        )
                    ),
                new State("Charge",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TossObject("Specter Mine", coolDown: 2000),
                    new SetAltTexture(2),
                    new Follow(0.8, 20, 1),
                    new Shoot(20, count: 2, shootAngle: 50, coolDown: 400),
                    new TimedTransition(4000, "Attack")
                   )
                ),
            new Threshold(.01,
                new ItemLoot("Essence Eater", 0.001),
                new ItemLoot("Potion of Vitality", 1),
                new ItemLoot("Potion of Dexterity", 1),
                new ItemLoot("Potion of Defense", 1),
                new ItemLoot("Potion of Speed", 1)
                )
            )
        .Init("Specter Mine",
            new State(
                new State("Waiting",
                    new PlayerWithinTransition(3, "Suicide"),
                    new TimedTransition(4000, "Suicide")
                    ),
                new State("Suicide",
                    new Shoot(60, count: 4, shootAngle: 45),
                    new Suicide()
                    )
                )
            )

        ;
    }
}
