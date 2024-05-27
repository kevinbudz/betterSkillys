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
        private _ HauntedCemetery = () => Behav()
            .Init("Arena Dn Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("Leech"
                    ),
                    new State("Stage 1",
                        new Spawn("Classic Ghost", maxChildren: 1)
                    ),
                    new State("Stage 2",
                        new Spawn("Classic Ghost", maxChildren: 2)
                    ),
                    new State("Stage 3",
                        new Spawn("Classic Ghost", maxChildren: 2)
                    ),
                    new State("Stage 4",
                        new Spawn("Werewolf", maxChildren: 1),
                        new Spawn("Zombie Hulk", maxChildren: 1)
                    ),
                    new State("Stage 5",
                        new Suicide()
                    )
                 )
            )
            .Init("Arena Up Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("Leech"
                    ),
                    new State("Stage 1",
                        new Spawn("Classic Ghost", maxChildren: 1)
                    ),
                    new State("Stage 2",
                        new Spawn("Werewolf", maxChildren: 1)
                    ),
                    new State("Stage 3",
                        new Spawn("Classic Ghost", maxChildren: 2)
                    ),
                    new State("Stage 4",
                        new Spawn("Classic Ghost", maxChildren: 3)
                    ),
                    new State("Stage 5",
                        new Suicide()
                    )
                )
            )
            .Init("Arena Lf Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("Leech"
                    ),
                    new State("Stage 1",
                        new Spawn("Zombie Hulk", maxChildren: 1)
                    ),
                    new State("Stage 2",
                        new Spawn("Werewolf", maxChildren: 1),
                        new Spawn("Classic Ghost", maxChildren: 1)
                    ),
                    new State("Stage 3",
                        new Spawn("Classic Ghost", maxChildren: 1),
                        new Spawn("Werewolf", maxChildren: 1)
                    ),
                    new State("Stage 4",
                        new Spawn("Werewolf", maxChildren: 1),
                        new Spawn("Zombie Hulk", maxChildren: 1)
                    ),
                    new State("Stage 5",
                        new Suicide()
                    )
                )
            )
            .Init("Arena Rt Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("Leech"
                    ),
                    new State("Stage 1",
                        new Spawn("Zombie Hulk", maxChildren: 1)
                    ),
                    new State("Stage 2",
                        new Spawn("Werewolf", maxChildren: 1)
                    ),
                    new State("Stage 3",
                        new Spawn("Classic Ghost", maxChildren: 2)
                    ),
                    new State("Stage 4",
                        new Spawn("Classic Ghost", maxChildren: 3)
                    ),
                    new State("Stage 5",
                        new Suicide()
                    )
                )
            )
            .Init("Area 1 Controller",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, perm: true),
                    new TransformOnDeath("Haunted Cemetery Gates Portal"),
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
                        new Taunt(true, "Welcome to my domain. l challenge you, warrior, to defeat my undead hordes and claim your prize...."),
                        new TimedTransition(2000, "4")
                    ),
                    new State("4",
                        new Taunt(true, "Say,'READY' when you are ready to face your opponeants.", "Prepare yourself...Say, 'READY' when you wish the battle to begin!"),
                        new TimedTransition(0, "5")
                    ),
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
                        new SetAltTexture(3),
                        new PlayerTextTransition("7", "ready"),
                        new TimedTransition(150, "6_4")
                    ),
                    new State("6_4",
                        new SetAltTexture(1),
                        new PlayerTextTransition("7", "ready")
                    ),
                    new State("7",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 1"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 1"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 1"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 1"),
                        new EntityExistsTransition("Arena Skeleton", 999, "Check 1")
                    ),
                    new State("Check 1",
                        new EntitiesNotExistsTransition(100, "8", "Arena Skeleton", "Troll 1", "Troll 2")
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
                        new TimedTransition(150, "26")
                    ),
                    new State("26",
                        new SetAltTexture(2),
                        new TimedTransition(100, "27")
                    ),
                    new State("27",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 2"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 2"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 2"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 2"),
                        new EntityExistsTransition("Arena Skeleton", 999, "Check 2")
                        ),
                    new State("Check 2",
                        new EntitiesNotExistsTransition(100, "28", "Arena Skeleton", "Troll 1", "Troll 2")
                        ),
                    new State("28",
                        new SetAltTexture(2),
                        new TimedTransition(0, "29")
                        ),
                    new State("29",
                        new SetAltTexture(1),
                        new TimedTransition(150, "30")
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
                        new TimedTransition(100, "46")
                        ),
                    new State("46",
                        new SetAltTexture(2),
                        new TimedTransition(100, "47")
                        ),
                    new State("47",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 3"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 3"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 3"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 3"),
                        new EntityExistsTransition("Arena Skeleton", 999, "Check 3")
                        ),
                    new State("Check 3",
                        new EntitiesNotExistsTransition(100, "48", "Arena Skeleton", "Troll 1", "Troll 2")
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
                        new TimedTransition(150, "66")
                        ),
                    new State("66",
                        new SetAltTexture(2),
                        new TimedTransition(150, "67")
                        ),
                    new State("67",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 4"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 4"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 4"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 4"),
                        new EntityExistsTransition("Arena Skeleton", 999, "Check 4")
                        ),
                    new State("Check 4",
                        new EntitiesNotExistsTransition(100, "68", "Arena Skeleton", "Troll 1", "Troll 2")
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
                        new TimedTransition(150, "86")
                        ),
                    new State("86",
                        new SetAltTexture(2),
                        new TimedTransition(150, "87")
                        ),
                    new State("87",
                        new SetAltTexture(0),
                        new OrderOnce(100, "Arena South Gate Spawner", "Stage 5"),
                        new OrderOnce(100, "Arena West Gate Spawner", "Stage 5"),
                        new OrderOnce(100, "Arena East Gate Spawner", "Stage 5"),
                        new OrderOnce(100, "Arena North Gate Spawner", "Stage 5"),
                        new EntityExistsTransition("Troll 3", 999, "Check 5")
                        ),
                    new State("Check 5",
                        new EntityNotExistsTransition("Troll 3", 100, "88")
                        ),
                    new State("88",
                        new Suicide()
                        )
                    )
                )
        .Init("Arena South Gate Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Leech"
                    ),
                new State("Stage 1",
                    new Spawn("Arena Skeleton", maxChildren: 2)
                    ),
                new State("Stage 2",
                    new Spawn("Arena Skeleton", maxChildren: 2)
                    ),
                new State("Stage 3",
                    new Spawn("Troll 1", maxChildren: 1)
                    ),
                new State("Stage 4",
                    new Spawn("Troll 1", maxChildren: 1)
                    ),
                new State("Stage 5",
                    new Suicide()
                    ),
                new State("Stage 6",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 7",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
               new State("Stage 8",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 9",
                    new Spawn("Arena Possessed Girl", maxChildren: 1)
                    ),
                new State("Stage 10",
                    new Suicide()
                    ),
                new State("Stage 11",
                    new Spawn("Arena Risen Brawler", maxChildren: 1)
                    ),
                new State("Stage 12",
                    new Spawn("Arena Risen Warrior", maxChildren: 1)
                    ),
                new State("Stage 13",
                    new Spawn("Arena Risen Warrior", maxChildren: 1)
                    ),
                new State("Stage 14",
                    new Spawn("Arena Risen Warrior", maxChildren: 1),
                    new Spawn("Arena Risen Archer", maxChildren: 1)
                    ),
                new State("Stage 15",
                    new Suicide()
                    )
                )
            )
        .Init("Arena East Gate Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Leech"
                    ),
                new State("Stage 1",
                    new Spawn("Arena Skeleton", maxChildren: 1)
                    ),
                new State("Stage 2",
                    new Spawn("Arena Skeleton", maxChildren: 2)
                    ),
                new State("Stage 3",
                    new Spawn("Arena Skeleton", maxChildren: 1),
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 4",
                    new Spawn("Arena Skeleton", maxChildren: 1),
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 5",
                    new Suicide()
                    ),
                new State("Stage 6",
                    new Spawn("Arena Ghost 1", maxChildren: 1)
                    ),
                new State("Stage 7",
                    new Spawn("Arena Ghost 1", maxChildren: 1)
                    ),
                new State("Stage 8",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 9",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 10",
                    new Spawn("Arena Possessed Girl", maxChildren: 1)
                    ),
                new State("Stage 11",
                    new Spawn("Arena Risen Warrior", maxChildren: 1)
                    ),
                new State("Stage 12",
                    new Spawn("Arena Risen Brawler", maxChildren: 1)
                    ),
                new State("Stage 13",
                    new Spawn("Arena Risen Brawler", maxChildren: 1)
                    ),
                new State("Stage 14",
                    new Spawn("Arena Risen Brawler", maxChildren: 1)
                    ),
                new State("Stage 15",
                    new Suicide()
                    )
                )
            )
        .Init("Arena West Gate Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Leech"
                    ),
                new State("Stage 1",
                    new Spawn("Arena Skeleton", maxChildren: 1)
                    ),
                new State("Stage 2",
                    new Spawn("Arena Skeleton", maxChildren: 2)
                    ),
                new State("Stage 3",
                    new Spawn("Arena Skeleton", maxChildren: 1),
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 4",
                    new Spawn("Arena Skeleton", maxChildren: 1),
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 5",
                    new Suicide()
                    ),
                new State("Stage 6",
                    new Spawn("Arena Ghost 1", maxChildren: 1)
                    ),
                new State("Stage 7",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 8",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 9",
                    new Spawn("Arena Possessed Girl", maxChildren: 1)
                    ),
                new State("Stage 10",
                    new Spawn("Arena Possessed Girl", maxChildren: 1)
                    ),
                new State("Stage 11",
                    new Spawn("Arena Risen Archer", maxChildren: 1)
                    ),
                new State("Stage 12",
                    new Spawn("Arena Risen Brawler", maxChildren: 1),
                    new Spawn("Arena Risen Warrior", maxChildren: 1)
                    ),
                new State("Stage 13",
                    new Spawn("Arena Risen Archer", maxChildren: 1)
                    ),
                new State("Stage 14",
                    new Spawn("Arena Risen Archer", maxChildren: 1),
                    new Spawn("Arena Risen Mage", maxChildren: 1)
                    ),
                new State("Stage 15",
                    new Suicide()
                    )
                )
            )
        .Init("Arena North Gate Spawner",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Leech"
                    ),
                new State("Stage 1",
                    new Spawn("Arena Skeleton", maxChildren: 1)
                    ),
                new State("Stage 2",
                    new Spawn("Troll 1", maxChildren: 1)
                    ),
                new State("Stage 3",
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 4",
                    new Spawn("Troll 2", maxChildren: 1)
                    ),
                new State("Stage 5",
                    new Spawn("Troll 3", maxChildren: 1, spawnedByBehav: false)
                    ),
                new State("Stage 6",
                    new Spawn("Arena Ghost 1", maxChildren: 1)
                    ),
                new State("Stage 7",
                    new Spawn("Arena Possessed Girl", maxChildren: 1)
                    ),
                new State("Stage 8",
                    new Spawn("Arena Ghost 2", maxChildren: 1)
                    ),
                new State("Stage 9",
                    new Spawn("Arena Ghost 1", maxChildren: 1)
                    ),
                new State("Stage 10",
                    new Spawn("Arena Ghost Bride", maxChildren: 1, spawnedByBehav: false)
                    ),
                new State("Stage 11",
                    new Spawn("Arena Risen Mage", maxChildren: 1)
                    ),
                new State("Stage 12",
                    new Spawn("Arena Risen Warrior", maxChildren: 2)
                    ),
                new State("Stage 13",
                    new Spawn("Arena Risen Warrior", maxChildren: 1),
                    new Spawn("Arena Risen Mage", maxChildren: 1)
                    ),
                new State("Stage 14",
                    new Spawn("Arena Risen Warrior", maxChildren: 2)
                    ),
                new State("Stage 15",
                    new Spawn("Arena Grave Caretaker", maxChildren: 1, spawnedByBehav: false)
                    )
                )
            )
            .Init("Arena Skeleton",
                new State(
                    new Prioritize(
                        new Follow(speed: 0.5, acquireRange: 8, range: 2, duration: 2000, coolDown: 3500),
                        new Wander(speed: 0.5)
                    ),
                    new Shoot(radius: 8, count: 1, projectileIndex: 0, coolDown: 800)
                )
            )
            .Init("Troll 1",
                new State(
                    new ScaleHP2(35),
                    new Prioritize(
                        new Charge(speed: 1.1, range: 8, coolDown: 3000),
                        new Follow(speed: 0.5, acquireRange: 15, range: 2, duration: 4000, coolDown: 2000)
                    ),
                    new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                )
            )
            .Init("Troll 2",
                new State(
                    new ScaleHP2(35),
                    new Orbit(speed: 0.5, radius: 5, acquireRange: 10, target: null),
                    new Prioritize(
                        new Follow(speed: 1.1, acquireRange: 15, range: 6, duration: 4000, coolDown: 5000)
                    ),
                    new Shoot(radius: 8, count: 1, projectileIndex: 0, predictive: 1, coolDown: 1600),
                    new Grenade(radius: 3, range: 6, damage: 85, coolDown: 2000)
                    )
            )
            .Init("Troll 3",
                new State(
                    new ScaleHP2(35),
                    new State("Ini",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new State("Check1",
                            new EntityExistsTransition(target: "Area 1 Controller", dist: 999, targetState: "2")
                        ),
                        new State("2",
                            new MoveTo(speed: 0.9f, x: 21f, y: 21f)
                        ),
                        new Taunt("This forest will be your tomb!"),
                        new TossObject(child: "Arena Mushroom", range: 7, coolDown: 3000),
                        new TimedTransition(time: 2000, targetState: "Normal")
                    ),
                    new State("Normal",
                        new Prioritize(
                            new Wander(speed: 0.3)
                        ),
                        new Follow(speed: 0.6, acquireRange: 10, range: 3, duration: 5000, coolDown: 5500),
                        new Shoot(radius: 8, count: 1, projectileIndex: 0, coolDown: 1000),
                        new Shoot(radius: 24, count: 6, shootAngle: 60, projectileIndex: 1, fixedAngle: 30, coolDown: 2000),
                        new TossObject(child: "Arena Mushroom", range: 7, coolDown: 3000),
                        new HpLessTransition(threshold: 0.7, targetState: "Summon")
                    ),
                    new State("Summon",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Taunt("I call upon the aid of warriors past! Smite these trespassers!"),
                        new Spawn(children: "Arena Skeleton", maxChildren: 5, coolDown: 4000),
                        new Shoot(radius: 24, count: 6, shootAngle: 60, projectileIndex: 1, fixedAngle: 0, coolDown: 1500),
                        new Shoot(radius: 24, count: 6, shootAngle: 60, projectileIndex: 1, fixedAngle: 30, coolDown: 1500),
                        new TossObject(child: "Arena Mushroom", range: 7, coolDown: 3000),
                        new EntitiesNotExistsTransition(99, "Enrage", "Arena Skeleton")
                    ),
                    new State("Enrage",
                        new Flash(color: 0xFFFFFF, flashPeriod: 0.1, flashRepeats: 15),
                        new ChangeSize(rate: 1, target: 200),
                        new Follow(speed: 1.1, acquireRange: 10, range: 3, duration: 5000, coolDown: 5500),
                        new Charge(speed: 1.3, range: 7, coolDown: 3000),
                        new Shoot(radius: 24, count: 6, shootAngle: 60, projectileIndex: 1, fixedAngle: 0, coolDown: 900),
                        new TossObject(child: "Arena Mushroom", range: 7, coolDown: 1500),
                        new TimedTransition(time: 15000, targetState: "Normal 2")
                        ),
                    new State("Normal 2",
                        new Wander(speed: 0.3),
                        new ChangeSize(rate: 1, target: 150),
                        new Follow(speed: 1.1, acquireRange: 10, range: 3, duration: 5000, coolDown: 5500),
                        new TossObject(child: "Arena Mushroom", range: 7, coolDown: 3000),
                        new Shoot(radius: 8, count: 1, projectileIndex: 0, coolDown: 1000),
                        new HpLessTransition(threshold: 0.4, targetState: "Summon")
                    )
                ),
                new Threshold(.005,
                    LootTemplates.BasicDrop()
                    ),
                new Threshold(0.01,
                    new ItemLoot("RogueST1", 0.008),
                    new ItemLoot("Potion of Speed", 0.8),
                    new ItemLoot("Potion of Wisdom", 0.8)
                )
            )
            .Init("Arena Mushroom",
                new State(
                    new State("Ini",
                        new PlayerWithinTransition(dist: 3, targetState: "A1", seeInvis: true)
                    ),
                    new State("A1",
                        new TimedTransition(time: 750, targetState: "A2")
                    ),
                    new State("A2",
                        new SetAltTexture(1),
                        new TimedTransition(time: 750, targetState: "A3")
                    ),
                    new State("A3",
                        new SetAltTexture(2),
                        new TimedTransition(time: 1000, targetState: "Explode")
                    ),
                    new State("Explode",
                        new Flash(color: 0xFFFFFF, flashPeriod: 0.1, flashRepeats: 30),
                        new TimedTransition(time: 3000, targetState: "Suicide")
                        ),
                    new State("Suicide",
                        new Shoot(radius: 24, count: 6, shootAngle: 60, fixedAngle: 30),
                        new Suicide()
                    )
                )
            )
            ;

    }
}