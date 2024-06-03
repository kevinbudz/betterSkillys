using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Draconis = () => Behav()
            .Init("NM Altar of Draconis",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("Idle",
                        new TimedTransition(3000, "Idle2")
                    ),
                    new State("Idle2",
                        new Taunt(true, "Choose the Dragon Soul you wish to commune with!"),
                        new TimedTransition(1000, "1")
                    ),
                    new State("1",
                        new EntitiesNotExistsTransition(100, "dead", "NM Blue Dragon Spawner", "NM Red Dragon Spawner", "NM Black Dragon Spawner", "NM Green Dragon Spawner"),
                        new PlayerTextTransition("2", "blue"),
                        new PlayerTextTransition("6", "red"),
                        new PlayerTextTransition("9", "black"),
                        new PlayerTextTransition("9", "XD"),
                        new PlayerTextTransition("12", "green")
                    ),
                    new State("dead",
                        new TossObject("Ivory Wyvern Portal", 3, 0, coolDown: 10000),
                        new Decay(1500)
                    ),
                    new State("2",
                        new EntityExistsTransition("NM Blue Dragon Dead", 100, "1"),
                        new EntityExistsTransition("NM Blue Dragon Spawner", 100, "3")
                    ),
                    new State("3",
                        new Taunt(true, "Do not let the tranquil surroundigps fool you!"),
                        new TossObject("NM Blue Dragon Soul", 4, 270, coolDown: 10000),
                        new TimedTransition(1000, "5")
                    ),
                    new State("5",
                        new OrderOnce(100, "NM Blue Dragon Spawner", "2"),
                        new EntityExistsTransition("NM Blue Dragon Dead", 100, "1")
                    ),
                    new State("6",
                        new EntityExistsTransition("NM Red Dragon Dead", 100, "1"),
                        new EntityExistsTransition("NM Red Dragon Spawner", 100, "7")
                    ),
                    new State("7",
                        new Taunt(true, "Burns!!! Pyyr will rend your flesh and char your bones!"),
                        new TossObject("NM Red Dragon Soul", 4, 180, coolDown: 10000),
                        new TimedTransition(1000, "8")
                    ),
                    new State("8",
                        new OrderOnce(100, "NM Red Dragon Spawner", "2"),
                        new EntityExistsTransition("NM Red Dragon Dead", 100, "1")
                    ),
                    new State("9",
                        new EntityExistsTransition("NM Black Dragon Dead", 100, "1"),
                        new EntityExistsTransition("NM Black Dragon Spawner", 100, "10")
                    ),
                    new State("10",
                        new Taunt(true, "Gaze into the darkness... Feargus will consume you!"),
                        new TossObject("NM Black Dragon Soul", 4, 90, coolDown: 10000),
                        new TimedTransition(1000, "11")
                    ),
                    new State("11",
                        new OrderOnce(100, "NM Black Dragon Spawner", "2"),
                        new EntityExistsTransition("NM Black Dragon Dead", 100, "1")
                    ),
                    new State("12",
                        new EntityExistsTransition("NM Green Dragon Dead", 100, "1"),
                        new EntityExistsTransition("NM Green Dragon Spawner", 100, "13")
                    ),
                    new State("13",
                        new Taunt(true, "Limoz is the nicest of the lot, but he still hates all sub creatures!"),
                        new TossObject("NM Green Dragon Soul", 4, 0, coolDown: 10000),
                        new TimedTransition(1000, "14")
                    ),
                    new State("14",
                        new OrderOnce(100, "NM Green Dragon Spawner", "2"),
                        new EntityExistsTransition("NM Green Dragon Dead", 100, "1")
                    )
                )
            )
            .Init("NM Blue Dragon Soul",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1",
                        new TeleportPlayer(0.5, 0, -28, false)
                    ),
                    new State("2",
                        new TeleportPlayer(0.5, 0, -28, false),
                        new Decay(30000),
                        new EntityExistsTransition("NM Blue Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(1000)
                    )
                )
            )
            .Init("NM Blue Dragon Dead",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1")
                )
            )
            .Init("NM Blue Dragon Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new Spawn("NM Blue Dragon God", 1, 0, givesNoXp: false),
                        new EntityExistsTransition("NM Blue Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(0)
                    )
                )
            )
            .Init("NM Blue Open Wall",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new RemoveTileObject(0x1926, 5),
                        new RemoveTileObject(0x1924, 5)
                    )
                )
            )
             .Init("lod Blue Loot Balloon",
                new State(
                    new ScaleHP2(15),
                    new TransformOnDeath("NM Blue Dragon Dead"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 5000),
                    new Flash(0xFFFFFF, 0.5, 1),
                    new OrderOnDeath(100, "NM Blue Open Wall", "2")
                ),
                new Threshold(0.005,
                    LootTemplates.StrongerDrop()
                    ),
                new Threshold(0.01,
                    new ItemLoot("Large Blue Dragon Scale Cloth", 0.4),
                    new ItemLoot("Small Blue Dragon Scale Cloth", 0.4),
                    new ItemLoot("Water Dragon Silk Robe", 0.004),
                    new ItemLoot("Zaarvox's Heart", 0.02),
                    new ItemLoot("Potion of Wisdom", 1)
                )
            )
            .Init("NM Blue Dragon God",
                new State(
                    new ScaleHP2(15),
                    new StayCloseToSpawn(0.5, 24),
                    new TransformOnDeath("lod Blue Loot Balloon"),
                    new State("1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(1),
                        new PlayerWithinTransition(3, "2")
                    ),
                    new State("2",
                        new OrderOnce(100, "NM Blue Dragon Soul", "2"),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(3000, "3")
                    ),
                    new State("3",
                        new SetAltTexture(0),
                        new OrderOnce(99, "NM Blue Minion Spawner", "spawn"),
                        new TimedTransition(1500, "4")
                    ),
                    new State("4",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new HpLessTransition(0.75, "9"),
                        new Shoot(0, 4, 45, 1, 90, coolDown: 2000),
                        new Shoot(0, 4, 15, 2, 90, coolDown: 2000),
                        new Shoot(0, 6, 30, 4, 315, coolDown: 2500),
                        new Shoot(0, 6, 25, 3, 0, coolDown: 4500, coolDownOffset: 1500),
                        new Shoot(0, 6, 15, 5, 315, coolDown: 4500, coolDownOffset: 1500),
                        new Shoot(0, 6, 25, 3, 90, coolDown: 4500, coolDownOffset: 3000),
                        new Shoot(0, 6, 15, 5, 270, coolDown: 4500, coolDownOffset: 3000),
                        new Shoot(0, 6, 15, 5, 225, coolDown: 4500, coolDownOffset: 4500),
                        new Shoot(0, 6, 15, 5, 135, coolDown: 4500, coolDownOffset: 4500),
                        new State("5",
                            new TimedRandomTransition(500, false, "6", "7", "8")
                        ),
                        new State("6",
                            new Orbit(0.4, 5, 24, "NM Blue Dragon Spawner"),
                            new TimedTransition(4000, "5")
                        ),
                        new State("7",
                            new Orbit(0.4, 5, 24, "NM Blue Dragon Spawner", orbitClockwise: true),
                            new TimedTransition(4000, "5")
                        ),
                        new State("8",
                            new Follow(0.4, 20, 1),
                            new TimedTransition(4000, "5")
                        )
                    ),
                    new State("9",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new HpLessTransition(0.25, "15"),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new Shoot(0, 4, 45, 1, 90, coolDown: 2000),
                        new Shoot(0, 4, 15, 2, 90, coolDown: 2000),
                        new Shoot(0, 6, 30, 4, 315, coolDown: 2500),
                        new Shoot(24, 1, projectileIndex: 0, coolDown: 1000),
                        new Shoot(0, 6, 25, 3, 0, coolDown: 4500, coolDownOffset: 1500),
                        new Shoot(0, 6, 15, 5, 315, coolDown: 4500, coolDownOffset: 1500),
                        new Shoot(0, 6, 25, 3, 90, coolDown: 4500, coolDownOffset: 3000),
                        new Shoot(0, 6, 15, 5, 270, coolDown: 4500, coolDownOffset: 3000),
                        new Shoot(0, 6, 15, 5, 225, coolDown: 4500, coolDownOffset: 4500),
                        new Shoot(0, 6, 15, 5, 135, coolDown: 4500, coolDownOffset: 4500),
                        new State("10",
                            new ReturnToSpawn(0.7, 0.5),
                            new HpLessTransition(0.5, "11")
                        ),
                        new State("11",
                            new TimedRandomTransition(500, false, "12", "13", "14")
                        ),
                        new State("12",
                            new Orbit(0.5, 5, 24, "NM Blue Dragon Spawner"),
                            new TimedTransition(4000, "11")
                        ),
                        new State("13",
                            new Orbit(0.5, 5, 24, "NM Blue Dragon Spawner", orbitClockwise: true),
                            new TimedTransition(4000, "11")
                        ),
                        new State("14",
                            new Follow(0.5, 20, 1),
                            new TimedTransition(4000, "11")
                        )
                    ),
                    new State("15",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new HpLessTransition(0.05, "16"),
                        new Wander(0.6),
                        new Shoot(0, 4, 45, 1, 90, coolDown: 2000),
                        new Shoot(0, 4, 15, 2, 90, coolDown: 2000),
                        new Shoot(0, 6, 30, 4, 315, coolDown: 2500),
                        new Shoot(24, 1, projectileIndex: 0, coolDown: 1000),
                        new Shoot(0, 6, 15, 5, 315, coolDown: 4500, coolDownOffset: 1500),
                        new Shoot(0, 6, 15, 5, 270, coolDown: 4500, coolDownOffset: 3000),
                        new Shoot(0, 6, 15, 5, 225, coolDown: 4500, coolDownOffset: 4500),
                        new Shoot(0, 6, 15, 5, 135, coolDown: 4500, coolDownOffset: 4500),
                        new Shoot(0, 24, 15, 3, 0, coolDown: 2000)
                    ),
                    new State("16",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new ReturnToSpawn(0.6),
                        new Decay(3000)
                    )
                )
            )
            .Init("NM Blue Minion Spawner",
                new State(
                    new State("Waiting"),
                    new State("spawn",
                        new Spawn("NM Blue Dragon Minion", 1, 0),
                        new TimedTransition(1000, "Waiting")
                    )
                )
            )
            .Init("NM Blue Dragon Minion",
                new State(
                    new Wander(0.2),
                    new Shoot(10, 1, projectileIndex: 2, coolDown: 1000)
                )
            )
            .Init("NM Red Dragon Soul",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1",
                        new TeleportPlayer(0.5, -28, 0, false)
                    ),
                    new State("2",
                        new TeleportPlayer(0.5, -28, 0, false),
                        new Decay(30000),
                        new EntityExistsTransition("NM Red Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(1000)
                    )
                )
            )
            .Init("NM Red Dragon Dead",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1")
                )
            )
            .Init("NM Red Dragon Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new Spawn("NM Red Dragon God", 1, 0, givesNoXp: false),
                        new EntityExistsTransition("NM Red Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(0)
                    )
                )
            )
            .Init("NM Red Open Wall",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new RemoveTileObject(0x1923, 5),
                        new RemoveTileObject(0x1924, 5)
                    )
                )
            )
            .Init("lod Red Loot Balloon",
                new State(
                    new ScaleHP2(15),
                    new TransformOnDeath("NM Red Dragon Dead"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 5000),
                    new Flash(0xFFFFFF, 0.5, 1),
                    new OrderOnDeath(100, "NM Red Open Wall", "2")
                ),
                new Threshold(0.005,
                    LootTemplates.StrongerDrop()
                    ),
                new Threshold(0.01,
                    new ItemLoot("Large Red Dragon Scale Cloth", 0.4),
                    new ItemLoot("Small Red Dragon Scale Cloth", 0.4),
                    new ItemLoot("Fire Dragon Battle Armor", 0.004),
                    new ItemLoot("Indomptable", 0.02),
                    new ItemLoot("Potion of Attack", 1),
                    new ItemLoot("Potion of Defense", 1)
                )
            )
            .Init("NM Red Dragon God",
                new State(
                    new ScaleHP2(15),
                    new StayCloseToSpawn(0.5, 24),
                    new TransformOnDeath("lod Red Loot Balloon"),
                    new State("1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(1),
                        new PlayerWithinTransition(3, "2")
                    ),
                    new State("2",
                        new OrderOnce(100, "NM Red Dragon Soul", "2"),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(2500, "3")
                    ),
                    new State("3",
                        new SetAltTexture(0),
                        new TimedTransition(1000, "4")
                    ),
                    new State("4",
                        new OrderOnce(99, "NM Red Minion Spawner", "1"),
                        new OrderOnce(99, "NM Red Fake Egg", "1"),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 0),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 90),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 180),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 270),
                        new TimedTransition(200, "5")
                    ),
                    new State("5",
                        new EntityExistsTransition("NM Red Dragon Minion", 100, "6")
                    ),
                    new State("6",
                        new EntitiesNotExistsTransition(100, "7", "NM Red Dragon Minion"),
                        new Shoot(20, 6, 15, 4, coolDown: 1500),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 4, 90, 0, 0, coolDown: 2000, coolDownOffset: 1000),
                        new Shoot(0, 4, 90, 0, 45, coolDown: 2000, coolDownOffset: 2000)
                    ),
                    new State("7",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new OrderOnce(100, "NM Red Dragon Lava Trigger", "6"),
                        new HpLessTransition(0.5, "8"),
                        new Follow(0.5, 20, 1, 6000, 6000),
                        new Shoot(20, 6, 15, 4, coolDown: 1500),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 6, 10, 2, 0, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 90, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 180, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 270, coolDown: 2500),
                        new Shoot(20, 3, 25, 1, coolDown: 2000),
                        new Shoot(20, 1, projectileIndex: 6, coolDown: 1000),
                        new Shoot(99, 4, 90, 3, 0, coolDownOffset: 200, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 10, coolDownOffset: 400, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 20, coolDownOffset: 600, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 30, coolDownOffset: 800, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 40, coolDownOffset: 1000, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 40, coolDownOffset: 1200, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 30, coolDownOffset: 1400, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 20, coolDownOffset: 1600, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 10, coolDownOffset: 1800, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 0, coolDownOffset: 2000, coolDown: 2000)
                    ),
                    new State("8",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new ReturnToSpawn(1, 0),
                        new TimedTransition(4000, "9")
                    ),
                    new State("9",
                        new OrderOnce(99, "NM Red Minion Spawner", "1"),
                        new OrderOnce(99, "NM Red Fake Egg", "1"),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 0),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 90),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 180),
                        new TossObject("NM Red Dragon Lava Bomb", 2, 270),
                        new TimedTransition(200, "10")
                    ),
                    new State("10",
                        new EntityExistsTransition("NM Red Dragon Minion", 100, "13")
                    ),
                    new State("13",
                        new EntitiesNotExistsTransition(100, "11", "NM Red Dragon Minion"),
                        new Shoot(20, 6, 15, 4, coolDown: 1500),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 4, 90, 0, 0, coolDown: 2000, coolDownOffset: 1000),
                        new Shoot(0, 4, 90, 0, 45, coolDown: 2000, coolDownOffset: 2000)
                    ),
                    new State("11",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new OrderOnce(100, "NM Red Dragon Lava Trigger", "6"),
                        new HpLessTransition(0.05, "12"),
                        new Follow(0.5, 20, 1, 6000, 6000),
                        new Shoot(20, 6, 15, 4, coolDown: 1500),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 6, 10, 2, 0, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 90, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 180, coolDown: 2500),
                        new Shoot(0, 6, 10, 2, 270, coolDown: 2500),
                        new Shoot(20, 3, 25, 1, coolDown: 2000),
                        new Shoot(20, 1, projectileIndex: 6, coolDown: 1000),
                        new Shoot(99, 4, 90, 3, 0, coolDownOffset: 200, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 10, coolDownOffset: 400, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 20, coolDownOffset: 600, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 30, coolDownOffset: 800, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 40, coolDownOffset: 1000, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 40, coolDownOffset: 1200, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 30, coolDownOffset: 1400, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 20, coolDownOffset: 1600, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 10, coolDownOffset: 1800, coolDown: 2000),
                        new Shoot(99, 4, 90, 3, 0, coolDownOffset: 2000, coolDown: 2000)
                    ),
                    new State("12",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new ReturnToSpawn(0.7),
                        new Decay(3000)
                    )
                )
            )
            .Init("NM Red Dragon Lava Bomb",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("1",
                        new TimedTransition(1000, "2")
                    ),
                    new State("2",
                        new OrderOnce(100, "NM Red Dragon Lava Trigger", "2"),
                        new EnemyAOE(1, false, 0, 0, false, 0xFF0000),
                        new Decay(0)
                    )
                )
            )
            .Init("NM Red Dragon Lava Trigger",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("1"),
                    new State("2",
                        new GroundTransform("Lava"),
                        new TimedTransition(2000, "3")
                    ),
                    new State("3",
                        new GroundTransform("Lava", 1),
                        new TimedTransition(2000, "4")
                    ),
                    new State("4",
                        new GroundTransform("Lava", 2),
                        new TimedTransition(2000, "5")
                    ),
                    new State("5",
                        new GroundTransform("Lava", 3)
                    ),
                    new State("6",
                        new GroundTransform("Dragon Tile Red", 3)
                    )
                )
            )
            .Init("NM Red Fake Egg",
                new State(
                    new State("nothin"),
                    new State("1",
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(2500, "nothin")
                    )
                )
            )
            .Init("NM Red Minion Spawner",
                new State(
                    new State("nothin"),
                    new State("1",
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(2500, "2")
                    ),
                    new State("2",
                        new Spawn("NM Red Dragon Minion", 1, 0),
                        new TimedTransition(100, "nothin")
                    )
                )
            )
            .Init("NM Red Dragon Minion",
                new State(
                    new Prioritize(
                        new Orbit(0.3, 4, 8, null),
                        new Wander(0.3)
                    ),
                    new Shoot(8, 1, projectileIndex: 0, coolDown: 1500)
                )
            )
            .Init("NM Black Dragon Soul",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1",
                        new TeleportPlayer(0.5, 0, 28, false)
                    ),
                    new State("2",
                        new TeleportPlayer(0.5, 0, 28, false),
                        new Decay(30000),
                        new EntityExistsTransition("NM Black Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(1000)
                    )
                )
            )
            .Init("NM Black Dragon Dead",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1")
                )
            )
            .Init("NM Black Dragon Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new Spawn("NM Black Dragon God", 1, 0, givesNoXp: false),
                        new EntityExistsTransition("NM Black Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(0)
                    )
                )
            )
            .Init("NM Black Open Wall",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new RemoveTileObject(0x1922, 5),
                        new RemoveTileObject(0x1924, 5)
                    )
                )
            )
            .Init("NM Black Dragon Minion",
                new State(
                    new State("2",
                        new SetAltTexture(0),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new PlayerWithinTransition(1, "3")
                    ),
                    new State("3",
                        new SetAltTexture(1),
                        new Wander(0.3),
                        new Shoot(10, 1, projectileIndex: 0, coolDown: 500),
                        new NoPlayerWithinTransition(1, "2")
                    )
                )
            )
            .Init("lod Black Loot Balloon",
                new State(
                    new ScaleHP2(15),
                    new TransformOnDeath("NM Black Dragon Dead"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 5000),
                    new Flash(0xFFFFFF, 0.5, 1),
                    new OrderOnDeath(100, "NM Black Open Wall", "2")
                ),
                new Threshold(0.005,
                    LootTemplates.StrongerDrop()
                    ),
                new Threshold(0.01,
                    new ItemLoot("Large Midnight Dragon Scale Cloth", 0.4),
                    new ItemLoot("Small Midnight Dragon Scale Cloth", 0.4),
                    new ItemLoot("Amulet of Drakefyre", 0.02),
                    new ItemLoot("Potion of Vitality", 1)
                )
            )
            .Init("NM Black Dragon God",
                new State(
                    new ScaleHP2(15),
                    new StayCloseToSpawn(0.5, 24),
                    new TransformOnDeath("lod Black Loot Balloon"),
                    new State("1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(1),
                        new PlayerWithinTransition(3, "2")
                    ),
                    new State("2",
                        new OrderOnce(100, "NM Black Dragon Soul", "2"),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(2500, "3")
                    ),
                    new State("3",
                        new SetAltTexture(0),
                        new TimedTransition(1000, "4")
                    ),
                    new State("4",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new HpLessTransition(0.05, "9"),
                        new Shoot(12, 5, 36, 0, coolDown: 1000),
                        new Shoot(12, 1, projectileIndex: 1, coolDown: 500),
                        new Shoot(12, 5, 36, 2, predictive: 1, coolDown: 1000),
                        new Shoot(22, 2, 45, 3, coolDown: 1000),
                        new Shoot(12, 5, 36, 5, coolDown: 1500),
                        new Shoot(0, 5, 25, 7, 270, coolDown: 1000),
                        new Grenade(4, 100, 14, coolDown: 7000),
                        new State("5",
                            new TimedRandomTransition(1000, false, "6", "7", "8")
                        ),
                        new State("6",
                            new Follow(0.4, 10, 3),
                            new TimedTransition(4000, "4")
                        ),
                        new State("7",
                            new Orbit(0.4, 12, 24, "NM Black Dragon Spawner"),
                            new TimedTransition(4000, "4")
                        ),
                        new State("8",
                            new Orbit(0.4, 12, 24, "NM Black Dragon Spawner", orbitClockwise: true),
                            new TimedTransition(4000, "4")
                        )
                    ),
                    new State("9",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new ReturnToSpawn(0.7),
                        new Decay(3000)
                    )
                )
            )
            .Init("NM Green Dragon Soul",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1",
                        new TeleportPlayer(0.5, 28, 0, false)
                    ),
                    new State("2",
                        new TeleportPlayer(0.5, 28, 0, false),
                        new Decay(30000),
                        new EntityExistsTransition("NM Green Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(1000)
                    )
                )
            )
            .Init("NM Green Dragon Dead",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1")
                )
            )
            .Init("NM Green Dragon Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new Spawn("NM Green Dragon God", 1, 0, givesNoXp: false),
                        new EntityExistsTransition("NM Green Dragon Dead", 100, "3")
                    ),
                    new State("3",
                        new Decay(0)
                    )
                )
            )
            .Init("NM Green Dragon Minion",
                new State(
                    new Prioritize(
                        new Protect(0.5, "NM Green Dragon God", 10, 7),
                        new Wander(0.3)
                    ),
                    new Shoot(10, 1, projectileIndex: 3, coolDown: 1000)
                )
            )
            .Init("NM Green Open Wall",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new State("1"),
                    new State("2",
                        new RemoveTileObject(0x1925, 5),
                        new RemoveTileObject(0x1924, 5)
                    )
                )
            )
            .Init("NM Green Dragon Shield",
                new State(
                    new Orbit(0.4, 3, 10, "NM Green Dragon God")
                )
            )
            .Init("lod Green Loot Balloon",
                new State(
                    new ScaleHP2(15),
                    new TransformOnDeath("NM Green Dragon Dead"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 5000),
                    new Flash(0xFFFFFF, 0.5, 1),
                    new OrderOnDeath(100, "NM Green Open Wall", "2")
                ),
                new Threshold(0.005,
                    LootTemplates.StrongerDrop()
                    ),
                new Threshold(0.01,
                    new ItemLoot("Large Green Dragon Scale Cloth", 0.4),
                    new ItemLoot("Small Green Dragon Scale Cloth", 0.4),
                    new ItemLoot("Leaf Dragon Hide Armor", 0.004),
                    new ItemLoot("Potion of Speed", 1),
                    new ItemLoot("Potion of Vitality", 1)
                )
            )
            .Init("NM Green Dragon God",
                new State(
                    new ScaleHP2(15),
                    new StayCloseToSpawn(0.5, 24),
                    new TransformOnDeath("lod Green Loot Balloon"),
                    new State("1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(1),
                        new PlayerWithinTransition(3, "2")
                    ),
                    new State("2",
                        new OrderOnce(100, "NM Green Dragon Soul", "2"),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(2500, "3")
                    ),
                    new State("3",
                        new SetAltTexture(0),
                        new TimedTransition(1000, "4")
                    ),
                    new State("4",
                        new TossObject("NM Green Dragon Shield", 3, 0),
                        new TossObject("NM Green Dragon Shield", 3, 45),
                        new TossObject("NM Green Dragon Shield", 3, 90),
                        new TossObject("NM Green Dragon Shield", 3, 135),
                        new TossObject("NM Green Dragon Shield", 3, 180),
                        new TossObject("NM Green Dragon Shield", 3, 225),
                        new TossObject("NM Green Dragon Shield", 3, 270),
                        new TossObject("NM Green Dragon Shield", 3, 315),
                        new TimedTransition(0, "5")
                    ),
                    new State("5",
                        new EntityExistsTransition("NM Green Dragon Shield", 20, "6")
                    ),
                    new State("6",
                        new HpLessTransition(0.5, "9"),
                        new Shoot(0, 12, 30, 0, 45, coolDown: 1500),
                        new Shoot(0, 2, 15, 6, 0, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 90, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 180, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 270, coolDown: 1000),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 2, 15, 4, coolDown: 1000),
                        new State("7",
                            new EntitiesNotExistsTransition(30, "8", "NM Green Dragon Shield")
                        ),
                        new State("8",
                            new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                            new Follow(0.4, 20, 1),
                            new Spawn("NM Green Dragon Minion", 5, 0)
                        )
                    ),
                    new State("9",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new ReturnToSpawn(1, 0),
                        new Flash(0xFFFFFF, 0.2, 12),
                        new TimedTransition(4000, "10")
                    ),
                    new State("10",
                        new TossObject("NM Green Dragon Shield", 3, 0),
                        new TossObject("NM Green Dragon Shield", 3, 45),
                        new TossObject("NM Green Dragon Shield", 3, 90),
                        new TossObject("NM Green Dragon Shield", 3, 135),
                        new TossObject("NM Green Dragon Shield", 3, 180),
                        new TossObject("NM Green Dragon Shield", 3, 225),
                        new TossObject("NM Green Dragon Shield", 3, 270),
                        new TossObject("NM Green Dragon Shield", 3, 315),
                        new TimedTransition(0, "11")
                    ),
                    new State("11",
                        new EntityExistsTransition("NM Green Dragon Shield", 20, "12")
                    ),
                    new State("12",
                        new HpLessTransition(0.05, "15"),
                        new Shoot(0, 12, 30, 0, 45, coolDown: 1500),
                        new Shoot(0, 2, 15, 6, 0, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 90, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 180, coolDown: 1000),
                        new Shoot(0, 2, 15, 6, 270, coolDown: 1000),
                        new Shoot(0, 10, 36, 5, 10, coolDown: 2000),
                        new Shoot(0, 2, 15, 4, coolDown: 1000),
                        new State("13",
                            new EntitiesNotExistsTransition(30, "14", "NM Green Dragon Shield")
                        ),
                        new State("14",
                            new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                            new Follow(0.4, 20, 1),
                            new Spawn("NM Green Dragon Minion", 5, 0)
                        )
                    ),
                    new State("15",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new ReturnToSpawn(0.7),
                        new Decay(3000)
                    )
                )
            )
            ;
    }
}