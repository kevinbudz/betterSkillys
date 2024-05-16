#region

using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;
using WorldServer.logic.data;
using WorldServer.logic.behaviors.@new.labels;

#endregion

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ MountainTemple = () => Behav() // by runes :)
        .Init("Daichi the Fallen",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new PlayerWithinTransition(6, "moveCenter")
                    ),
                new State("moveCenter",
                    new Taunt("Ha ha, you are too late. Lord Xil will soon arrive in this realm."),
                    new MoveTo(0.5f, 161.5f, 15.5f),
                    new TimedTransition(4000, "moveTR")
                    ),
                new State("moveTR",
                    new MoveTo3(167.5f, 10.5f, isMapPosition: true, instant: true),
                    new TimedTransition(1500, "spawnTR")
                    ),
                new State("spawnTR",
                    new Spawn("Fire Power", 1),
                    new TimedTransition(250, "moveBR")
                    ),
                new State("moveBR",
                    new MoveTo3(167.5f, 21.5f, isMapPosition: true, instant: true),
                    new TimedTransition(1500, "spawnBR")
                    ),
                new State("spawnBR",
                    new Spawn("Earth Power", 1),
                    new TimedTransition(250, "moveBL")
                    ),
                new State("moveBL",
                    new MoveTo3(156.5f, 21.5f, isMapPosition: true, instant: true),
                    new TimedTransition(1500, "spawnBL")
                    ),
                new State("spawnBL",
                    new Spawn("Water Power", 1),
                    new TimedTransition(250, "moveTL")
                    ),
                new State("moveTL",
                    new MoveTo3(156.5f, 10.5f, isMapPosition: true, instant: true),
                    new TimedTransition(1500, "spawnTL")
                    ),
                new State("spawnTL",
                    new Spawn("Air Power", 1),
                    new TimedTransition(250, "backToCenter")
                    ),
                new State("backToCenter",
                    new MoveTo(0.5f, 161.5f, 15.5f),
                    new TimedTransition(4000, "fight")
                    ),
                new State("fight",
                    new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                    new HpLessTransition(0.67, "initiateAngy"),
                    new Shoot(15, 16, 22.5, 0, coolDown: 5000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 0, coolDown: 3200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 10, coolDown: 3200, coolDownOffset: 200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 20, coolDown: 3200, coolDownOffset: 400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 30, coolDown: 3200, coolDownOffset: 600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 40, coolDown: 3200, coolDownOffset: 800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 50, coolDown: 3200, coolDownOffset: 1000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 60, coolDown: 3200, coolDownOffset: 1200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 70, coolDown: 3200, coolDownOffset: 1400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 80, coolDown: 3200, coolDownOffset: 1600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 70, coolDown: 3200, coolDownOffset: 1800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 60, coolDown: 3200, coolDownOffset: 2000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 50, coolDown: 3200, coolDownOffset: 2200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 40, coolDown: 3200, coolDownOffset: 2400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 30, coolDown: 3200, coolDownOffset: 2600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 20, coolDown: 3200, coolDownOffset: 2800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 10, coolDown: 3200, coolDownOffset: 3000),
                    new TimedTransition(6400, "attackTR")
                    ),
                new State("attackTR",
                    new MoveTo3(167.5f, 10.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.6, "skipToAngy"),
                    new Shoot(15, 22, 15, 2, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 2, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 2, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 2, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 2, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackBL")
                    ),
                new State("attackBL",
                    new MoveTo3(156.5f, 21.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.6, "skipToAngy"),
                    new Shoot(15, 22, 15, 4, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 4, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 4, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 4, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 4, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackTL")
                    ),
                new State("attackTL",
                    new MoveTo3(156.5f, 10.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.6, "skipToAngy"),
                    new Shoot(15, 22, 15, 3, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 3, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 3, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 3, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 3, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackBR")
                    ),
                new State("attackBR",
                    new MoveTo3(167.5f, 21.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.6, "skipToAngy"),
                    new Shoot(15, 22, 15, 5, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 5, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 5, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 5, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 5, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "backToCenter")
                    ),
                new State("skipToAngy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new MoveTo(0.5f, 161.5f, 15.5f),
                    new TimedTransition(3500, "initiateAngy")
                    ),
                new State("initiateAngy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Flash(0x0000ff, 0.66f, 3),
                    new Taunt("Fear my wrath!"),
                    new Shoot(15, 16, 22.5, 0, coolDown: 5000),
                    new TimedTransition(2000, "angy")
                    ),
                new State("angy",
                    new Shoot(15, 16, 22.5, 0, coolDown: 4000),
                    new Shoot(15, 3, 10, 7, coolDown: 4000),
                    new Shoot(15, 2, 12, 6, fixedAngle: 0, coolDown: 1600),
                    new Shoot(15, 2, 12, 6, fixedAngle: 0, coolDown: 1600, coolDownOffset: 200),
                    new Shoot(15, 2, 12, 6, fixedAngle: 180, coolDown: 1600, coolDownOffset: 200),
                    new Shoot(15, 2, 12, 6, fixedAngle: 120, coolDown: 1600, coolDownOffset: 400),
                    new Shoot(15, 2, 12, 6, fixedAngle: 320, coolDown: 1600, coolDownOffset: 400),
                    new Shoot(15, 2, 12, 6, fixedAngle: 37.5, coolDown: 1600, coolDownOffset: 600),
                    new Shoot(15, 2, 12, 6, fixedAngle: 217.5, coolDown: 1600, coolDownOffset: 600),
                    new Shoot(15, 2, 12, 6, fixedAngle: 0, coolDown: 1600, coolDownOffset: 800),
                    new Shoot(15, 2, 12, 6, fixedAngle: 180, coolDown: 1600, coolDownOffset: 800),
                    new Shoot(15, 2, 12, 6, fixedAngle: 100, coolDown: 1600, coolDownOffset: 1000),
                    new Shoot(15, 2, 12, 6, fixedAngle: 280, coolDown: 1600, coolDownOffset: 1000),
                    new Shoot(15, 2, 12, 6, fixedAngle: 20, coolDown: 1600, coolDownOffset: 1200),
                    new Shoot(15, 2, 12, 6, fixedAngle: 200, coolDown: 1600, coolDownOffset: 1200),
                    new Shoot(15, 2, 12, 6, fixedAngle: 60, coolDown: 1600, coolDownOffset: 1400),
                    new Shoot(15, 2, 12, 6, fixedAngle: 240, coolDown: 1600, coolDownOffset: 1400),
                    new HpLessTransition(0.4, "elements"),
                    new TimedTransition(4800, "order")
                    ),
                new State("order",
                    new Taunt("Fear my elements!"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(15, "Fire Power", "initiate"),
                    new Order(15, "Air Power", "initiate"),
                    new Order(15, "Water Power", "initiate"),
                    new Order(15, "Earth Power", "initiate"),
                    new TimedTransition(8000, "orderAgain")
                    ),
                new State("orderAgain",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(15, "Fire Power", "sleepy"),
                    new Order(15, "Air Power", "sleepy"),
                    new Order(15, "Water Power", "sleepy"),
                    new Order(15, "Earth Power", "sleepy"),
                    new TimedTransition(2000, "angy")
                    ),
                new State("elements",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(15, "Fire Power", "spawn"),
                    new Order(15, "Air Power", "spawn"),
                    new Order(15, "Water Power", "spawn"),
                    new Order(15, "Earth Power", "spawn")
                    ),
                new State("increaseSize",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(20, 200)
                    ),
                new State("noBreak",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Order(15, "Fire Power", "sleepy"),
                    new Order(15, "Air Power", "sleepy"),
                    new Order(15, "Water Power", "sleepy"),
                    new Order(15, "Earth Power", "sleepy"),
                    new TimedTransition(250, "fightAgain")
                    ),
                new State("fightAgain",
                    new Spawn("chasingHorror", 1, 0.5, coolDown: 2000),
                    new Shoot(15, 16, 22.5, 0, coolDown: 5000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 0, coolDown: 3200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 10, coolDown: 3200, coolDownOffset: 200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 20, coolDown: 3200, coolDownOffset: 400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 30, coolDown: 3200, coolDownOffset: 600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 40, coolDown: 3200, coolDownOffset: 800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 50, coolDown: 3200, coolDownOffset: 1000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 60, coolDown: 3200, coolDownOffset: 1200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 70, coolDown: 3200, coolDownOffset: 1400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 80, coolDown: 3200, coolDownOffset: 1600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 70, coolDown: 3200, coolDownOffset: 1800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 60, coolDown: 3200, coolDownOffset: 2000),
                    new Shoot(10, 4, 90, 1, fixedAngle: 50, coolDown: 3200, coolDownOffset: 2200),
                    new Shoot(10, 4, 90, 1, fixedAngle: 40, coolDown: 3200, coolDownOffset: 2400),
                    new Shoot(10, 4, 90, 1, fixedAngle: 30, coolDown: 3200, coolDownOffset: 2600),
                    new Shoot(10, 4, 90, 1, fixedAngle: 20, coolDown: 3200, coolDownOffset: 2800),
                    new Shoot(10, 4, 90, 1, fixedAngle: 10, coolDown: 3200, coolDownOffset: 3000),
                    new TimedTransition(6400, "attackTRTwo")
                    ),
                new State("attackTRTwo",
                    new MoveTo3(167.5f, 10.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.1, "backToCenterTwo"),
                    new Shoot(15, 22, 15, 2, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 2, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 2, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 2, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 2, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackBLTwo")
                    ),
                new State("attackBLTwo",
                    new MoveTo3(156.5f, 21.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.1, "backToCenterTwo"),
                    new Shoot(15, 22, 15, 4, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 4, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 4, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 4, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 4, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackTLTwo")
                    ),
                new State("attackTLTwo",
                    new MoveTo3(156.5f, 10.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.1, "backToCenterTwo"),
                    new Shoot(15, 22, 15, 3, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 3, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 3, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 3, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 3, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "attackBRTwo")
                    ),
                new State("attackBRTwo",
                    new MoveTo3(167.5f, 21.5f, isMapPosition: true, instant: true),
                    new HpLessTransition(0.1, "backToCenterTwo"),
                    new Shoot(15, 22, 15, 5, fixedAngle: 0, coolDown: 9999, coolDownOffset: 500),
                    new Shoot(15, 22, 15, 5, fixedAngle: 30, coolDown: 9999, coolDownOffset: 1700),
                    new Shoot(15, 22, 15, 5, fixedAngle: 60, coolDown: 9999, coolDownOffset: 2900),
                    new Shoot(15, 22, 15, 5, fixedAngle: 90, coolDown: 9999, coolDownOffset: 4100),
                    new Shoot(15, 22, 15, 5, fixedAngle: 120, coolDown: 9999, coolDownOffset: 5300),
                    new TimedTransition(6000, "backToCenterTwo")
                    ),
                new State("backToCenterTwo",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new MoveTo(0.5f, 161.5f, 15.5f),
                    new TimedTransition(4000, "fightAgain")
                    )
                )
            )
        .Init("chasingHorror",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Follow(0.6, 10, 5),
                    new TimedTransition(1500, "shootAndDecay")
                    ),
                new State("shootAndDecay",
                    new Shoot(15, 1, 0, 0, coolDown: 2000),
                    new Decay(1)
                    )
                )
            )
        #region powers
        .Init("Fire Power",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("initiate",
                    new Shoot(15, 6, 60, 1, rotateAngle: 10,  coolDown: 800, coolDownOffset: 500)
                    ),
                new State("sleepy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("spawn",
                    new Spawn("Fire Elemental", 1)
                    )
                 )
             )
        .Init("Water Power",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("initiate",
                    new Shoot(15, 6, 60, 1, rotateAngle: 10, coolDown: 800, coolDownOffset: 500)
                     ),
                new State("sleepy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("spawn",
                    new Spawn("Water Elemental", 1)
                    )
                 )
             )
        .Init("Earth Power",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("initiate",
                    new Shoot(15, 6, 60, 1, rotateAngle: 10, coolDown: 800, coolDownOffset: 500)
                    ),
                new State("sleepy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("spawn",
                    new Spawn("Earth Elemental", 1)
                    )
                 )
             )
        .Init("Air Power",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("initiate",
                    new Shoot(15, 6, 60, 1, rotateAngle: 10, coolDown: 800, coolDownOffset: 500)
                    ),
                new State("sleepy",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    ),
                new State("spawn",
                    new Spawn("Air Elemental", 1)
                    )
                 )
             )
        #endregion powers
        #region elementals
        .Init("Fire Elemental",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Protect(1, "Daichi the Fallen", 20, 1, 1),
                    new TimedTransition(4000, "buffer")
                    ),
                new State("buffer",
                    new Order(15, "Daichi the Fallen", "increaseSize"),
                    new TimedTransition(250, "decay")
                    ),
                new State("decay",
                    new Decay(1)
                )
            )
        )
        .Init("Water Elemental",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Protect(1, "Daichi the Fallen", 20, 1, 1),
                    new TimedTransition(4000, "buffer")
                    ),
                new State("buffer",
                    new Order(15, "Daichi the Fallen", "increaseSize"),
                    new TimedTransition(250, "decay")
                    ),
                new State("decay",
                    new Decay(1)
                )
            )
        )
        .Init("Air Elemental",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Protect(1, "Daichi the Fallen", 20, 1, 1),
                    new TimedTransition(4000, "buffer")
                    ),
                new State("buffer",
                    new Order(15, "Daichi the Fallen", "increaseSize"),
                    new TimedTransition(250, "decay")
                    ),
                new State("decay",
                    new Decay(1)
                )
            )
        )
        .Init("Earth Elemental",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Protect(1, "Daichi the Fallen", 20, 1, 1),
                    new TimedTransition(4000, "buffer")
                    ),
                new State("buffer",
                    new Order(15, "Daichi the Fallen", "increaseSize"),
                    new TimedTransition(250, "decay")
                    ),
                new State("decay",
                    new Order(10, "Daichi the Fallen", "fightAgain"),
                    new Decay(1)
                )
            )
        )
        #endregion elementals
        .Init("Corrupted Armor",
            new State(
                new Shoot(10, 1, 0, coolDown: 400, predictive: 1),
                new Shoot(10, 8, 45, 1, coolDown: 400)
                )
            )
        .Init("Corrupted Monk",
            new State(
                new Wander(0.8),
                new PlayerWithinTransition(8, "init"),
                    new State("init",
                        new Follow(0.6, 10, 2),
                        new Shoot(10, 5, 10, 0, coolDown: 1600),
                        new NoPlayerWithinTransition(8, "nofollow")
                    ),
                    new State("nofollow",
                        new Wander(0.6),
                        new Shoot(10, 5, 10, 0, coolDown: 1600),
                        new PlayerWithinTransition(8, "init")
                    )
                )
            )
        .Init("Corrupted Spawn",
            new State(
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, 0, 0, coolDown: 1000),
                new Shoot(10, 2, 20, 0, coolDown: 1000, coolDownOffset: 333),
                new Shoot(10, 2, 20, 0, coolDown: 1000, coolDownOffset: 666),
                new Shoot(10, 8, 45, 0, coolDown: 2000, coolDownOffset: 666)
                )
            )
        .Init("Corrupted Spearman",
            new State(
                new Follow(0.6, 10, 2),
                new Shoot(10, 3, 10, coolDown: 1000),
                new Shoot(10, 10, 36, 1, coolDown: 1000)
                )
            )
        .Init("Corrupted Caster",
            new State(
                new Wander(0.8),
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, 20, 0, coolDown: 1500),
                new Shoot(10, 8, 45, 1, coolDown: 1500)
                )
            )
        .Init("Corrupted Bowman",
            new State(
                new Wander(0.8),
                new PlayerWithinTransition(8, "charge"),
                    new State("charge",
                        new Wander(0.6),
                        new Follow(0.6, 10, 2),
                        new Shoot(10, 1, 0, 1, coolDown: 2000),
                        new Shoot(10, 2, 15, 0, coolDown: 2000, coolDownOffset: 600),
                        new Shoot(10, 2, 15, 0, coolDown: 2000, coolDownOffset: 1200),
                        new TimedTransition(4000, "idle")
                    ),
                    new State("idle",
                        new Wander(0.8),
                        new TimedTransition(750, "charge")
                    )
                )
            );
    }
}