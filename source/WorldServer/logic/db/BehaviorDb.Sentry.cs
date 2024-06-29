using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Sentry = () => Behav()

        .Init("LH Lost Sentry",
                new State(
                    new State("Wait",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new PlayerWithinTransition(10, "Spookyboi")
                    ),
                    new State("Spookyboi",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, false),
                        new Spawn("LH Spectral Sentry", maxChildren: 1, initialSpawn: 0.5),
                        new TimedTransition(3000, "100%")
                    ),
                    //new HpLessTransition(threshold: 1, targetState: "100%"),
                    new State("100%",
                        //new Taunt("100"),
                        new TimedRandomTransition(time: 0, false, "Red_Circle_100", "4Yellow+Bombs_100_0", "Purple_Black_Yellow_Wiggle_100", "3Green_2White_100" /*, "Black_Green_100", "White_Red_Blue_100"*/)
                    ),
                    new State("Red_Circle_100",
                        new TimedRandomTransition(time: 0, false, "Red_Circle_100_0", "Red_Circle_100_2", "Red_Circle_100_4", "Red_Circle_100_6")
                    ),
                    new State("4Yellow+Bombs_100_0",
                        new Shoot(radius: 25, count: 4, projectileIndex: 7, shootAngle: 90, rotateAngle: 10, fixedAngle: 0, coolDown: 200),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 0),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 45),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 90),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 135),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 180),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 225),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 270),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 315),
                        new TimedTransition(time: 2501, randomized: false, targetState: "4Yellow+Bombs_100_1")
                    ),
                    new State("4Yellow+Bombs_100_1",
                        new Shoot(radius: 25, count: 4, projectileIndex: 7, shootAngle: 90, rotateAngle: 10, fixedAngle: 0, coolDown: 200),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 0),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 45),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 90),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 135),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 180),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 225),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 270),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 315),
                        new TimedTransition(time: 2501, randomized: false, targetState: "4Yellow+Bombs_100_2")
                    ),
                    new State("4Yellow+Bombs_100_2",
                        new Shoot(radius: 25, count: 4, projectileIndex: 7, shootAngle: 90, rotateAngle: 10, fixedAngle: 0, coolDown: 200),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 0),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 45),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 90),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 135),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 180),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 225),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 270),
                        new Grenade(radius: 3, damage: 200, range: 9, coolDown: 10000, fixedAngle: 315),
                        new TimedTransition(time: 2501, randomized: false, targetState: "4Yellow+Bombs_100_3")
                    ),
                    new State("4Yellow+Bombs_100_3",
                        new Shoot(radius: 25, count: 4, projectileIndex: 7, shootAngle: 90, rotateAngle: 10, fixedAngle: 0, coolDown: 200),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 0),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 45),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 90),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 135),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 180),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 225),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 270),
                        new Grenade(radius: 3, damage: 200, range: 6, coolDown: 10000, fixedAngle: 315),
                        new TimedTransition(time: 2501, randomized: false, targetState: "4Yellow+Bombs_100_4")
                    ),
                    new State("4Yellow+Bombs_100_4",
                        new Shoot(radius: 25, count: 4, projectileIndex: 7, shootAngle: 90, rotateAngle: 10, fixedAngle: 0, coolDown: 200),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 0),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 45),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 90),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 135),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 180),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 225),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 270),
                        new Grenade(radius: 3, damage: 200, range: 3, coolDown: 10000, fixedAngle: 315),
                        new TimedTransition(time: 2501, randomized: false, targetState: "100%")
                    ),
                    new State("Red_Circle_100_0",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 0, coolDown: 50000),
                        new TimedTransition(1000, "Red_Circle_100_1")
                    ),
                    new State("Red_Circle_100_1",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 45, coolDown: 50000),
                        new TimedTransition(1000, "Red_Circle_100_2")
                    ),
                    new State("Red_Circle_100_2",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 90, coolDown: 50000),
                        new TimedRandomTransition(time: 1000, false, "Red_Circle_100_3", "100%")
                    ),
                    new State("Red_Circle_100_3",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 135, coolDown: 50000),
                        new TimedTransition(1000, "Red_Circle_100_4")
                    ),
                    new State("Red_Circle_100_4",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 180, coolDown: 50000),
                        new TimedRandomTransition(time: 1000, false, "Red_Circle_100_5", "100%")
                    ),
                    new State("Red_Circle_100_5",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 225, coolDown: 50000),
                        new TimedTransition(1000, "Red_Circle_100_6")
                    ),
                    new State("Red_Circle_100_6",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 270, coolDown: 50000),
                        new TimedRandomTransition(time: 1000, false, "Red_Circle_100_7", "100%")
                    ),
                    new State("Red_Circle_100_7",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 315, coolDown: 50000),
                        new TimedTransition(1000, "Red_Circle_100_8")
                    ),
                    new State("Red_Circle_100_8",
                        new Shoot(radius: 25, count: 33, shootAngle: 10.5, fixedAngle: 360, coolDown: 50000),
                        new TimedRandomTransition(time: 1000, false, "Red_Circle_100_0", "100%")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100",
                        new Shoot(radius: 25, count: 12, projectileIndex: 12, fixedAngle: 0, shootAngle: 30, coolDown: 250),
                        new TimedTransition(1745, "Purple_Black_Yellow_Wiggle_100_WarteZeit")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100_WarteZeit",
                        new TimedTransition(250, "Purple_Black_Yellow_Wiggle_100_1")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100_1",
                        new Shoot(radius: 25, count: 12, projectileIndex: 13, fixedAngle: 0, shootAngle: 30, coolDown: 250),
                        new TimedTransition(1745, "Purple_Black_Yellow_Wiggle_100_2_WarteZeit")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100_2_WarteZeit",
                        new TimedTransition(250, "Purple_Black_Yellow_Wiggle_100_2")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100_2",
                        new Shoot(radius: 25, count: 12, projectileIndex: 14, fixedAngle: 0, shootAngle: 30, coolDown: 250),
                        new TimedRandomTransition(time: 1745, false, "Purple_Black_Yellow_Wiggle_100_3_WarteZeit", "100%")
                    ),
                    new State("Purple_Black_Yellow_Wiggle_100_3_WarteZeit",
                        new TimedRandomTransition(time: 250, false, "Purple_Black_Yellow_Wiggle_100", "100%")
                    ),

                    new State("White_Red_Blue_100",
                        new Shoot(radius: 25, count: 16, projectileIndex: 2, fixedAngle: 0, shootAngle: 22, coolDown: 1500),
                        new Shoot(radius: 25, count: 3, projectileIndex: 1, fixedAngle: 0, rotateAngle: 23, shootAngle: 120, coolDown: 250),
                        new Shoot(radius: 25, count: 3, projectileIndex: 0, fixedAngle: 45, rotateAngle: 23, shootAngle: 120, coolDown: 250),
                        new TimedTransition(7500, "100%")
                    ),
                    new State("3Green_2White_100",
                        new Shoot(radius: 25, count: 3, projectileIndex: 10, fixedAngle: 0, rotateAngle: 45, shootAngle: 22, coolDown: 750),
                        new Shoot(radius: 25, count: 2, projectileIndex: 11, fixedAngle: 180, rotateAngle: 45, shootAngle: 22, coolDown: 750),
                        new TimedRandomTransition(time: 3000, false, "3Green_2White_100", "100%")
                    ),
                    new State("Black_Green_100",
                        new Taunt("2"),
                        new TimedTransition(250, "100%")
                    ),
                    new State("White_Blue_Red_100",
                        new Taunt("3"),
                        new TimedTransition(250, "100%")
                    ),
                    new State("4Yellow+Bombs",
                        new Taunt("4"),
                        new TimedTransition(250, "100%")
                    )
                )
            )

        ;
    }
}
