using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ OceanTrench = () => Behav()
        .Init("Coral Gift",  //credits to GhostMaree, ???
            new State(
                new State("Texture1",
                    new SetAltTexture(1),
                    new TimedTransition(500, "Texture2")
                    ),
                new State("Texture2",
                    new SetAltTexture(2),
                    new TimedTransition(500, "Texture0")
                    ),
                new State("Texture0",
                    new SetAltTexture(0),
                    new TimedTransition(500, "Texture1")
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Coral Juice", 0.3),
                new ItemLoot("Potion of Mana", 0.04),
                new ItemLoot("Coral Bow", 0.01),
                new ItemLoot("Coral Venom Trap", 0.012),
                new ItemLoot("Wine Cellar Incantation", 0.02),
                new ItemLoot("Coral Silk Armor", 0.04),
                new ItemLoot("Coral Ring", 0.04)
                )
            )

        .Init("Coral Bomb Big",
            new State(
                new State("Spawning",
                    new TossObject("Coral Bomb Small", 1, angle: 30, coolDown: 500),
                    new TossObject("Coral Bomb Small", 1, angle: 90, coolDown: 500),
                    new TossObject("Coral Bomb Small", 1, angle: 150, coolDown: 500),
                    new TossObject("Coral Bomb Small", 1, angle: 210, coolDown: 500),
                    new TossObject("Coral Bomb Small", 1, angle: 270, coolDown: 500),
                    new TossObject("Coral Bomb Small", 1, angle: 330, coolDown: 500),
                    new TimedTransition(500, "Attack")
                    ),
                new State("Attack",
                    new Shoot(4.4, count: 5, fixedAngle: 0, shootAngle: 70),
                    new Suicide()
                    )
                )
            )
        .Init("Coral Bomb Small",
            new State(
                new Shoot(3.8, count: 5, fixedAngle: 0, shootAngle: 70),
                new Suicide()
                )
            )
        .Init("Deep Sea Beast",
            new State(
                new ChangeSize(11, 100),
                new Prioritize(
                    new StayCloseToSpawn(0.2, 2),
                    new Follow(0.2, acquireRange: 4, range: 1)
                    ),
                new Shoot(1.8, count: 1, projectileIndex: 0, coolDown: 1000),
                new Shoot(2.5, count: 1, projectileIndex: 1, coolDown: 1000),
                new Shoot(3.3, count: 1, projectileIndex: 2, coolDown: 1000),
                new Shoot(4.2, count: 1, projectileIndex: 3, coolDown: 1000)
                )
            )
        .Init("Thessal the Mermaid Goddess",
            new State(
                new ScaleHP2(20),
                new TransformOnDeath("Thessal the Mermaid Goddess Wounded", probability: 0.1),
                new TransformOnDeath("Thessal Dropper"),
                new State("Start",
                    new Prioritize(
                        new Wander(0.3),
                        new Follow(0.3, acquireRange: 10, range: 2)
                        ),
                    new EntityNotExistsTransition("Deep Sea Beast", 20, "Spawning Deep"),
                    new HpLessTransition(1, "Attack1")
                    ),
                new State("Main",
                    new Prioritize(
                        new Wander(0.3),
                        new Follow(0.3, acquireRange: 10, range: 2)
                        ),
                    new TimedTransition(0, "Attack1")
                    ),
                new State("Main 2",
                    new Prioritize(
                        new Wander(0.3),
                        new Follow(0.3, acquireRange: 10, range: 2)
                        ),
                    new TimedTransition(0, "Attack2")
                    ),
                new State("Spawning Bomb",
                    new TossObject("Coral Bomb Big", angle: 45),
                    new TossObject("Coral Bomb Big", angle: 135),
                    new TossObject("Coral Bomb Big", angle: 225),
                    new TossObject("Coral Bomb Big", angle: 315),
                    new TimedTransition(1000, "Main")
                    ),
                new State("Spawning Bomb Attack2",
                    new TossObject("Coral Bomb Big", angle: 45),
                    new TossObject("Coral Bomb Big", angle: 135),
                    new TossObject("Coral Bomb Big", angle: 225),
                    new TossObject("Coral Bomb Big", angle: 315),
                    new TimedTransition(1000, "Attack2")
                    ),
                new State("Spawning Deep",
                    new TossObject("Deep Sea Beast", 14, angle: 0, coolDownOffset: 0),
                    new TossObject("Deep Sea Beast", 14, angle: 90, coolDownOffset: 0),
                    new TossObject("Deep Sea Beast", 14, angle: 180, coolDownOffset: 0),
                    new TossObject("Deep Sea Beast", 14, angle: 270, coolDownOffset: 0),
                    new TimedTransition(1000, "Start")
                    ),
                new State("Attack1",
                    new HpLessTransition(0.5, "Attack2"),
                    //new TimedTransition(3000, "Trident", randomized: true),
                    new TimedTransition(3000, "Yellow Wall", randomized: true),
                    new TimedTransition(3000, "Super Trident", randomized: true),
                    new TimedTransition(3000, "Thunder Swirl", randomized: true),
                    new TimedTransition(3000, "Spawning Bomb", randomized: true)
                    ),
                new State("Thunder Swirl",
                    new Shoot(8.8, count: 8, shootAngle: 360 / 8, projectileIndex: 0),
                    new TimedTransition(500, "Thunder Swirl 2")
                    ),
                new State("Thunder Swirl 2",
                    new Shoot(8.8, count: 8, shootAngle: 360 / 8, projectileIndex: 0),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(500, "Thunder Swirl 3")
                    ),
                new State("Thunder Swirl 3",
                    new Shoot(8.8, count: 8, shootAngle: 360 / 8, projectileIndex: 0),
                    new TimedTransition(100, "Main")
                    ),
                new State("Thunder Swirl Attack2",
                    new Shoot(8.8, count: 16, shootAngle: 360 / 16, projectileIndex: 0),
                    new TimedTransition(500, "Thunder Swirl 2 Attack2")
                    ),
                new State("Thunder Swirl 2 Attack2",
                    new Shoot(8.8, count: 16, shootAngle: 360 / 16, projectileIndex: 0),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(500, "Thunder Swirl 3 Attack2")
                    ),
                new State("Thunder Swirl 3 Attack2",
                    new Shoot(8.8, count: 16, shootAngle: 360 / 16, projectileIndex: 0),
                    new TimedTransition(100, "Main 2")
                    ),
                //new State("Trident",
                //new Shoot(21, count: 8, shootAngle: 360 / 4, projectileIndex: 1),
                //new TimedTransition(100, "Start")
                //),
                new State("Super Trident",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 0),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 90),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 180),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 270),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(250, "Super Trident 2")
                    ),
                new State("Super Trident 2",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 45),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 135),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 225),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 315),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(100, "Main")
                    ),
                new State("Super Trident Attack2",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 0),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 90),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 180),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 270),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(250, "Super Trident 2 Attack2")
                    ),
                new State("Super Trident 2 Attack2",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 45),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 135),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 225),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 315),
                    new TimedTransition(250, "Super Trident 3 Attack2")
                    ),
                new State("Super Trident 3 Attack2",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 0),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 90),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 180),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 270),
                    new TossObject("Coral Bomb Big"),
                    new TimedTransition(250, "Super Trident 4 Attack2")
                    ),
                new State("Super Trident 4 Attack2",
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 45),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 135),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 225),
                    new Shoot(21, count: 2, shootAngle: 25, projectileIndex: 2, angleOffset: 315),
                    new TimedTransition(100, "Main 2")
                    ),
                new State("Yellow Wall",
                    new Flash(0xFFFF00, .1, 15),
                    new Prioritize(
                        new StayCloseToSpawn(0.3, 1)
                        ),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(500, "Yellow Wall 2")
                    ),
                new State("Yellow Wall 2",
                    new Flash(0xFFFF00, .1, 15),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(500, "Yellow Wall 3")
                    ),
                new State("Yellow Wall 3",
                    new Flash(0xFFFF00, .1, 15),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(100, "Main")
                    ),
                new State("Yellow Wall Attack2",
                    new Flash(0xFFFF00, .1, 15),
                    new Prioritize(
                        new StayCloseToSpawn(0.3, 1)
                        ),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(500, "Yellow Wall 2 Attack2")
                    ),
                new State("Yellow Wall 2 Attack2",
                    new Flash(0xFFFF00, .1, 15),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(500, "Yellow Wall 3 Attack2")
                    ),
                new State("Yellow Wall 3 Attack2",
                    new Flash(0xFFFF00, .1, 15),
                    new Shoot(18, count: 30, fixedAngle: 6, projectileIndex: 3),
                    new TimedTransition(100, "Main 2")
                    ),
                new State("Attack2",
                    //new TimedTransition(500, "Trident", randomized: true),
                    new TimedTransition(500, "Yellow Wall Attack2", randomized: true),
                    new TimedTransition(500, "Super Trident Attack2", randomized: true),
                    new TimedTransition(500, "Thunder Swirl Attack2", randomized: true),
                    new TimedTransition(500, "Spawning Bomb", randomized: true)
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Coral Bow", 0.01),
                new ItemLoot("Coral Venom Trap", 0.00125),
                new ItemLoot("Coral Silk Armor", 0.01),
                new ItemLoot("Coral Ring", 0.01),
                new ItemLoot("Ocean Trench Key", 0.01, 0, 0.03)
                ),
            new Threshold(0.02,
                new ItemLoot("Potion of Mana", 1),
                new ItemLoot("Potion of Wisdom", 0.5)
                ),
            new Threshold(.005,
                LootTemplates.BasicDrop()
            )
        )
        .Init("Thessal Dropper",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new TransformOnDeath("Ocean Vent"),
                new State("Idle",
                    new EntityNotExistsTransition("Thessal the Mermaid Goddess", 100, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    ))
            )
        .Init("Thessal the Mermaid Goddess Wounded",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new Taunt("Is King Alexander alive?"),
                new TimedTransition(12000, "Fail"),
                new State("Texture1",
                    new SetAltTexture(1),
                    new TimedTransition(250, "Texture2")
                    ),
                new State("Texture2",
                    new SetAltTexture(0),
                    new TimedTransition(250, "Texture1")
                    ),
                new State("Prize",
                    new Taunt("Thank you kind sailor."),
                    new TossObject("Coral Gift", range: 5, angle: 45),
                    new TossObject("Coral Gift", range: 5, angle: 135),
                    new TossObject("Coral Gift", range: 5, angle: 235),
                    new TimedTransition(0, "Suicide")
                    ),
                new State("Fail",
                    new Taunt("You speak LIES!!"),
                    new TimedTransition(0, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                )
            )
        .Init("Fishman Warrior",
            new State(
                new State("Start",
                    new Prioritize(
                        new Follow(0.6, acquireRange: 9, range: 2)
                        ),
                    new Orbit(1, 5, 9, target: null),
                    new Shoot(9, 3, projectileIndex: 0, shootAngle: 10, coolDown: 500),
                    new Shoot(9, count: 6, fixedAngle: 0, projectileIndex: 2, coolDown: 2000),
                    new NoPlayerWithinTransition(9, "Range Shoot")
                    ),
                new State("Range Shoot",
                    new Prioritize(
                        new StayCloseToSpawn(0.2, 3),
                        new Wander(0.3)
                        ),
                    new Shoot(12, 1, projectileIndex: 1, coolDownOffset: 250),
                    new PlayerWithinTransition(9, "Start")
                    ))
            )
        .Init("Fishman",
            new State(
                new Prioritize(
                    new Follow(0.7, acquireRange: 9, range: 1)
                    ),
                new Shoot(9, count: 1, projectileIndex: 1, coolDown: 2000),
                new Shoot(9, 1, projectileIndex: 0, coolDownOffset: 250),
                new Shoot(9, 3, projectileIndex: 0, shootAngle: 10, coolDownOffset: 500)
                )
            )
        .Init("Sea Mare",
            new State(
                new Charge(2.0, 8, 4000),
                new Wander(0.4),
                new State("Shoot 1",
                    new Shoot(9, count: 3, projectileIndex: 1, coolDown: 500),
                    new TimedTransition(5000, "Shoot 2")
                    ),
                new State("Shoot 2",
                    new Shoot(10, count: 8, shootAngle: 10, projectileIndex: 0, coolDownOffset: 500),
                    new Shoot(10, count: 8, shootAngle: 10, angleOffset: 45, projectileIndex: 0, coolDownOffset: 1000),
                    new Shoot(10, count: 8, shootAngle: 10, angleOffset: 135, projectileIndex: 0, coolDownOffset: 1500),
                    new TimedTransition(3000, "Shoot 1")
                    )
                )
            )
        .Init("Sea Horse",
            new State(
                new Orbit(0.2, 2, acquireRange: 10, target: "Sea Mare"),
                new Wander(0.2),
                new State("Shoot 1",
                    new Shoot(9, count: 1, projectileIndex: 0, coolDownOffset: 250),
                    new Shoot(9, count: 2, shootAngle: 5, projectileIndex: 0, coolDownOffset: 500),
                    new Shoot(9, count: 3, shootAngle: 5, projectileIndex: 0, coolDownOffset: 750)
                    )
                )
            )
        .Init("Giant Squid",
            new State(
                new Shoot(10, 1, projectileIndex: 0, coolDown: 100),
                new Follow(0.8, acquireRange: 12, range: 1),
                new State("Toss",
                    new TossObject("Ink Bubble"),
                    new TimedTransition(100, "Toss 2")
                    ),
                new State("Toss 2",
                    new TossObject("Ink Bubble"),
                    new TimedTransition(100, "Attack 1")
                    ),
                new State("Attack 1",
                    new Shoot(10, 4, shootAngle: 15, projectileIndex: 1, coolDown: 250),
                    new TimedTransition(20000, "Toss")
                    )
                )
            )
        .Init("Ink Bubble",
            new State(
                new Shoot(10, 1, projectileIndex: 0, coolDown: 100)
                )
            )
        .Init("Sea Slurp Home",
            new State(
                new Spawn("Grey Sea Slurp", maxChildren: 8, initialSpawn: 0.5)
                )
            )
        .Init("Grey Sea Slurp",
            new State(
                new StayCloseToSpawn(0.5, 10),
                new State("Shoot and Move",
                    new Prioritize(
                        new Follow(0.3, acquireRange: 10, range: 4),
                        new Wander(0.2)
                        ),
                    new Shoot(8, 1, projectileIndex: 0, coolDown: 300),
                    new TimedTransition(900, "Wall Shoot")
                    ),
                new State("Wall Shoot",
                    new Shoot(8, 6, projectileIndex: 1, fixedAngle: 2, coolDown: 750),
                    new TimedTransition(1500, "Shoot and Move")
                    )
                )
            )
        .Init("Ocean Vent", new State(new RestoresBreathBehavior()));
    }
}
