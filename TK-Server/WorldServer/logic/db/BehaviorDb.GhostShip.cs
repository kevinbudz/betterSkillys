using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ GhostShip = () => Behav()
        //made by omni the greatest rapper ever
        .Init("Vengeful Spirit",
            new State(
                new State("Start",
                    new ChangeSize(50, 120),
                    new Prioritize(
                        new Follow(0.5, 8, 1),
                        new Wander(0.3)
                        ),
                    new Shoot(8.4, count: 3, projectileIndex: 0, shootAngle: 16, coolDown: 800),
                    new TimedTransition(1000, "Vengeful")
                    ),
                new State("Vengeful",
                    new Prioritize(
                        new Follow(0.5, 8, 1),
                        new Wander(0.3)
                        ),
                    new Shoot(8.4, count: 3, projectileIndex: 0, shootAngle: 16, coolDown: 1245),
                    new TimedTransition(3000, "Vengeful2")
                    ),
                new State("Vengeful2",
                    new ReturnToSpawn(speed: 1),
                    new Shoot(8.4, count: 3, projectileIndex: 0, shootAngle: 16, coolDown: 750),
                    new TimedTransition(1500, "Vengeful")
                    )))
        .Init("Water Mine",
            new State(
                new State("Seek",
                    new Prioritize(
                        new Follow(.9, 8, 1),
                        new Wander(0.3)
                        ),
                    new TimedTransition(3750, "Boom")
                    ),
                new State("Boom",
                    new Shoot(8.4, count: 10, projectileIndex: 0, coolDown: 700),
                    new Suicide()
                    )))
        .Init("Beach Spectre",
            new State(
                new State("Fight",
                    new Wander(0.3),
                    new ChangeSize(10, 120),
                    new Shoot(8.4, count: 3, projectileIndex: 0, shootAngle: 14, coolDown: 1250)
                    )))

        .Init("Beach Spectre Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Spawn",
                    new Reproduce("Beach Spectre", densityMax: 1, densityRadius: 3, coolDown: 1250)
                    )))
        .Init("Tempest Cloud",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Start1",
                    new ChangeSize(70, 130),
                    new TimedTransition(3000, "Start2")
                    ),
                new State("Start2",
                    new SetAltTexture(1),
                    new TimedTransition(1, "Start3")
                    ),
                new State("Start3",
                    new SetAltTexture(2),
                    new TimedTransition(1, "Start4")
                    ),
                new State("Start4",
                    new SetAltTexture(3),
                    new TimedTransition(1, "Start5")
                    ),
                new State("Start5",
                    new SetAltTexture(4),
                    new TimedTransition(1, "Start6")
                    ),
                new State("Start6",
                    new SetAltTexture(5),
                    new TimedTransition(1, "Start7")
                    ),
                new State("Start7",
                    new SetAltTexture(6),
                    new TimedTransition(1, "Start8")
                    ),
                new State("Start8",
                    new SetAltTexture(7),
                    new TimedTransition(1, "Start9")
                    ),
                new State("Start9",
                    new SetAltTexture(8),
                    new TimedTransition(1, "Final")
                    ),
                new State("Final",
                    new SetAltTexture(9),
                    new TimedTransition(1, "CircleAndStorm")
                    ),
                new State("CircleAndStorm",
                    new Orbit(1, 9, 20, "Ghost Ship Anchor", speedVariance: 0.1),
                    new Shoot(8.4, count: 7, projectileIndex: 0, coolDown: 1000)
                    )))
        .Init("Ghost Ship Anchor",
            new State(
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("tempestcloud",
                    new InvisiToss("Tempest Cloud", 9, 0, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 45, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 90, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 135, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 180, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 225, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 270, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 315, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 350, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 250, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 110, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 200, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 10, coolDown: 9999999),
                    new InvisiToss("Tempest Cloud", 9, 290, coolDown: 9999999),

                    //Spectre Spawner
                    new InvisiToss("Beach Spectre Spawner", 17, 0, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 45, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 90, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 135, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 180, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 225, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 270, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 315, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 250, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 110, coolDown: 9999999),
                    new InvisiToss("Beach Spectre Spawner", 17, 200, coolDown: 9999999),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    )

                ))
        .Init("Ghost Ship",
            new State(
                new ScaleHP2(20),
                new DropPortalOnDeath("Davy Jones' Locker Portal", 1, 120),
                new State("idle",
                    new SetAltTexture(1),
                    new Wander(1),
                    new DamageTakenTransition(2000, "pause")
                    ),
                new State("pause",
                    new SetAltTexture(2),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new TimedTransition(2000, "start")
                    ),
                new State("start",
                    new SetAltTexture(0),
                    new Reproduce("Vengeful Spirit", densityMax: 2, coolDown: 2500),
                    new TimedTransition(15000, "midfight"),
                    new State("2",
                        new SetAltTexture(0),
                        new Prioritize(
                            new Wander(0.1),
                            new StayBack(0.1, 5)
                            ),
                        new Shoot(12, count: 1, projectileIndex: 0, coolDown: 450),
                        new Shoot(12, count: 3, projectileIndex: 0, shootAngle: 20, coolDown: 1050),
                        new TimedTransition(3250, "1")
                        ),
                    new State("1",
                        new TossObject("Water Mine", 7, coolDown: 1000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new ReturnToSpawn(speed: 1),
                        new Shoot(12, count: 1, projectileIndex: 0, coolDown: 450),
                        new Shoot(12, count: 3, projectileIndex: 0, shootAngle: 20, coolDown: 1050),
                        new TimedTransition(1500, "2")
                        )
                    ),

                new State("midfight",
                    new Order(100, "Ghost Ship Anchor", "tempestcloud"),
                    new Reproduce("Vengeful Spirit", densityMax: 1, coolDown: 5000),
                    new TossObject("Water Mine", 5, coolDown: 2250),
                    new TimedTransition(10000, "countdown"),
                    new State("2",
                        new SetAltTexture(0),
                        new ReturnToSpawn(speed: 1),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Shoot(10, count: 4, projectileIndex: 0, coolDownOffset: 800, angleOffset: 270, coolDown: 1000),
                        new Shoot(10, count: 4, projectileIndex: 0, coolDownOffset: 800, angleOffset: 90, coolDown: 1000),
                        new Shoot(8.4, count: 1, projectileIndex: 1, coolDown: 1250),
                        new TimedTransition(3000, "1")
                        ),
                    new State("1",
                        new Prioritize(
                            new Follow(0.8, 8, 1),
                            new Wander(0.5)
                            ),
                        new Taunt(1.00, "Fire at will!"),
                        new Shoot(8.4, count: 2, shootAngle: 25, projectileIndex: 1, coolDown: 1250),
                        new Shoot(8.4, count: 6, projectileIndex: 0, shootAngle: 10, coolDown: 950),
                        new TimedTransition(4000, "2")
                        )
                    ),
                new State("countdown",
                    new Wander(0.3),
                    new Timed(1000,
                        new Taunt(1.00, "Ready..")
                        ),
                    new Timed(2000,
                        new Taunt(1.00, "Aim..")
                        ),
                    new Shoot(8.4, count: 1, projectileIndex: 0, coolDown: 450),
                    new Shoot(8.4, count: 5, projectileIndex: 0, shootAngle: 20, coolDown: 750),
                    new TimedTransition(2000, "fire")
                    ),
                new State("fire",
                    new Prioritize(
                        new Follow(0.3, 8, 1),
                        new Wander(0.1)
                        ),
                    new Shoot(10, count: 4, projectileIndex: 1, coolDownOffset: 1100, angleOffset: 270, coolDown: 850),
                    new Shoot(10, count: 4, projectileIndex: 1, coolDownOffset: 1100, angleOffset: 90, coolDown: 850),
                    new Shoot(8.4, count: 10, projectileIndex: 0, coolDown: 1300),
                    new TimedTransition(3400, "midfight")
                    )

                ),
            new ItemLoot("Ghost Pirate Rum", 1),
            new Threshold(0.01,
                new ItemLoot("Trap of the Vile Spirit", 0.001)
                ),
            new Threshold(.005,
                LootTemplates.BasicDrop()
                ),
            new Threshold(.005,
                LootTemplates.BasicPots()
                )
            )

        ;
    }
}
