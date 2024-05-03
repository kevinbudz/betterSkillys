using TKR.Shared.resources;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.transitions;
using TKR.WorldServer.logic.behaviors.@new.movements;
using TKR.WorldServer.logic.behaviors.@new;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Mountain = () => Behav()
        .Init("Arena Horseman Anchor",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                )
            )
        .Init("Arena Headless Horseman",
            new State(
                new Spawn("Arena Horseman Anchor", 1, 1),
                new State("EverythingIsCool",
                    new HpLessTransition(0.1, "End"),
                    new State("Circle",
                        new Shoot(15, 3, shootAngle: 25, projectileIndex: 0, coolDown: 1000),
                        new Shoot(15, projectileIndex: 1, coolDown: 1000),
                        new Prioritize(
                            new Orbit(3, 5, 10, "Arena Horseman Anchor")),
                        new TimedTransition(8000, "Shoot")
                        ),
                    new State("Shoot",
                        new ReturnToSpawn(1.5),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new Flash(0xF0E68C, 1, 6),
                        new Shoot(15, 8, projectileIndex: 2, coolDown: 1500),
                        new Shoot(15, projectileIndex: 1, coolDown: 2500),
                        new TimedTransition(6000, "Circle")
                        )
                    ),
                new State("End",
                    new Prioritize(
                        new Follow(1.5, 20, 1),
                        new Wander(0.5)
                        ),
                    new Flash(0xF0E68C, 1, 1000),
                    new Shoot(15, 3, shootAngle: 25, projectileIndex: 0, coolDown: 1000),
                    new Shoot(15, projectileIndex: 1, coolDown: 1000)
                    ),
                new DropPortalOnDeath("Haunted Cemetery Portal", .5)
                )
            )
        .Init("White Demon",
            new State(
                new DropPortalOnDeath("Abyss of Demons Portal", .25),
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                new Shoot(10, count: 3, shootAngle: 20, predictive: 1, coolDown: 500),
                new Reproduce(densityMax: 3)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Attack", 0.05))
        )
        .Init("Sprite God",
            new State(
                new DropPortalOnDeath("Glowing Portal", .25),
                new OrderedBehavior(
                    new NewWander(0.4f)
                    ),
                new Shoot(12, projectileIndex: 0, count: 4, shootAngle: 10),
                new Shoot(10, projectileIndex: 1, predictive: 1),
                new Reproduce(densityMax: 3),
                new Spawn("Sprite Child", 5, 1)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Attack", 0.05))
        )
        .Init("Sprite Child",
            new State(
                new Prioritize(
                    new StayAbove(1, 200),
                    new Protect(0.4, "Sprite God", protectionRange: 1),
                    new Wander(0.4)
                    ),
                new DropPortalOnDeath("Glowing Portal", .15)
                )
            )
        .Init("Medusa",
            new State(
                new DropPortalOnDeath("Snake Pit Portal", .25),
                new StayAbove(1, 200),
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                new Shoot(12, count: 5, shootAngle: 10, coolDown: 1000),
                new Grenade(4, 150, range: 8, coolDown: 3000),
                new Reproduce(densityMax: 3)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Speed", 0.05))
        )
        .Init("Ent God",
            new State(
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                //new Prioritize(
                //    new StayAbove(1, 200),
                //    new Follow(1, range: 7),
                //    new Wander(0.4)
                //    ),
                new Shoot(12, count: 5, shootAngle: 10, predictive: 1, coolDown: 1250),
                new Reproduce(densityMax: 3)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Defense", 0.025))
            )
        .Init("Beholder",
            new State(
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                //new Prioritize(
                //    new StayAbove(1, 200),
                //    new Follow(1, range: 7),
                //    new Wander(0.4)
                //    ),
                new Shoot(12, projectileIndex: 0, count: 5, shootAngle: 72, predictive: 0.5, coolDown: 750),
                new Shoot(10, projectileIndex: 1, predictive: 1),
                new Reproduce(densityMax: 3)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Defense", 0.025))
            )
        .Init("Flying Brain",
            new State(
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                new Prioritize(
                    new StayAbove(1, 200),
                    new Follow(1, range: 7),
                    new Wander(0.4)
                    ),
                new Shoot(12, count: 5, shootAngle: 72, coolDown: 500),
                new Reproduce(densityMax: 3),
                new DropPortalOnDeath("Mad Lab Portal", .17)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Attack", 0.025))
        )
        .Init("Slime God",
            new State(
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                //new Prioritize(
                //    new StayAbove(1, 200),
                //    new Follow(1, range: 7),
                //    new Wander(0.4)
                //    ),
                new Shoot(12, projectileIndex: 0, count: 5, shootAngle: 10, predictive: 1, coolDown: 1000),
                new Shoot(10, projectileIndex: 1, predictive: 1, coolDown: 650),
                new Reproduce(densityMax: 2),
                new DropPortalOnDeath("Toxic Sewers Portal", .3)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Defense", 0.025))
            )
        .Init("Ghost God",
            new State(
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                //new Prioritize(
                //    new StayAbove(1, 200),
                //    new Follow(1, range: 7),
                //    new Wander(0.4)
                //    ),
                new Shoot(12, count: 7, shootAngle: 25, predictive: 0.5, coolDown: 900),
                new Reproduce(densityMax: 3),
                new DropPortalOnDeath("Undead Lair Portal", 0.25)
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Speed", 0.05))
            
        )
        .Init("Rock Bot",
            new State(
                new Spawn("Paper Bot", maxChildren: 1, initialSpawn: 1, coolDown: 10000, givesNoXp: false),
                new Spawn("Steel Bot", maxChildren: 1, initialSpawn: 1, coolDown: 10000, givesNoXp: false),
                new Swirl(speed: 0.6, radius: 3, targeted: false),
                new State("Waiting",
                    new PlayerWithinTransition(15, "Attacking")
                    ),
                new State("Attacking",
                    new Shoot(8, coolDown: 2000),
                    new HealGroup(8, "Papers", coolDown: 1000),
                    new Taunt(0.5, "We are impervious to non-mystic attacks!"),
                    new TimedTransition(10000, "Waiting")
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Attack", 0.205))
            )
        .Init("Paper Bot",
            new State(
                new DropPortalOnDeath("Puppet Theatre Portal", 0.15),
                new Prioritize(
                    new Orbit(0.4, 3, target: "Rock Bot"),
                    new Wander(0.4)
                    ),
                new State("Idle",
                    new PlayerWithinTransition(15, "Attack")
                    ),
                new State("Attack",
                    new Shoot(8, count: 3, shootAngle: 20, coolDown: 800),
                    new HealGroup(8, "Steels", coolDown: 1000),
                    new NoPlayerWithinTransition(30, "Idle"),
                    new HpLessTransition(0.2, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Decay(0)
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Attack", 0.025))
            )
        .Init("Steel Bot",
            new State(
                new Prioritize(
                    new Orbit(0.4, 3, target: "Rock Bot"),
                    new Wander(0.4)
                    ),
                new State("Idle",
                    new PlayerWithinTransition(15, "Attack")
                    ),
                new State("Attack",
                    new Shoot(8, count: 3, shootAngle: 20, coolDown: 800),
                    new HealGroup(8, "Rocks", coolDown: 1000),
                    new Taunt(0.5, "Silly squishy. We heal our brothers in a circle."),
                    new NoPlayerWithinTransition(30, "Idle"),
                    new HpLessTransition(0.2, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Decay(0)
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Speed", 0.05))
            )
        .Init("Djinn",
            new State(
                new DropPortalOnDeath("Treasure Cave Portal", 0.25),
                new State("Idle",
                    new OrderedBehavior(
                        new NewWander(0.4f)
                        ),
                    //new Prioritize(
                    //    new StayAbove(1, 200),
                    //    new Wander(0.4)
                    //    ),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Reproduce(densityMax: 3, densityRadius: 20),
                    new PlayerWithinTransition(8, "Attacking")
                    ),
                new State("Attacking",
                    new State("Bullet",
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 90, coolDownOffset: 0, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 100, coolDownOffset: 200, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 110, coolDownOffset: 400, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 120, coolDownOffset: 600, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 130, coolDownOffset: 800, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 140, coolDownOffset: 1000,shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 150, coolDownOffset: 1200, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 160, coolDownOffset: 1400, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 170, coolDownOffset: 1600, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 180, coolDownOffset: 1800, shootAngle: 90),
                        new Shoot(1, count: 8, coolDown: 10000, fixedAngle: 180, coolDownOffset: 2000, shootAngle: 45),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 180, coolDownOffset: 0, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 170, coolDownOffset: 200, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 160, coolDownOffset: 400, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 150, coolDownOffset: 600, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 140, coolDownOffset: 800, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 130, coolDownOffset: 1000, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 120, coolDownOffset: 1200, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 110, coolDownOffset: 1400, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 100, coolDownOffset: 1600, shootAngle: 90),
                        new Shoot(1, count: 4, coolDown: 10000, fixedAngle: 0, coolDownOffset: 1800, shootAngle: 90),
                        new Shoot(1, count: 16, coolDown: 10000, fixedAngle: 0, coolDownOffset: 2000, shootAngle: 22.5),
                        new TimedTransition(2000, "Wait")
                        ),
                    new State("Wait",
                        new Follow(0.7, range: 0.5),
                        new Flash(0xff00ff00, 0.1, 20),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(2000, "Bullet")
                        ),
                    new NoPlayerWithinTransition(13, "Idle"),
                    new HpLessTransition(0.5, "FlashBeforeExplode")
                    ),
                new State("FlashBeforeExplode",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Flash(0xff0000, 0.3, 3),
                    new TimedTransition(1000, "Explode")
                    ),
                new State("Explode",
                    new Shoot(0, count: 10, shootAngle: 36, fixedAngle: 0),
                    new Suicide()
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Speed", 0.05))
            )
        .Init("Lucky Djinn",
            new State(
                new ScaleHP2(30),
                new DropPortalOnDeath("The Crawling Depths", 1),
                new State("Idle",
                //new Prioritize(
                //    //new StayAbove(1, 200),
                //    new Wander(0.4)
                //    ),
                new OrderedBehavior(
                    new NewWander(0.4f)
                    ),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new PlayerWithinTransition(8, "Attacking")
                    ),
                new State("Attacking",
                    new State("Bullet",
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 90, coolDownOffset: 0, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 100, coolDownOffset: 200, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 110, coolDownOffset: 400, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 120, coolDownOffset: 600, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 130, coolDownOffset: 800, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 140, coolDownOffset: 1000, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 150, coolDownOffset: 1200, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 160, coolDownOffset: 1400, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 170, coolDownOffset: 1600, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 180, coolDownOffset: 1800, shootAngle: 90),
                        new Shoot(1, 8, coolDown: 10000, fixedAngle: 180, coolDownOffset: 2000, shootAngle: 45),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 180, coolDownOffset: 0, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 170, coolDownOffset: 200, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 160, coolDownOffset: 400, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 150, coolDownOffset: 600, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 140, coolDownOffset: 800, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 130, coolDownOffset: 1000, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 120, coolDownOffset: 1200, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 110, coolDownOffset: 1400, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 100, coolDownOffset: 1600, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 90, coolDownOffset: 1800, shootAngle: 90),
                        new Shoot(1, 4, coolDown: 10000, fixedAngle: 90, coolDownOffset: 2000, shootAngle: 22.5),
                        new TimedTransition(2000, "Wait")
                        ),
                    new State("Wait",
                        new Follow(0.7, range: 0.5),
                        new Flash(0xff00ff00, 0.1, 20),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(2000, "Bullet")
                        ),
                    new NoPlayerWithinTransition(13, "Idle"),
                    new HpLessTransition(0.5, "FlashBeforeExplode")
                    ),
                new State("FlashBeforeExplode",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Flash(0xff0000, 0.3, 3),
                    new TimedTransition(1000, "Explode")
                    ),
                new State("Explode",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Shoot(0, 10, 36, fixedAngle: 0),
                    new Suicide()
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Speed", 0.05))
            )
        .Init("Lucky Ent God",
            new State(
                new ScaleHP2(20),
                new DropPortalOnDeath("Woodland Labyrinth", 1),
                //new Prioritize(
                //    //new StayAbove(1, 200),
                //    new Follow(1, range: 7),
                //    new Wander(0.4)
                //    ),
                new OrderedBehavior(
                    new NewFollow(range: 7, speed: 1.0f),
                    new NewWander(0.4f)
                    ),
                new Shoot(12, 5, 10, predictive: 1, coolDown: 1250)

                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            new Threshold(.18, new ItemLoot("Potion of Defense", 0.025))
            )
        .Init("Leviathan",
            new State(
                new DropPortalOnDeath("Puppet Theatre Portal", 0.25),
                new State("Wander",
                    new Swirl(),
                    new Shoot(10, 2, 10, 1, coolDown: 500),
                    new TimedTransition(5000, "Triangle")
                    ),
                new State("Triangle",
                    new State("1",
                        new MoveLine(.7, 40),
                        new Shoot(1, 3, 120, fixedAngle: 34, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 38, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 42, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 46, coolDown: 300),
                        new TimedTransition(1500, "2")
                        ),
                    new State("2",
                        new MoveLine(.7, 160),
                        new Shoot(1, 3, 120, fixedAngle: 94, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 98, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 102, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 106, coolDown: 300),
                        new TimedTransition(1500, "3")
                        ),
                    new State("3",
                        new MoveLine(.7, 280),
                        new Shoot(1, 3, 120, fixedAngle: 274, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 278, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 282, coolDown: 300),
                        new Shoot(1, 3, 120, fixedAngle: 286, coolDown: 300),
                        new TimedTransition(1500, "Wander"))
                    )
                ),
            new TierLoot(5, ItemType.Weapon, 0.08),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new TierLoot(7, ItemType.Weapon, 0.02),
            new TierLoot(8, ItemType.Weapon, 0.01),
            new TierLoot(5, ItemType.Armor, 0.08),
            new TierLoot(6, ItemType.Armor, 0.04),
            new TierLoot(7, ItemType.Armor, 0.02),
            new TierLoot(8, ItemType.Armor, 0.01),
            new TierLoot(3, ItemType.Ring, 0.05),
            new TierLoot(4, ItemType.Ring, 0.025),
            new TierLoot(3, ItemType.Ability, 0.08),
            new TierLoot(4, ItemType.Ability, 0.04),
            
            new Threshold(.18, new ItemLoot("Potion of Defense", 0.025))
            )
        ;
    }
}
