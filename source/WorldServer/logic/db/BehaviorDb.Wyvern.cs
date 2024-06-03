#region

using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

#endregion

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Wyvern = () => Behav()
            .Init("lod Ivory Wyvern",
                new State(
                    new ScaleHP2(15),
                    new HpLessTransition(0.05, "45"),
                    new TransformOnDeath("lod Ivory Loot"),
                    new State("1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new PlayerWithinTransition(5, "2", true)
                    ),
                    new State("2",
                        new Taunt(true, "Thank you adventurer, you have freed the souls of the four dragons so that i may consume their powers."),
                        new TimedTransition(4000, "3")
                    ),
                    new State("3",
                        new Taunt(true, "i owe you much, but i cannot let you leave. These walls will make a fine graveyard for your bones."),
                        new TimedTransition(4000, "4")
                    ),
                    new State("4",
                        new Taunt(true, "Behold the glory of my true powers..."),
                        new TossObject("lod Mirror Wyvern1", 4, 180, coolDown: 10000),
                        new TossObject("lod Mirror Wyvern2", 8, 180, coolDown: 10000),
                        new TossObject("lod Mirror Wyvern3", 4, 0, coolDown: 10000),
                        new TossObject("lod Mirror Wyvern4", 8, 0, coolDown: 10000),
                        new TimedTransition(500, "5")
                    ),
                    new State("5",
                        new MoveLine(0.5, 90, 1),
                        new TimedTransition(2000, "6")
                    ),
                    new State("6",
                        new HpLessTransition(0.8, "19"),
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new State("7",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 18, 5.5f),
                            new TimedTransition(2000, "8")
                        ),
                        new State("8",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "9")
                        ),
                        new State("9",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 22, 5.5f),
                            new TimedTransition(2000, "10")
                        ),
                        new State("10",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "11")
                        ),
                        new State("11",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 12, 5.5f),
                            new TimedTransition(2000, "12")
                        ),
                        new State("12",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "13")
                        ),
                        new State("13",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 6, 5.5f),
                            new TimedTransition(2000, "14")
                        ),
                        new State("14",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "15")
                        ),
                        new State("15",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 2, 5.5f),
                            new TimedTransition(2000, "16")
                        ),
                        new State("16",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "17")
                        ),
                        new State("17",
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                            new MoveTo(0.7f, 12, 5.5f),
                            new TimedTransition(2000, "18")
                        ),
                        new State("18",
                            new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                            new TimedTransition(1600, "7")
                        )
                    ),
                    new State("19",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Taunt(true, "My magic can no longer sustain my mirrors. what have you done?!"),
                        new OrderOnce(99, "lod Mirror Wyvern1", "Despawn"),
                        new OrderOnce(99, "lod Mirror Wyvern2", "Despawn"),
                        new OrderOnce(99, "lod Mirror Wyvern3", "Despawn"),
                        new OrderOnce(99, "lod Mirror Wyvern4", "Despawn"),
                        new MoveTo(0.7f, 12, 5),
                        new TimedTransition(4000, "20")
                    ),
                    new State("20",
                        new HpLessTransition(0.6, "28"),
                        new Shoot(0, 11, 15, 0, fixedAngle: 90, coolDown: 1500),
                        new State("21",
                            new MoveTo(0.7f, 18, 5),
                            new TimedTransition(2000, "22")
                        ),
                        new State("22",
                            new MoveTo(0.7f, 22, 5),
                            new TimedTransition(2000, "23")
                        ),
                        new State("23",
                            new MoveTo(0.7f, 12, 5),
                            new TimedTransition(4000, "24")
                        ),
                        new State("24",
                            new MoveTo(0.7f, 6, 5),
                            new TimedTransition(2000, "25")
                        ),
                        new State("25",
                            new MoveTo(0.7f, 2, 5),
                            new TimedTransition(2000, "26")
                        ),
                        new State("26",
                            new MoveTo(0.7f, 12, 5),
                            new TimedTransition(4000, "21")
                        )
                    ),
                    new State("28",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new ReturnToSpawn(1, 0),
                        new TimedTransition(5000, "29")
                    ),
                    new State("29",
                        new TossObject("lod Red Soul Flame", 4, 0, 20000),
                        new TossObject("lod Blue Soul Flame", 8, 180, 20000),
                        new TossObject("lod Green Soul Flame", 4, 180, 20000),
                        new TossObject("lod Black Soul Flame", 8, 0, 20000),
                        new EntityExistsTransition("lod Red Soul Flame", 20, "30")
                    ),
                    new State("30",
                        new EntitiesNotExistsTransition(20, "31", "lod Red Soul Flame", "lod Blue Soul Flame", "lod Green Soul Flame", "lod Black Soul Flame")
                    ),
                    new State("31",
                        new Taunt(true, "So you wish to fight your fate? Alright then, I will not hold back any longer."),
                        new MoveTo(0.7f, 12.5f, 17.5f),
                        new TimedTransition(6000, "33")
                    ),
                    new State("33",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Shoot(0, 5, 18, 1, 0), //Green 1
                        new Shoot(0, 5, 18, 2, 90), //Red
                        new Shoot(0, 5, 18, 3, 180), //Blue
                        new Shoot(0, 5, 18, 4, 270), //Black
                        new TimedTransition(500, "34")
                    ),
                    new State("34",
                        new Shoot(0, 5, 18, 1, 90), //Green 2
                        new Shoot(0, 5, 18, 2, 180), //Red
                        new Shoot(0, 5, 18, 3, 270), //Blue
                        new Shoot(0, 5, 18, 4, 0), //Black
                        new TimedTransition(500, "35")
                    ),
                    new State("35",
                        new Shoot(0, 5, 18, 1, 180), //Green 3
                        new Shoot(0, 5, 18, 2, 270), //Red
                        new Shoot(0, 5, 18, 3, 0), //Blue
                        new Shoot(0, 5, 18, 4, 90), //Black
                        new TimedTransition(500, "36")
                    ),
                    new State("36",
                        new Shoot(0, 5, 18, 1, 270), //Green 4
                        new Shoot(0, 5, 18, 2, 0), //Red
                        new Shoot(0, 5, 18, 3, 90), //Blue
                        new Shoot(0, 5, 18, 4, 180), //Black
                        new TimedTransition(500, "37")
                    ),
                    new State("37",
                        new Shoot(0, 5, 18, 1, 0), //Green 5
                        new Shoot(0, 5, 18, 2, 90), //Red
                        new Shoot(0, 5, 18, 3, 180), //Blue
                        new Shoot(0, 5, 18, 4, 270), //Black
                        new TimedTransition(500, "38")
                    ),
                    new State("38",
                        new Shoot(0, 5, 18, 1, 90), //Green 6
                        new Shoot(0, 5, 18, 2, 180), //Red
                        new Shoot(0, 5, 18, 3, 270), //Blue
                        new Shoot(0, 5, 18, 4, 0), //Black
                        new TimedTransition(500, "39")
                    ),
                    new State("39",
                        new Shoot(0, 5, 18, 1, 180), //Green 7
                        new Shoot(0, 5, 18, 2, 270), //Red
                        new Shoot(0, 5, 18, 3, 0), //Blue
                        new Shoot(0, 5, 18, 4, 90), //Black
                        new TimedTransition(500, "40")
                    ),
                    new State("40",
                        new Shoot(0, 5, 18, 1, 270), //Green 8
                        new Shoot(0, 5, 18, 2, 0), //Red
                        new Shoot(0, 5, 18, 3, 90), //Blue
                        new Shoot(0, 5, 18, 4, 180), //Black
                        new TimedTransition(500, "41")
                    ),
                    new State("41",
                        new Shoot(0, 5, 18, 1, 0), //Green 9
                        new Shoot(0, 5, 18, 2, 90), //Red
                        new Shoot(0, 5, 18, 3, 180), //Blue
                        new Shoot(0, 5, 18, 4, 270), //Black
                        new TimedTransition(500, "42")
                    ),
                    new State("42",
                        new TossObject("lod White Dragon Orb", 10, 45, coolDown: 9999),
                        new TossObject("lod White Dragon Orb", 10, 135, coolDown: 9999),
                        new TossObject("lod White Dragon Orb", 10, 225, coolDown: 9999),
                        new TossObject("lod White Dragon Orb", 10, 315, coolDown: 9999),
                        new TimedTransition(500, "43")
                    ),
                    new State("43",
                         new HpLessTransition(0.4, "44"),
                         new Shoot(20, 1, projectileIndex: 1, coolDown: 500)
                    ),
                    new State("44",
                        new Follow(0.5, 10, 0, 6000, 3000),
                        new Shoot(20, 15, 12, 0, coolDown: 2000),
                        new Shoot(20, 1, projectileIndex: 1, coolDown: 3000)
                    ),
                    new State("45",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Taunt("You may have beaten me this time, but i will find a way to leave this place! And on that day, you will suffer greatly..."),
                        new Decay(4000)
                    )
                )
            )
            .Init("lod Mirror Wyvern1",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("Shoot1",
                        new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                        new TimedTransition(1600, "Order1")
                    ),
                    new State("Order1",
                        new OrderOnce(99, "lod Mirror Wyvern2", "1")
                    ),
                    new State("1",
                        new TimedTransition(2000, "Shoot1")
                    ),
                    new State("Despawn",
                        new Decay(1000)
                    )
                )
            )
            .Init("lod Mirror Wyvern2",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("Waiting"),
                    new State("1",
                        new TimedTransition(2000, "Shoot1")
                    ),
                    new State("Shoot1",
                        new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                        new TimedTransition(1600, "Order1")
                    ),
                    new State("Order1",
                        new OrderOnce(99, "lod Mirror Wyvern1", "1")
                    ),
                    new State("Despawn",
                        new Decay(1000)
                    )
                )
            )
            .Init("lod Mirror Wyvern3",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("Shoot1",
                        new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                        new TimedTransition(1600, "Order1")
                    ),
                    new State("Order1",
                        new OrderOnce(99, "lod Mirror Wyvern4", "1")
                    ),
                    new State("1",
                        new TimedTransition(2000, "Shoot1")
                    ),
                    new State("Despawn",
                        new Decay(1000)
                    )
                )
            )
            .Init("lod Mirror Wyvern4",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("Waiting"),
                    new State("1",
                        new TimedTransition(2000, "Shoot1")
                    ),
                    new State("Shoot1",
                        new Shoot(20, 1, projectileIndex: 0, coolDown: 200),
                        new TimedTransition(1600, "Order1")
                    ),
                    new State("Order1",
                        new OrderOnce(99, "lod Mirror Wyvern3", "1")
                    ),
                    new State("Despawn",
                        new Decay(1000)
                    )
                )
            )
            .Init("lod Red Soul Flame",
                new State(
                    new State("Taunt",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Start_Shoot")
                    ),
                    new State("Start_Shoot",
                        new Shoot(8, 6, 30, 0, coolDown: 500),
                        new SetAltTexture(0, 3, cooldown: 500, true)
                    )
                )
            )
            .Init("lod Blue Soul Flame",
                new State(
                    new State("Taunt",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Start_Shoot")
                    ),
                    new State("Start_Shoot",
                        new Shoot(8, 6, 30, 0, coolDown: 500),
                        new SetAltTexture(0, 3, cooldown: 500, true)
                    )
                )
            )
            .Init("lod Green Soul Flame",
                new State(
                    new State("Taunt",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Start_Shoot")
                    ),
                    new State("Start_Shoot",
                        new Shoot(8, 6, 30, 0, coolDown: 500),
                        new SetAltTexture(0, 3, cooldown: 500, true)
                    )
                )
            )
            .Init("lod Black Soul Flame",
                new State(
                    new State("Taunt",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Start_Shoot")
                    ),
                    new State("Start_Shoot",
                        new Shoot(8, 6, 30, 0, coolDown: 500),
                        new SetAltTexture(0, 3, cooldown: 500, true)
                    )
                )
            )
            .Init("lod White Dragon Orb",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new EntityNotExistsTransition("lod Ivory Wyvern", 30, "despawn"),
                    new State("shoot1",
                        new Shoot(0, 12, 30, 0, 0, 45, coolDown: 750)
                    ),
                    new State("despawn",
                        new Decay(1000)
                    )
                )
            )
            .Init("lod Ivory Loot",
                new State(
                    new ScaleHP2(15),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 5000)
                ),
                new Threshold(0.01,
                    new TierLoot(4, ItemType.Ability, 0.125),
                    new TierLoot(12, ItemType.Weapon, 0.03125),
                    new TierLoot(13, ItemType.Armor, 0.03125),
                    new ItemLoot("Large Ivory Dragon Scale Cloth", 0.4),
                    new ItemLoot("Small Ivory Dragon Scale Cloth", 0.4),
                    new ItemLoot("Wine Cellar Incantation", 0.05),
                    new ItemLoot("Helm of Draconic Dominance", 0.02),
                    new TierLoot(2, ItemType.Potion)
                )
            )
            ;
    }
}
