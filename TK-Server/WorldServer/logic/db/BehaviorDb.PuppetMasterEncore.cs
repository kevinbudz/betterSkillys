using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ PuppetEncore = () => Behav()
        .Init("Encore Huntress Statue",
            new State(
                new State("1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true)
                    ),
                new State("2",
                    new Flash(0xFFFF00, 2, 5),
                    new MoveTo3(9.5f, 16.5f, 0.1, true, true, false),
                    new TimedTransition(2000, "3")
                    ),
                new State("3",
                    new TransformOnDeath("Encore Huntress"),
                    new Suicide()
                    )
                )
            )
        .Init("Encore Trickster Statue",
            new State(
                new State("1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true)
                    ),
                new State("2",
                    new Flash(0xFFFF00, 2, 5),
                    new MoveTo3(16.5f, 16.5f, 0.1, true, true, false),
                    new TimedTransition(2000, "3")
                    ),
                new State("3",
                    new TransformOnDeath("Encore Trickster"),
                    new Suicide()
                    )
                )
            )
        .Init("Confuse Puppet Statue",
            new State(
                new State("1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true)
                    ),
                new State("2",
                    new Flash(0xFFFF00, 2, 5),
                    new MoveTo3(9.5f, 9.5f, 0.1, true, true, false),
                    new TimedTransition(2000, "3")
                    ),
                new State("3",
                    new TransformOnDeath("Confuse Puppet"),
                    new Suicide()
                    )
                )
            )
        .Init("Bleed Puppet Statue",
            new State(
                new State("1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true)
                    ),
                new State("2",
                    new Flash(0xFFFF00, 2, 5),
                    new MoveTo3(16.5f, 9.5f, 0.1, true, true, false),
                    new TimedTransition(2000, "3")
                    ),
                new State("3",
                    new TransformOnDeath("Bleed Puppet"),
                    new Suicide()
                    )
                )
            )
        .Init("Confuse Puppet",
            new State(
                new State("1",
                    new Prioritize(
                    new Orbit(4, 10, 15, "Puppet Master v2", orbitClockwise: false)),
                    new Shoot(15, 3, 360 / 3, 0, 45, coolDown: 1250),
                    new Shoot(15, 3, 360 / 3, 2, 100, coolDown: 1250),
                    new HpLessTransition(0.5, "chase")
                    ),
                new State("chase",
                    new Follow(1.3, 15),
                    new Shoot(15, 3, 360 / 3, 0, 45, coolDown: 1250),
                    new Shoot(15, 3, 360 / 3, 2, 100, coolDown: 1250)
                    )
                )
            )
        .Init("Bleed Puppet",
            new State(
                new Prioritize(
                new Orbit(3, 3, 15, "Puppet Master v2")),
                new State("1",
                    new Shoot(15, 4, 360 / 4, 0, 45, coolDown: 750),
                    new HpLessTransition(0.5, "chase")
                    ),
                new State("chase",
                    new Follow(1.3, 15),
                    new Shoot(15, 4, 360 / 4, 1, 90, coolDown: 750)
                    )
                )
            )
        .Init("Encore Huntress",
            new State(
                new State("1",
                    new Wander(0.3),
                    new HpLessTransition(0.5, "2"),
                    new StayBack(0.3, 5),
                    new Follow(0.4, 10, 5),
                    new Shoot(15, 2, 14, 0, coolDown: 750)
                    ),
                new State("2",
                    new StayBack(0.3, 2),
                    new Follow(0.4, 10, 3),
                    new Shoot(15, 2, 14, 0, coolDown: 500),
                    new Shoot(15, 3, 50, 1, coolDown: 1750)
                    )
                )
            )
        .Init("Encore Trickster",
            new State(
                new Wander(0.3),
                new Follow(0.3, 10, 3),
                new State("1",
                    new HpLessTransition(0.6, "2"),
                    new Grenade(3, 100, 10, coolDown: 4500),
                    new Shoot(15, 1, 0, 0, coolDown: 1000)
                    ),
                new State("2",
                    new Spawn("Puppet Clone", 4),
                    new TimedTransition(10, "3")
                    ),
                new State("3",
                    new Shoot(15, 3, 5, 1, 90, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 180, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 270, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 0, coolDown: 600),
                    new TimedTransition(3000, "4")
                    ),
                new State("4",
                    new Shoot(15, 3, 5, 1, 135, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 225, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 315, coolDown: 600),
                    new Shoot(15, 3, 5, 1, 45, coolDown: 600),
                    new TimedTransition(3000, "3")
                    )
                )
            )
        .Init("Puppet Clone",
            new State(
                new State("1",
                    new Wander(0.3),
                    new Follow(0.4, 10, 0),
                    new Shoot(15, 4, 30, 0, coolDown: 1000)
                    )
                )
            )
        .Init("HomingFire",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new State("idle",
                    new Follow(0.8, 50, 5),
                    new TimedTransition(1000, "white")
                    ),
                new State("white",
                    new Flash(0xFFFFFF, 1, 1),
                    new TimedTransition(500, "shoot")
                    ),
                new State("shoot",
                    new Shoot(50, 1, 0, 0),
                    new Suicide()
                    )
                )
            )
        .Init("Puppet Master v2",
            new State(
                new ScaleHP2(20),
                new MoveTo2(0.5f, 0.5f, 2, true, false, true),
                new State("1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                    new PlayerWithinTransition(30, "2")
                    ),
                new State("2",
                    new Taunt(true, "Hello. Hero. Did you truly think that I was gone forever?"),
                    new TimedTransition(3500, "3")
                    ),
                new State("3",
                    new Taunt(true, "No! I cannot allow you to end my story in such a way"),
                    new TimedTransition(3500, "4")
                    ),
                new State("4",
                    new Taunt(true, "Behold!"),
                    new Flash(0xFFFF00, 1.75, 2),
                    new TossObject("Encore Trickster Statue", 8, 45, coolDown: 3500),
                    new TossObject("Encore Huntress Statue", 8, 135, coolDown: 3500),
                    new TossObject("Confuse Puppet Statue", 8, 225, coolDown: 3500),
                    new TossObject("Bleed Puppet Statue", 8, 315, coolDown: 3500),
                    new TimedTransition(3500, "5")
                    ),
                new State("5",
                    new Taunt(true, "You fail to appreciate my puppets, hero... you do not understand my art. If you cannot be sensible of their beauty then you must die."),
                    new TimedTransition(3500, "6")
                    ),
                new State("6",
                    new Taunt(true, "You cannot return from whence you came. Face me now, hero and prepare to become the finest of my puppets when I am done with you!"),
                    new Flash(0x00FF00, 1.75, 2),
                    new TimedTransition(3500, "7")
                    ),
                new State("7",
                    new RealmPortalDrop(),
                    new Spawn("HomingFire", 1000, 0.001, coolDown: 2500),
                    new State("8",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 8, 360 / 8, 1, 45, coolDown: 500),
                        new TimedTransition(1000, "9")
                        ),
                    new State("9",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 12, 360 / 12, 1, 45, coolDown: 500),
                        new TimedTransition(1000, "10")
                        ),
                    new State("10",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 16, 360 / 16, 1, 45, coolDown: 500),
                        new TimedTransition(1000, "11")
                        ),
                    new State("11",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 7, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "12")
                        ),
                    new State("12",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 13, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "13")
                        ),
                    new State("13",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 19, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "14")
                        ),
                    new State("14",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 7, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "15")
                        ),
                    new State("15",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 13, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "16")
                        ),
                    new State("16",
                        new HpLessTransition(.9, "17"),
                        new Shoot(20, 19, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "11")
                        ),
                    new State("17",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Taunt(true, "Awaken, my dear puppet. Hunt them down!"),
                        new State("01",
                            new Shoot(15, 6, 360 / 6, 3, 0, coolDown: 500),
                            new TimedTransition(500, "02")
                            ),
                        new State("02",
                            new Shoot(15, 6, 360 / 6, 3, 20, coolDown: 5000),
                            new TimedTransition(500, "03")
                            ),
                        new State("03",
                            new Shoot(15, 6, 360 / 6, 3, 40, coolDown: 5000),
                            new TimedTransition(500, "04")
                            ),
                        new State("04",
                            new Shoot(15, 6, 360 / 6, 3, 60, coolDown: 5000),
                            new TimedTransition(500, "05")
                            ),
                        new State("05",
                            new Shoot(15, 6, 360 / 6, 3, 80, coolDown: 5000),
                            new TimedTransition(500, "06")
                            ),
                        new State("06",
                            new Shoot(15, 6, 360 / 6, 3, 100, coolDown: 5000),
                            new TimedTransition(500, "07")
                            ),
                        new State("07",
                            new Shoot(15, 6, 360 / 6, 3, 120, coolDown: 5000),
                            new TimedTransition(500, "08")
                            ),
                        new State("08",
                            new Shoot(15, 6, 360 / 6, 3, 140, coolDown: 5000),
                            new TimedTransition(500, "09")
                            ),
                        new State("09",
                            new Shoot(15, 6, 360 / 6, 3, 160, coolDown: 5000),
                            new TimedTransition(500, "010")
                            ),
                        new State("010",
                            new Shoot(15, 6, 360 / 6, 3, 180, coolDown: 5000),
                            new TimedTransition(500, "011")
                            ),
                        new State("011",
                            new Shoot(15, 6, 360 / 6, 3, 200, coolDown: 5000),
                            new TimedTransition(500, "012")
                            ),
                        new State("012",
                            new Shoot(15, 6, 360 / 6, 3, 220, coolDown: 5000),
                            new TimedTransition(500, "013")
                            ),
                        new State("013",
                            new Shoot(15, 6, 360 / 6, 3, 240, coolDown: 5000),
                            new TimedTransition(500, "014")
                            ),
                        new State("014",
                            new Shoot(15, 6, 360 / 6, 3, 260, coolDown: 5000),
                            new TimedTransition(500, "015")
                            ),
                        new State("015",
                            new Shoot(15, 6, 360 / 6, 3, 280, coolDown: 5000),
                            new TimedTransition(500, "016")
                            ),
                        new State("016",
                            new Shoot(15, 6, 360 / 6, 3, 300, coolDown: 5000),
                            new TimedTransition(500, "017")
                            ),
                        new State("017",
                            new Shoot(15, 6, 360 / 6, 3, 320, coolDown: 5000),
                            new TimedTransition(500, "018")
                            ),
                        new State("018",
                            new Shoot(15, 6, 360 / 6, 3, 340, coolDown: 5000),
                            new TimedTransition(500, "01")
                            ),
                        new OrderOnce(50, "Encore Huntress Statue", "2"),
                        new EntitiesNotExistsTransition(50, "18", "Encore Huntress", "Encore Huntress Statue")
                        ),
                    new State("18",
                        new HpLessTransition(.7, "19"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false, 0),
                        new Taunt(true, "How dare you destroy my prized puppet! You shall pay for this with your life!"),
                        new Shoot(15, 12, 360 / 12, 3, 45, coolDown: 1250),
                        new Shoot(15, 3, 12, 4, coolDown: 750, predictive: 0.07)
                        ),
                    new State("19",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Taunt(true, "Awaken, my dear puppet. Fear its blades"),
                        new State("0111",
                            new Shoot(15, 6, 360 / 6, 3, 0, coolDown: 500),
                            new TimedTransition(500, "0211")
                            ),
                        new State("0211",
                            new Shoot(15, 6, 360 / 6, 3, 20, coolDown: 5000),
                            new TimedTransition(500, "0311")
                            ),
                        new State("0311",
                            new Shoot(15, 6, 360 / 6, 3, 40, coolDown: 5000),
                            new TimedTransition(500, "0411")
                            ),
                        new State("0411",
                            new Shoot(15, 6, 360 / 6, 3, 60, coolDown: 5000),
                            new TimedTransition(500, "0511")
                            ),
                        new State("0511",
                            new Shoot(15, 6, 360 / 6, 3, 80, coolDown: 5000),
                            new TimedTransition(500, "0611")
                            ),
                        new State("0611",
                            new Shoot(15, 6, 360 / 6, 3, 100, coolDown: 5000),
                            new TimedTransition(500, "0711")
                            ),
                        new State("0711",
                            new Shoot(15, 6, 360 / 6, 3, 120, coolDown: 5000),
                            new TimedTransition(500, "0811")
                            ),
                        new State("0811",
                            new Shoot(15, 6, 360 / 6, 3, 140, coolDown: 5000),
                            new TimedTransition(500, "0911")
                            ),
                        new State("0911",
                            new Shoot(15, 6, 360 / 6, 3, 160, coolDown: 5000),
                            new TimedTransition(500, "01011")
                            ),
                        new State("01011",
                            new Shoot(15, 6, 360 / 6, 3, 180, coolDown: 5000),
                            new TimedTransition(500, "01111")
                            ),
                        new State("01111",
                            new Shoot(15, 6, 360 / 6, 3, 200, coolDown: 5000),
                            new TimedTransition(500, "01211")
                            ),
                        new State("01211",
                            new Shoot(15, 6, 360 / 6, 3, 220, coolDown: 5000),
                            new TimedTransition(500, "01311")
                            ),
                        new State("01311",
                            new Shoot(15, 6, 360 / 6, 3, 240, coolDown: 5000),
                            new TimedTransition(500, "01411")
                            ),
                        new State("01411",
                            new Shoot(15, 6, 360 / 6, 3, 260, coolDown: 5000),
                            new TimedTransition(500, "01511")
                            ),
                        new State("01511",
                            new Shoot(15, 6, 360 / 6, 3, 280, coolDown: 5000),
                            new TimedTransition(500, "01611")
                            ),
                        new State("01611",
                            new Shoot(15, 6, 360 / 6, 3, 300, coolDown: 5000),
                            new TimedTransition(500, "01711")
                            ),
                        new State("01711",
                            new Shoot(15, 6, 360 / 6, 3, 320, coolDown: 5000),
                            new TimedTransition(500, "01811")
                            ),
                        new State("01811",
                            new Shoot(15, 6, 360 / 6, 3, 340, coolDown: 5000),
                            new TimedTransition(500, "0111")
                            ),
                        new OrderOnce(50, "Encore Trickster Statue", "2"),
                        new EntitiesNotExistsTransition(50, "20", "Encore Trickster", "Encore Trickster Statue", "Puppet Clone")
                        ),
                    new State("20",
                        new HpLessTransition(.35, "27"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                        new Taunt(true, "No! You will suffer for destroying my precious puppets!"),
                        new TimedTransition(1, "21")
                        ),
                    new State("21",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 7, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "22")
                        ),
                    new State("22",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 13, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "23")
                        ),
                    new State("23",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 19, 10, 4, 0, coolDown: 300),
                        new TimedTransition(300, "24")
                        ),
                    new State("24",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 7, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "25")
                        ),
                    new State("25",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 13, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "26")
                        ),
                    new State("26",
                        new HpLessTransition(.35, "27"),
                        new Shoot(20, 19, 10, 4, 180, coolDown: 300),
                        new TimedTransition(300, "21")
                        ),
                    new State("27",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Taunt(true, "Awaken, my dear puppets, and avenge your fallen brothers. Destroy these so-called heroes, leave them to rot here and become one with the dust."),
                        new State("20111",
                            new Shoot(15, 6, 360 / 6, 3, 0, coolDown: 500),
                            new TimedTransition(500, "20211")
                            ),
                        new State("20211",
                            new Shoot(15, 6, 360 / 6, 3, 20, coolDown: 5000),
                            new TimedTransition(500, "20311")
                            ),
                        new State("20311",
                            new Shoot(15, 6, 360 / 6, 3, 40, coolDown: 5000),
                            new TimedTransition(500, "20411")
                            ),
                        new State("20411",
                            new Shoot(15, 6, 360 / 6, 3, 60, coolDown: 5000),
                            new TimedTransition(500, "20511")
                            ),
                        new State("20511",
                            new Shoot(15, 6, 360 / 6, 3, 80, coolDown: 5000),
                            new TimedTransition(500, "20611")
                            ),
                        new State("20611",
                            new Shoot(15, 6, 360 / 6, 3, 100, coolDown: 5000),
                            new TimedTransition(500, "20711")
                            ),
                        new State("20711",
                            new Shoot(15, 6, 360 / 6, 3, 120, coolDown: 5000),
                            new TimedTransition(500, "20811")
                            ),
                        new State("20811",
                            new Shoot(15, 6, 360 / 6, 3, 140, coolDown: 5000),
                            new TimedTransition(500, "20911")
                            ),
                        new State("20911",
                            new Shoot(15, 6, 360 / 6, 3, 160, coolDown: 5000),
                            new TimedTransition(500, "201011")
                            ),
                        new State("201011",
                            new Shoot(15, 6, 360 / 6, 3, 180, coolDown: 5000),
                            new TimedTransition(500, "201111")
                            ),
                        new State("201111",
                            new Shoot(15, 6, 360 / 6, 3, 200, coolDown: 5000),
                            new TimedTransition(500, "201211")
                            ),
                        new State("201211",
                            new Shoot(15, 6, 360 / 6, 3, 220, coolDown: 5000),
                            new TimedTransition(500, "201311")
                            ),
                        new State("201311",
                            new Shoot(15, 6, 360 / 6, 3, 240, coolDown: 5000),
                            new TimedTransition(500, "201411")
                            ),
                        new State("201411",
                            new Shoot(15, 6, 360 / 6, 3, 260, coolDown: 5000),
                            new TimedTransition(500, "201511")
                            ),
                        new State("201511",
                            new Shoot(15, 6, 360 / 6, 3, 280, coolDown: 5000),
                            new TimedTransition(500, "201611")
                            ),
                        new State("201611",
                            new Shoot(15, 6, 360 / 6, 3, 300, coolDown: 5000),
                            new TimedTransition(500, "201711")
                            ),
                        new State("201711",
                            new Shoot(15, 6, 360 / 6, 3, 320, coolDown: 5000),
                            new TimedTransition(500, "201811")
                            ),
                        new State("201811",
                            new Shoot(15, 6, 360 / 6, 3, 340, coolDown: 5000),
                            new TimedTransition(500, "20111")
                            ),
                        new OrderOnce(50, "Confuse Puppet Statue", "2"),
                        new OrderOnce(50, "Bleed Puppet Statue", "2"),
                        new EntitiesNotExistsTransition(50, "28", "Confuse Puppet Statue", "Confuse Puppet", "Bleed Puppet Statue", "Bleed Puppet")
                        ),
                    new State("28",
                        new Taunt(true, "I will rend your souls from your bodies and turn you into my puppet slaves when this is over!"),
                        new Grenade(5, 120, 20, coolDown: 3000),
                        new Shoot(20, 12, 360 / 12, 1, 45, coolDown: 350),
                        new Shoot(20, 1, 0, 4, coolDown: 500, predictive: 0.09),
                        new State("29",
                            new HpLessTransition(.05, "49"),
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                            new Shoot(25, 1, 0, 2, 0, coolDown: 50),
                            new TimedTransition(50, "30")
                            ),
                        new State("30",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 3, 8, 2, 0, coolDown: 50),
                            new TimedTransition(100, "31")
                            ),
                        new State("31",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 5, 8, 2, 0, coolDown: 50),
                            new TimedTransition(100, "32")
                            ),
                        new State("32",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 7, 8, 2, 0, coolDown: 50),
                            new TimedTransition(100, "33")
                            ),
                        new State("33",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 9, 8, 2, 0, coolDown: 50),
                            new TimedTransition(2000, "34")
                            ),
                        new State("34",
                            new HpLessTransition(.05, "49"),
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                            new Shoot(25, 1, 0, 2, 90, coolDown: 50),
                            new TimedTransition(50, "35")
                            ),
                        new State("35",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 3, 8, 2, 90, coolDown: 50),
                            new TimedTransition(100, "36")
                            ),
                        new State("36",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 5, 8, 2, 90, coolDown: 50),
                            new TimedTransition(100, "37")
                            ),
                        new State("37",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 7, 8, 2, 90, coolDown: 50),
                            new TimedTransition(100, "38")
                            ),
                        new State("38",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 9, 8, 2, 90, coolDown: 50),
                            new TimedTransition(2000, "39")
                            ),
                        new State("39",
                            new HpLessTransition(.05, "49"),
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                            new Shoot(25, 1, 0, 2, 180, coolDown: 50),
                            new TimedTransition(50, "40")
                            ),
                        new State("40",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 3, 8, 2, 180, coolDown: 50),
                            new TimedTransition(100, "41")
                            ),
                        new State("41",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 5, 8, 2, 180, coolDown: 50),
                            new TimedTransition(100, "42")
                            ),
                        new State("42",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 7, 8, 2, 180, coolDown: 50),
                            new TimedTransition(100, "43")
                            ),
                        new State("43",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 9, 8, 2, 180, coolDown: 50),
                            new TimedTransition(2000, "44")
                            ),
                        new State("44",
                            new HpLessTransition(.05, "49"),
                            new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                            new Shoot(25, 1, 0, 2, 270, coolDown: 50),
                            new TimedTransition(50, "45")
                            ),
                        new State("45",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 3, 8, 2, 270, coolDown: 50),
                            new TimedTransition(100, "46")
                            ),
                        new State("46",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 5, 8, 2, 270, coolDown: 50),
                            new TimedTransition(100, "47")
                            ),
                        new State("47",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 7, 8, 2, 270, coolDown: 50),
                            new TimedTransition(100, "48")
                            ),
                        new State("48",
                            new HpLessTransition(.05, "49"),
                            new Shoot(25, 9, 8, 2, 270, coolDown: 50),
                            new TimedTransition(2000, "29")
                            )
                        ),
                    new State("49",
                        new OnDeathBehavior(new Shoot(50, 12, 360 / 12, 3, 45)),
                        new Flash(0xd3d3d3, 2, 15),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Taunt(true, "I don't understand it wasn't supposed to end this way. Noooo!!!"),
                        new TimedTransition(4000, "50")
                        ),
                    new State("50",
                        new Suicide()
                        )
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Potion of Attack", 1),
                new ItemLoot("Soul of Attack", 1),
                new ItemLoot("Potion of Defense", 1),
                new ItemLoot("Potion of Mana", 0.5),
                new ItemLoot("Potion of Attack", 1),
                new ItemLoot("Potion of Defense", 1),
                new ItemLoot("Potion of Mana", 0.5)
                ),
            new Threshold(0.03,
                new ItemLoot("Thousand Shot", 0.001, threshold: 0.0003),
                new ItemLoot("Puppet Master's Encore Key", 0.001, 0, 0.01)
                ),
            new Threshold(0.02,
                new TierLoot(12, ItemType.Armor, 0.15),
                new TierLoot(12, ItemType.Weapon, 0.15),
                new TierLoot(13, ItemType.Armor, 0.1),
                new TierLoot(6, ItemType.Ring, 0.07)
                )
            );
    }
}
