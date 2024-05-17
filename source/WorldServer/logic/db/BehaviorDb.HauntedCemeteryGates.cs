using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;
using WorldServer.logic.behaviors.@new.movements;
//by GhostMaree
namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ HauntedCemeteryGates = () => Behav()
            .Init("Area 2 Controller",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TransformOnDeath("Haunted Cemetery Graves Portal"),
                    new State("Start",
                        new PlayerWithinTransition(4, "1")
                        ),
                    new State("1",
                        new TimedTransition(0, "2")
                        ),
                    new State("2",
                        new SetAltTexture(2),
                        new TimedTransition(100, "3")
                        ),
                    new State("3",
                        new SetAltTexture(1),
                        new Taunt(true, "Congratulations on making it past the first area! This area will not be so easy!"),
                        new TimedTransition(500, "4")
                        ),
                    new State("4",
                        new Taunt(true, "Say,'READY' when you are ready to face your opponeants.", "Prepare yourself...Say, 'READY' when you wish the battle to begin!"),
                        new TimedTransition(0, "5")
                        ),
                    //repeat
                    new State("5",
                        new PlayerTextTransition("7", "ready"),
                        new SetAltTexture(3),
                        new TimedTransition(150, "6")
                        ),
                    new State("6",
                        new PlayerTextTransition("7", "ready"),
                        new SetAltTexture(4),
                        new TimedTransition(150, "6_1")
                        ),
                    new State("6_1",
                        new PlayerTextTransition("7", "ready"),
                        new SetAltTexture(3),
                        new TimedTransition(150, "6_2")
                        ),
                    new State("6_2",
                        new PlayerTextTransition("7", "ready"),
                        new SetAltTexture(4),
                        new TimedTransition(150, "6_3")
                        ),
                    new State("6_3",
                        new PlayerTextTransition("7", "ready"),
                        new SetAltTexture(3),
                        new TimedTransition(150, "6_4")
                        ),
                    new State("6_4",
                        new SetAltTexture(1),
                        new PlayerTextTransition("7", "ready")
                        ),
                    new State("7",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 6"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 6"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 6"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 6"),
                        new EntityExistsTransition("Arena Ghost 2", 999, "Check 1")
                        ),
                    new State("Check 1",
                        new EntitiesNotExistsTransition(100, "8", "Arena Ghost 1", "Arena Ghost 2", "Arena Possessed Girl")
                        ),
                    new State("8",
                        new SetAltTexture(2),
                        new TimedTransition(0, "9")
                        ),
                    new State("9",
                        new SetAltTexture(1),
                        new TimedTransition(500, "10")
                        ),
                    new State("10",
                        new Taunt(true, "The next wave will appear in 3 seconds. Prepare yourself!", "l hope you're prepared because the next wave is in 3 seconds.", "The next onslaught will begin in 3 seconds!", "You have 3 seconds until your next challenge!", "3 seconds until the next attack!"),
                        new TimedTransition(0, "11")
                        ),
                    new State("11",
                        new SetAltTexture(3),
                        new TimedTransition(150, "12")
                        ),
                    new State("12",
                        new SetAltTexture(4),
                        new TimedTransition(150, "13")
                        ),
                    new State("13",
                        new SetAltTexture(3),
                        new TimedTransition(150, "14")
                        ),
                    new State("14",
                        new SetAltTexture(4),
                        new TimedTransition(150, "15")
                        ),
                    new State("15",
                        new SetAltTexture(3),
                        new TimedTransition(150, "16")
                        ),
                    new State("16",
                        new SetAltTexture(4),
                        new TimedTransition(150, "17")
                        ),
                    new State("17",
                        new SetAltTexture(3),
                        new TimedTransition(150, "18")
                        ),
                    new State("18",
                        new SetAltTexture(4),
                        new TimedTransition(150, "19")
                        ),
                    new State("19",
                        new SetAltTexture(3),
                        new TimedTransition(150, "20")
                        ),
                    new State("20",
                        new SetAltTexture(4),
                        new TimedTransition(150, "21")
                        ),
                    new State("21",
                        new SetAltTexture(3),
                        new TimedTransition(150, "22")
                        ),
                    new State("22",
                        new SetAltTexture(4),
                        new TimedTransition(150, "23")
                        ),
                    new State("23",
                        new SetAltTexture(3),
                        new TimedTransition(150, "24")
                        ),
                    new State("24",
                        new SetAltTexture(4),
                        new TimedTransition(150, "25")
                        ),
                    new State("25",
                        new SetAltTexture(1),
                        new TimedTransition(100, "26")
                        ),
                    new State("26",
                        new SetAltTexture(2),
                        new TimedTransition(100, "27")
                        ),
                    new State("27",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 7"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 7"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 7"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 7"),
                        new EntityExistsTransition("Arena Ghost 2", 999, "Check 2")
                        ),
                    new State("Check 2",
                        new EntitiesNotExistsTransition(100, "28", "Arena Ghost 1", "Arena Ghost 2", "Arena Possessed Girl")
                        ),
                    new State("28",
                        new SetAltTexture(2),
                        new TimedTransition(0, "29")
                        ),
                    new State("29",
                        new SetAltTexture(1),
                        new TimedTransition(500, "30")
                        ),
                    new State("30",
                        new Taunt(true, "The next wave will appear in 3 seconds. Prepare yourself!", "l hope you're prepared because the next wave is in 3 seconds.", "The next onslaught will begin in 3 seconds!", "You have 3 seconds until your next challenge!", "3 seconds until the next attack!"),
                        new TimedTransition(0, "31")
                        ),
                    new State("31",
                        new SetAltTexture(3),
                        new TimedTransition(150, "32")
                        ),
                    new State("32",
                        new SetAltTexture(4),
                        new TimedTransition(150, "33")
                        ),
                    new State("33",
                        new SetAltTexture(3),
                        new TimedTransition(150, "34")
                        ),
                    new State("34",
                        new SetAltTexture(4),
                        new TimedTransition(150, "35")
                        ),
                    new State("35",
                        new SetAltTexture(3),
                        new TimedTransition(150, "36")
                        ),
                    new State("36",
                        new SetAltTexture(4),
                        new TimedTransition(150, "37")
                        ),
                    new State("37",
                        new SetAltTexture(3),
                        new TimedTransition(150, "38")
                        ),
                    new State("38",
                        new SetAltTexture(4),
                        new TimedTransition(150, "39")
                        ),
                    new State("39",
                        new SetAltTexture(3),
                        new TimedTransition(150, "40")
                        ),
                    new State("40",
                        new SetAltTexture(4),
                        new TimedTransition(150, "41")
                        ),
                    new State("41",
                        new SetAltTexture(3),
                        new TimedTransition(150, "42")
                        ),
                    new State("42",
                        new SetAltTexture(4),
                        new TimedTransition(150, "43")
                        ),
                    new State("43",
                        new SetAltTexture(3),
                        new TimedTransition(150, "44")
                        ),
                    new State("44",
                        new SetAltTexture(4),
                        new TimedTransition(150, "45")
                        ),
                    new State("45",
                        new SetAltTexture(1),
                        new TimedTransition(150, "46")
                        ),
                    new State("46",
                        new SetAltTexture(2),
                        new TimedTransition(150, "47")
                        ),
                    new State("47",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 8"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 8"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 8"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 8"),
                        new EntityExistsTransition("Arena Ghost 2", 999, "Check 3")
                        ),
                    new State("Check 3",
                        new EntitiesNotExistsTransition(100, "48", "Arena Ghost 1", "Arena Ghost 2", "Arena Possessed Girl")
                        ),
                    new State("48",
                        new SetAltTexture(2),
                        new TimedTransition(0, "49")
                        ),
                    new State("49",
                        new SetAltTexture(1),
                        new TimedTransition(500, "50")
                        ),
                    new State("50",
                        new Taunt(true, "The next wave will appear in 3 seconds. Prepare yourself!", "l hope you're prepared because the next wave is in 3 seconds.", "The next onslaught will begin in 3 seconds!", "You have 3 seconds until your next challenge!", "3 seconds until the next attack!"),
                        new TimedTransition(0, "51")
                        ),
                    new State("51",
                        new SetAltTexture(3),
                        new TimedTransition(150, "52")
                        ),
                    new State("52",
                        new SetAltTexture(4),
                        new TimedTransition(150, "53")
                        ),
                    new State("53",
                        new SetAltTexture(3),
                        new TimedTransition(150, "54")
                        ),
                    new State("54",
                        new SetAltTexture(4),
                        new TimedTransition(150, "55")
                        ),
                    new State("55",
                        new SetAltTexture(3),
                        new TimedTransition(150, "56")
                        ),
                    new State("56",
                        new SetAltTexture(4),
                        new TimedTransition(150, "57")
                        ),
                    new State("57",
                        new SetAltTexture(3),
                        new TimedTransition(150, "58")
                        ),
                    new State("58",
                        new SetAltTexture(4),
                        new TimedTransition(150, "59")
                        ),
                    new State("59",
                        new SetAltTexture(3),
                        new TimedTransition(150, "60")
                        ),
                    new State("60",
                        new SetAltTexture(4),
                        new TimedTransition(150, "61")
                        ),
                    new State("61",
                        new SetAltTexture(3),
                        new TimedTransition(150, "62")
                        ),
                    new State("62",
                        new SetAltTexture(4),
                        new TimedTransition(150, "63")
                        ),
                    new State("63",
                        new SetAltTexture(3),
                        new TimedTransition(150, "64")
                        ),
                    new State("64",
                        new SetAltTexture(4),
                        new TimedTransition(150, "65")
                        ),
                    new State("65",
                        new SetAltTexture(1),
                        new TimedTransition(100, "66")
                        ),
                    new State("66",
                        new SetAltTexture(2),
                        new TimedTransition(100, "67")
                        ),
                    new State("67",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 9"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 9"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 9"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 9"),
                        new EntityExistsTransition("Arena Ghost 2", 999, "Check 4")
                        ),
                    new State("Check 4",
                        new EntitiesNotExistsTransition(100, "68", "Arena Ghost 1", "Arena Ghost 2", "Arena Possessed Girl")
                        ),
                    new State("68",
                        new SetAltTexture(2),
                        new TimedTransition(0, "69")
                        ),
                    new State("69",
                        new SetAltTexture(1),
                        new TimedTransition(500, "70")
                        ),
                    new State("70",
                        new Taunt(true, "The next wave will appear in 3 seconds. Prepare yourself!", "l hope you're prepared because the next wave is in 3 seconds.", "The next onslaught will begin in 3 seconds!", "You have 3 seconds until your next challenge!", "3 seconds until the next attack!"),
                        new TimedTransition(0, "71")
                        ),
                    new State("71",
                        new SetAltTexture(3),
                        new TimedTransition(150, "72")
                        ),
                    new State("72",
                        new SetAltTexture(4),
                        new TimedTransition(150, "73")
                        ),
                    new State("73",
                        new SetAltTexture(3),
                        new TimedTransition(150, "74")
                        ),
                    new State("74",
                        new SetAltTexture(4),
                        new TimedTransition(150, "75")
                        ),
                    new State("75",
                        new SetAltTexture(3),
                        new TimedTransition(150, "76")
                        ),
                    new State("76",
                        new SetAltTexture(4),
                        new TimedTransition(150, "77")
                        ),
                    new State("77",
                        new SetAltTexture(3),
                        new TimedTransition(150, "78")
                        ),
                    new State("78",
                        new SetAltTexture(4),
                        new TimedTransition(150, "79")
                        ),
                    new State("79",
                        new SetAltTexture(3),
                        new TimedTransition(150, "80")
                        ),
                    new State("80",
                        new SetAltTexture(4),
                        new TimedTransition(150, "81")
                        ),
                    new State("81",
                        new SetAltTexture(3),
                        new TimedTransition(150, "82")
                        ),
                    new State("82",
                        new SetAltTexture(4),
                        new TimedTransition(150, "83")
                        ),
                    new State("83",
                        new SetAltTexture(3),
                        new TimedTransition(150, "84")
                        ),
                    new State("84",
                        new SetAltTexture(4),
                        new TimedTransition(150, "85")
                        ),
                    new State("85",
                        new SetAltTexture(1),
                        new TimedTransition(100, "86")
                        ),
                    new State("86",
                        new SetAltTexture(2),
                        new TimedTransition(100, "87")
                        ),
                    new State("87",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 10"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 10"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 10"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 10"),
                        new EntityExistsTransition("Arena Possessed Girl", 999, "Check 5")
                        ),
                    new State("Check 5",
                        new EntitiesNotExistsTransition(100, "88", "Arena Ghost Bride", "Arena Possessed Girl")
                        ),
                    new State("88",
                        new Suicide()
                        )
                    )
                )
                .Init("Arena Ghost 1",
                    new State(
                        new Prioritize(
                            new Orbit(speed: 0.5, radius: 2.8, acquireRange: 10, target: null),
                            new Charge(speed: 0.8, range: 11, coolDown: 2000)
                        ),
                        new Wander(speed: 0.6),
                        new Shoot(radius: 5.5, count: 1, projectileIndex: 0, coolDown: 1000)
                    )
                 )
                .Init("Arena Ghost 2",
                    new State(
                        new State("Ini",
                            new SetAltTexture(0),
                            new Prioritize(
                                new Wander(speed: 0.3),
                                new Charge(speed: 2.6, range: 12, coolDown: 2000),
                                new StayBack(speed: 0.8, distance: 4, entity: null)
                            ),
                            new Shoot(radius: 5, count: 3, shootAngle: 20, projectileIndex: 0, coolDown: 1000),
                            new TimedTransition(time: 2000, targetState: "Disappear")
                        ),
                        new State("Disappear",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new SetAltTexture(1, 2, 300, true),
                            new Wander(speed: 0.5),
                            new TimedTransition(time: 1500, targetState: "Ini")
                            )
                        )
                )
                .Init("Arena Possessed Girl",
                    new State(
                        new Prioritize(
                            new Follow(speed: 0.5, acquireRange: 15, range: 3, duration: 5000, coolDown: 3000),
                            new Wander(speed: 0.3)
                            ),
                        new Shoot(radius: 24, count: 8, shootAngle: 45, projectileIndex: 0, fixedAngle: 22.5, coolDown: 600)
                    )
                )
                .Init("Arena Ghost Bride",
                    new State(
                        new ScaleHP2(35),
                        new State("Ini",
                            new Prioritize(
                                new Wander(speed: 0.3),
                                new Follow(speed: 0.6, acquireRange: 8, range: 3, duration: 3000, coolDown: 4000),
                                new StayBack(speed: 0.4, distance: 4, entity: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.9, coolDown: 3000),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 0, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 180, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 90, coolDown: 1500, coolDownOffset: 300),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 270, coolDown: 1500, coolDownOffset: 300),
                            new HpLessTransition(threshold: 0.75, targetState: "ActivateBigDemon")
                        ),
                        new State("ActivateBigDemon",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new SetAltTexture(1),
                            new OrderOnce(range: 100, children: "Arena Statue Left", targetState: "Active"),
                            new EntityNotExistsTransition(target: "Arena Statue Left", dist: 100, targetState: "Attack1")
                        ),
                        new State("Attack1",
                            new SetAltTexture(0),
                            new Prioritize(
                                new Wander(speed: 0.3),
                                new Follow(speed: 0.6, acquireRange: 8, range: 3, duration: 3000, coolDown: 4000),
                                new StayBack(speed: 0.4, distance: 4, entity: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.9, coolDown: 3000),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 0, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 180, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 90, coolDown: 1500, coolDownOffset: 300),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 270, coolDown: 1500, coolDownOffset: 300),
                            new HpLessTransition(threshold: 0.5, targetState: "ActivateWerewolf")
                        ),
                        new State("ActivateWerewolf",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new SetAltTexture(1),
                            new OrderOnce(range: 100, children: "Arena Statue Right", targetState: "Active"),
                            new EntityNotExistsTransition(target: "Arena Statue Right", dist: 100, targetState: "Attack2")
                        ),
                        new State("Attack2",
                            new SetAltTexture(0),
                            new Prioritize(
                                new Wander(speed: 0.3),
                                new Follow(speed: 0.6, acquireRange: 8, range: 3, duration: 3000, coolDown: 4000),
                                new StayBack(speed: 0.4, distance: 4, entity: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 0.9, coolDown: 3000),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 0, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 180, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 90, coolDown: 1500, coolDownOffset: 300),
                            new Shoot(radius: 8, count: 2, shootAngle: 30, projectileIndex: 1, fixedAngle: 270, coolDown: 1500, coolDownOffset: 300)
                        )
                    ),
                    new Threshold(.005,
                        LootTemplates.BasicDrop()
                        ),
                    new Threshold(0.01,
                        new ItemLoot("Potion of Speed", 0.3, 3),
                        new ItemLoot("Potion of Wisdom", 0.3),
                        new ItemLoot("RogueST3", 0.008)
                    )
                )
                .Init("Arena Statue Right",
                    new State(
                        new ScaleHP2(35),
                        new State("Ini",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new SetAltTexture(1)
                        ),
                        new State("Active",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new TimedTransition(time: 0,targetState: "Active_fix")
                        ),
                        new State("Active_fix",
                            new SetAltTexture(0),
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 2, duration: 6000, coolDown: 3000),
                                new Orbit(speed: 0.6, radius: 3, acquireRange: 10, target: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 1, coolDown: 700),
                            new Shoot(radius: 9, count: 2, shootAngle: 35, projectileIndex: 1, predictive: 1, coolDown: 1500, coolDownOffset: 0),
                            new HpLessTransition(threshold: 0.75, targetState: "Phase2")
                        ),
                        new State("Phase2",
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 2, duration: 6000, coolDown: 3000),
                                new Orbit(speed: 0.6, radius: 3, acquireRange: 10, target: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 1, coolDown: 700),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 35, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 70, coolDown: 1500, coolDownOffset: 200),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 105, coolDown: 1500, coolDownOffset: 400),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 140, coolDown: 1500, coolDownOffset: 600),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 175, coolDown: 1500, coolDownOffset: 800),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 210, coolDown: 1500, coolDownOffset: 1000),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 245, coolDown: 1500, coolDownOffset: 1200),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 280, coolDown: 1500, coolDownOffset: 1400),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 315, coolDown: 1500, coolDownOffset: 1600),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 359, coolDown: 1500, coolDownOffset: 1800),
                            new HpLessTransition(threshold: 0.5, targetState: "Active2")
                        ),
                        new State("Active2",
                            new SetAltTexture(0),
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 2, duration: 6000, coolDown: 3000),
                                new Orbit(speed: 0.6, radius: 3, acquireRange: 10, target: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 1, coolDown: 700),
                            new Shoot(radius: 9, count: 2, shootAngle: 35, projectileIndex: 1, predictive: 1, coolDown: 1500, coolDownOffset: 0),
                            new HpLessTransition(threshold: 0.25, targetState: "Phase4")
                        ),
                        new State("Phase4",
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 2, duration: 6000, coolDown: 3000),
                                new Orbit(speed: 0.6, radius: 3, acquireRange: 10, target: null)
                            ),
                            new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 1, coolDown: 700),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 35, coolDown: 1500, coolDownOffset: 0),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 70, coolDown: 1500, coolDownOffset: 200),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 105, coolDown: 1500, coolDownOffset: 400),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 140, coolDown: 1500, coolDownOffset: 600),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 175, coolDown: 1500, coolDownOffset: 800),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 210, coolDown: 1500, coolDownOffset: 1000),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 245, coolDown: 1500, coolDownOffset: 1200),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 280, coolDown: 1500, coolDownOffset: 1400),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 315, coolDown: 1500, coolDownOffset: 1600),
                            new Shoot(radius: 9, count: 1, projectileIndex: 1, fixedAngle: 359, coolDown: 1500, coolDownOffset: 1800)
                        )
                    )
                )
                .Init("Arena Statue Left",
                    new State(
                        new ScaleHP2(35),
                        new State("Ini",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new SetAltTexture(1)
                        ),
                        new State("Active",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                            new TimedTransition(time: 0, targetState: "Active_fix")
                        ),
                        new State("Active_fix",
                            new SetAltTexture(0),
                            new ChangeSize(rate: 1, target: 200),
                            new Prioritize(
                                new Follow(speed: 0.7, acquireRange: 10, range: 2, duration: 6000, coolDown: 3000),
                                new Orbit(speed: 0.6, radius: 3, acquireRange: 10, target: null)
                            ),
                            new Shoot(radius: 9, count: 2, shootAngle: 35, projectileIndex: 0, predictive: 0.7, coolDown: 1000),
                            new PlayerWithinTransition(dist: 1, targetState: "SpiralBlast", seeInvis: true),
                            new TimedTransition(time: 2000, targetState: "SpiralBlast")
                        ),
                        new State("SpiralBlast",
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 0, coolDown: 10000, coolDownOffset: 0),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 45, coolDown: 10000, coolDownOffset: 100),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 90, coolDown: 10000, coolDownOffset: 200),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 135, coolDown: 10000, coolDownOffset: 300),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 180, coolDown: 10000, coolDownOffset: 400),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 225, coolDown: 10000, coolDownOffset: 500),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 270, coolDown: 10000, coolDownOffset: 600),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 315, coolDown: 10000, coolDownOffset: 700),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 0, coolDown: 10000, coolDownOffset: 800),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 45, coolDown: 10000, coolDownOffset: 900),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 90, coolDown: 10000, coolDownOffset: 1000),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 135, coolDown: 10000, coolDownOffset: 1100),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 180, coolDown: 10000, coolDownOffset: 1200),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 225, coolDown: 10000, coolDownOffset: 1300),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 270, coolDown: 10000, coolDownOffset: 1400),
                            new Shoot(radius: 24, count: 1, projectileIndex: 0, fixedAngle: 315, coolDown: 10000, coolDownOffset: 1500),
                            new TimedTransition(time: 1800, targetState: "Active")
                        )
                    )
                )
            ;
    }
}