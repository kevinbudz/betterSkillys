#region

using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

#endregion

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ CaveTT = () => Behav()
        .Init("Treasure Flame Trap Fast",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                //new RingAttack(1, 1, 0, 0, 0),
                new State("Wait",
                    new SetAltTexture(0, 0),
                    new TimedTransition(1000, "Start")
                    ),
                new State("Start",
                    new Shoot(100, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                    new SetAltTexture(1, 1),
                    new TimedTransition(140, "Start 2")
                    ),
                new State("Start 2",
                    new Shoot(100, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                    new SetAltTexture(2, 2),
                    new TimedTransition(140, "Start 3")
                    ),
                new State("Start 3",
                    new Shoot(100, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                    new SetAltTexture(3, 3),
                    new TimedTransition(140, "Start 4")
                    ),
                new State("Start 4",
                    new Shoot(100, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                    new SetAltTexture(4, 4),
                    new TimedTransition(140, "Start 5")
                    ),
                new State("Start 5",
                    new Shoot(100, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                    new SetAltTexture(5, 5),
                    new TimedTransition(140, "Wait")
                    )
                )
            )
        .Init("Log Trap Clockwise",
            new State(
                new Shoot(20, 1, projectileIndex: 0, coolDown: 200, seeInvis: true),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new SetAltTexture(0, 3, 100, true),
                new State("Check Ground",
                    new OnGroundTransition("Track N End", "Move Down"),
                    new OnGroundTransition("Track S End", "Move Up"),
                    new OnGroundTransition("Track W End", "Move Left"),
                    new OnGroundTransition("Track E End", "Move Right")
                    ),
                new State("Move Down",
                    new OnGroundTransition("Track N End", "Move Down"),
                    new OnGroundTransition("Track S End", "Move Up"),
                    new OnGroundTransition("Track W End", "Move Left"),
                    new OnGroundTransition("Track E End", "Move Right"),
                    new MoveLine(0.5, 90)
                    ),
                new State("Move Up",
                    new OnGroundTransition("Track N End", "Move Down"),
                    new OnGroundTransition("Track S End", "Move Up"),
                    new OnGroundTransition("Track W End", "Move Left"),
                    new OnGroundTransition("Track E End", "Move Right"),
                    new MoveLine(0.5, -90)
                    ),
                new State("Move Left",
                    new OnGroundTransition("Track N End", "Move Down"),
                    new OnGroundTransition("Track S End", "Move Up"),
                    new OnGroundTransition("Track W End", "Move Left"),
                    new OnGroundTransition("Track E End", "Move Right"),
                    new MoveLine(0.5, 0)
                    ),
                new State("Move Right",
                    new OnGroundTransition("Track N End", "Move Down"),
                    new OnGroundTransition("Track S End", "Move Up"),
                    new OnGroundTransition("Track W End", "Move Left"),
                    new OnGroundTransition("Track E End", "Move Right"),
                    new MoveLine(0.5, 180)
                    )
                )
            )
        .Init("Boulder",
            new State(
                new SetAltTexture(0, 3, 100, true),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new State("Move",
                    new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                    new MoveLine(3, 90),
                    new OnGroundTransition("Tunnel Ground M", "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                )
            )
        .Init("Boulder Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new State("CHeck Player",
                    new PlayerWithinTransition(100, "Start")
                    ),
                new State("Start",
                    new Reproduce("Boulder", 20, 1, coolDown: 200)
                    )
                )
            )
        .Init("Treasure Pot",
            new State(),
            new TierLoot(1, ItemType.Ability, 0.12),
            new TierLoot(2, ItemType.Ability, 0.08),
            new TierLoot(1, ItemType.Ring, 0.1),
            new TierLoot(6, ItemType.Weapon, 0.12),
            new ItemLoot("Magic Potion", 0.8),
            new ItemLoot("Health Potion", 0.8),
            new Threshold(0.01,
                new TierLoot(7, ItemType.Weapon, 0.1),
                new TierLoot(8, ItemType.Weapon, 0.07),
                new TierLoot(9, ItemType.Weapon, 0.05),
                //new TierLoot(10, ItemType.Weapon, 0.03),
                new TierLoot(6, ItemType.Armor, 0.12),
                new TierLoot(7, ItemType.Armor, 0.1),
                new TierLoot(8, ItemType.Armor, 0.07),
                new TierLoot(9, ItemType.Armor, 0.05),
                //new TierLoot(10, ItemType.Armor, 0.03),
                new TierLoot(3, ItemType.Armor, 0.1),
                new TierLoot(4, ItemType.Armor, 0.05),
                //new TierLoot(5, ItemType.Armor, 0.01),
                new TierLoot(2, ItemType.Ring, 0.07),
                new TierLoot(3, ItemType.Ring, 0.05)
                )
            )
        .Init("Treasure Plunderer",
            new State(
                new State("Player",
                    new PlayerWithinTransition(15, "Start")
                    ),
                new State("Start",
                    new Shoot(7, 1, projectileIndex: 0, coolDown: 1),
                    new Grenade(3, 75, 7, coolDown: 1000),
                    new Wander(0.4)
                    )
                ),
            new ItemLoot("Magic Potion", 0.3),
            new ItemLoot("Health Potion", 0.3),
            new Threshold(0.01,
                new ItemLoot("Potion of Defense", 0.03)
                )
            )
        .Init("Treasure Robber",
            new State(
                new State("Player",
                    new PlayerWithinTransition(10, "Start")
                    ),
                new State("Start",
                    new SetAltTexture(0, 0),
                    new Shoot(15, 3, projectileIndex: 0, shootAngle: 20, coolDown: 1000),
                    new TimedTransition(2500, "Invisible"),
                    new Wander(0.4)
                    ),
                new State("Invisible",
                    new SetAltTexture(0, 7, 140),
                    new Shoot(15, 3, projectileIndex: 0, shootAngle: 20, coolDown: 1000),
                    new Wander(0.4),
                    new TimedTransition(6000, "Start")
                    )
                ),
            new ItemLoot("Magic Potion", 0.3),
            new ItemLoot("Health Potion", 0.3)
            )
        .Init("Treasure Thief",
            new State(
                new State("Player",
                    new PlayerWithinTransition(10, "Start")
                    ),
                new State("Start",
                    new Wander(0.6),
                    new StayBack(0.6, 6)
                    )
                ),
            new ItemLoot("Magic Potion", 0.3),
            new ItemLoot("Health Potion", 0.3),
            new Threshold(0.01,
                new ItemLoot("Potion of Attack", 0.01),
                new ItemLoot("Potion of Dexterity", 0.01)
                )
            )
        .Init("Treasure Enemy",
            new State(
                new State("Player",
                    new PlayerWithinTransition(4, "Start")
                    ),
                new State("Start",
                    new Shoot(20, 2, projectileIndex: 0, shootAngle: 20, coolDown: 1000),
                    new Shoot(20, 1, projectileIndex: 1, coolDown: 1000),
                    new NoPlayerWithinTransition(4, "Player"),
                    new Follow(0.4, 6, 1),
                    new Wander(0.4)
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Potion of Speed", 0.01),
                new ItemLoot("Potion of Defense", 0.01),
                new ItemLoot("Potion of Dexterity", 0.01),
                new ItemLoot("Potion of Attack", 0.01)
                )
            )
        .Init("Treasure Rat",
            new State(
                new State("Player",
                    new PlayerWithinTransition(7, "Start")
                    ),
                new State("Start",
                    new SetAltTexture(0, 1, cooldown: 140),
                    new ChangeSize(20, 200),
                    new Shoot(10, 1, projectileIndex: 0, coolDown: 1500),
                    new Follow(0.3, 10, 1),
                    new Wander(0.3)
                    )
                ),
            new ItemLoot("Health Potion", 0.3),
            new ItemLoot("Magic Potion", 0.3)
            )
        .Init("Golden Oryx Effigy",
            new State(
                new ScaleHP2(20),
                new State("Ini",
                    new HpLessTransition(threshold: 0.99, targetState: "Q1 Spawn Minion")
                    ),
                new State("Q1 Spawn Minion",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new TossObject(child: "Gold Planet", range: 7, angle: 0, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 45, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 90, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 135, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 180, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 225, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 270, coolDown: 10000000),
                    new TossObject(child: "Gold Planet", range: 7, angle: 315, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 0, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 90, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 180, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 270, coolDown: 10000000),
                    new ChangeSize(rate: -1, target: 60),
                    new TimedTransition(time: 4000, targetState: "Q1 Invulnerable")
                    ),
                new State("Q1 Invulnerable",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    //order Expand
                    new EntitiesNotExistsTransition(99, "Q1 Vulnerable Transition", "Treasure Oryx Defender")
                    ),
                new State("Q1 Vulnerable Transition",
                    new State("T1",
                        new SetAltTexture(2),
                        new TimedTransition(time: 50, targetState: "T2")
                        ),
                    new State("T2",
                        new SetAltTexture(minValue: 0, maxValue: 1, cooldown: 100, loop: true)
                        ),
                    new TimedTransition(time: 800, targetState: "Q1 Vulnerable")
                    ),
                new State("Q1 Vulnerable",
                    new SetAltTexture(1),
                    new Taunt(0.75, "My protectors!", "My guardians are gone!", "What have you done?", "You destroy my guardians in my house? Blasphemy!"),
                    //order Shrink
                    new HpLessTransition(threshold: 0.75, targetState: "Q2 Invulnerable Transition")
                    ),
                new State("Q2 Invulnerable Transition",
                    new State("T1_2",
                        new SetAltTexture(2),
                        new TimedTransition(time: 50, targetState: "T2_2")
                        ),
                    new State("T2_2",
                        new SetAltTexture(minValue: 0, maxValue: 1, cooldown: 100, loop: true)
                        ),
                    new TimedTransition(time: 800, targetState: "Q2 Spawn Minion")
                    ),
                new State("Q2 Spawn Minion",
                    new SetAltTexture(0),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 0, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 90, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 180, coolDown: 10000000),
                    new TossObject(child: "Treasure Oryx Defender", range: 3, angle: 270, coolDown: 10000000),
                    new ChangeSize(rate: -1, target: 60),
                    new TimedTransition(time: 4000, targetState: "Q2 Invulnerable")
                    ),
                new State("Q2 Invulnerable",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    //order expand
                    new EntitiesNotExistsTransition(99, "Q2 Vulnerable Transition", "Treasure Oryx Defender")
                    ),
                new State("Q2 Vulnerable Transition",
                    new State("T1_3",
                        new SetAltTexture(2),
                        new TimedTransition(time: 50, targetState: "T2_3")
                        ),
                    new State("T2_3",
                        new SetAltTexture(minValue: 0, maxValue: 1, cooldown: 100, loop: true)
                        ),
                    new TimedTransition(time: 800, targetState: "Q2 Vulnerable")
                    ),
                new State("Q2 Vulnerable",
                    new SetAltTexture(1),
                    new Taunt(0.75, "My protectors are no more!", "You Mongrels are ruining my beautiful treasure!", "You won't leave with your pilfered loot!", "I'm weakened"),
                    //Shrink
                    new HpLessTransition(threshold: 0.6, targetState: "Q3 Vulnerable Transition")
                    ),
                new State("Q3 Vulnerable Transition",
                    new State("T1_4",
                        new SetAltTexture(2),
                        new TimedTransition(time: 50, targetState: "T2_4")
                        ),
                    new State("T2_4",
                        new SetAltTexture(minValue: 0, maxValue: 1, cooldown: 100, loop: true)
                        ),
                    new TimedTransition(time: 800, targetState: "Q3")
                    ),
                new State("Q3",
                    new SetAltTexture(1),
                    new State("Attack1",
                        new State("CardinalBarrage",
                            new Grenade(radius: 0.5, damage: 70, range: 0, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 90, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 180, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 270, coolDown: 1000),
                            new TimedTransition(time: 1500, targetState: "OrdinalBarrage")
                            ),
                        new State("OrdinalBarrage",
                            new Grenade(radius: 0.5, damage: 70, range: 0, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 45, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 135, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 225, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 315, coolDown: 1000),
                            new TimedTransition(time: 1500, targetState: "CardinalBarrage2")
                            ),
                        new State("CardinalBarrage2",
                            new Grenade(radius: 0.5, damage: 70, range: 0, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 90, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 180, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 270, coolDown: 1000),
                            new TimedTransition(time: 1500, targetState: "OrdinalBarrage2")
                            ),
                        new State("OrdinalBarrage2",
                            new Grenade(radius: 0.5, damage: 70, range: 0, fixedAngle: 0, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 45, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 135, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 225, coolDown: 1000),
                            new Grenade(radius: 1, damage: 70, range: 3, fixedAngle: 315, coolDown: 1000),
                            new TimedTransition(time: 1500, targetState: "CardinalBarrage")
                            ),
                        new TimedTransition(time: 8500, targetState: "Attack2")
                        ),
                    new State("Attack2",
                        new Flash(color: 0x0000FF, flashPeriod: 0.1, flashRepeats: 10),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 0),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 80, coolDown: 10000000, coolDownOffset: 400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 70, coolDown: 10000000, coolDownOffset: 600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 60, coolDown: 10000000, coolDownOffset: 800),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 50, coolDown: 10000000, coolDownOffset: 1000),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 40, coolDown: 10000000, coolDownOffset: 1200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 30, coolDown: 10000000, coolDownOffset: 1400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 20, coolDown: 10000000, coolDownOffset: 1600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 10, coolDown: 10000000, coolDownOffset: 1800),
                        new Shoot(radius: 0, count: 4, shootAngle: 45, projectileIndex: 2, defaultAngle: 0, coolDown: 10000000, coolDownOffset: 2200),
                        new Shoot(radius: 0, count: 4, shootAngle: 45, projectileIndex: 2, defaultAngle: 0, coolDown: 10000000, coolDownOffset: 2400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 0, coolDown: 10000000, coolDownOffset: 2600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 10, coolDown: 10000000, coolDownOffset: 2800),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 20, coolDown: 10000000, coolDownOffset: 3000),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 30, coolDown: 10000000, coolDownOffset: 3200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 40, coolDown: 10000000, coolDownOffset: 3400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 50, coolDown: 10000000, coolDownOffset: 3600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 60, coolDown: 10000000, coolDownOffset: 3800),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 70, coolDown: 10000000, coolDownOffset: 4000),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 80, coolDown: 10000000, coolDownOffset: 4200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 4400),
                        new Shoot(radius: 0, count: 4, shootAngle: 45, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 4600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 4800),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 5000),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 90, coolDown: 10000000, coolDownOffset: 5200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 80, coolDown: 10000000, coolDownOffset: 5400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 70, coolDown: 10000000, coolDownOffset: 5600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 60, coolDown: 10000000, coolDownOffset: 5800),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 50, coolDown: 10000000, coolDownOffset: 6000),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 40, coolDown: 10000000, coolDownOffset: 6200),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 30, coolDown: 10000000, coolDownOffset: 6400),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 20, coolDown: 10000000, coolDownOffset: 6600),
                        new Shoot(radius: 0, count: 4, shootAngle: 90, projectileIndex: 2, defaultAngle: 10, coolDown: 10000000, coolDownOffset: 6800),
                        new Shoot(radius: 0, count: 4, shootAngle: 45, projectileIndex: 2, defaultAngle: 0, coolDown: 10000000, coolDownOffset: 7000),
                        new TimedTransition(time: 7000, targetState: "Recuperate")
                        ),
                    new State("Recuperate",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new HealSelf(coolDown: 1000, amount: 200),
                        new TimedTransition(time: 3000, targetState: "Attack1")
                        )
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Sword of Golden Fragments", 0.01),
                new ItemLoot("Jewel-Encrusted Helmet", 0.005),
                new ItemLoot("Luminous Body Armor", 0.005),
                new ItemLoot("Ring of Golden Shine", 0.005),
                new ItemLoot(item: "Potion of Defense", probability: 1),
                new ItemLoot(item: "Potion of Attack", probability: 1),
                new ItemLoot(item: "Potion of Speed", probability: 1),
                new ItemLoot(item: "Potion of Dexterity", probability: 0.5),
                new ItemLoot(item: "Potion of Vitality", probability: 0.5),
                new ItemLoot(item: "Potion of Wisdom", probability: 0.5),
                new TierLoot(tier: 10, type: ItemType.Weapon, probability: 0.1),
                new TierLoot(tier: 10, type: ItemType.Armor, probability: 0.1),
                new TierLoot(tier: 11, type: ItemType.Weapon, probability: 0.05),
                new TierLoot(tier: 11, type: ItemType.Armor, probability: 0.05),
                new TierLoot(tier: 5, type: ItemType.Ability, probability: 0.05),
                new TierLoot(tier: 5, type: ItemType.Ring, probability: 0.05)
                )
            )
        .Init("Treasure Oryx Defender",
            new State(
                new Prioritize(
                    new Orbit(speed: 3, radius: 3, acquireRange: 6, target: "Golden Oryx Effigy", speedVariance: 0, radiusVariance: 0)
                    ),
                new Shoot(projectileIndex: 1, radius: 0, count: 8, shootAngle: 45, defaultAngle: 0, coolDown: 3000)
                )
            )
        .Init("Gold Planet",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new EntityNotExistsTransition(target: "Golden Oryx Effigy", dist: 999, targetState: "Die"),
                new Prioritize(
                    new Orbit(speed: 2.5, radius: 7, acquireRange: 20, target: "Golden Oryx Effigy", speedVariance: 0, radiusVariance: 0)
                    ),
                new State("GreySpiral",
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 90, coolDown: 10000, coolDownOffset: 0),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 90, coolDown: 10000, coolDownOffset: 400),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 80, coolDown: 10000, coolDownOffset: 800),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 70, coolDown: 10000, coolDownOffset: 1200),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 1, defaultAngle: 60, coolDown: 10000, coolDownOffset: 1600),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 50, coolDown: 10000, coolDownOffset: 2000),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 40, coolDown: 10000, coolDownOffset: 2400),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 30, coolDown: 10000, coolDownOffset: 2800),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 20, coolDown: 10000, coolDownOffset: 3200),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 1, defaultAngle: 10, coolDown: 10000, coolDownOffset: 3600),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: 0, coolDown: 10000, coolDownOffset: 4000),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: -10, coolDown: 10000, coolDownOffset: 4400),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: -20, coolDown: 10000, coolDownOffset: 4800),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 2, defaultAngle: -30, coolDown: 10000, coolDownOffset: 5200),
                    new Shoot(radius: 0, count: 2, shootAngle: 180, projectileIndex: 1, defaultAngle: -40, coolDown: 10000, coolDownOffset: 5600),
                    new TimedTransition(time: 5600, targetState: "Reset")
                    ),
                new State("Reset",
                    new TimedTransition(time: 0, targetState: "GreySpiral")
                    ),
                new State("Die",
                    new Suicide()
                    )
                )
            )
        ;
    }
}
