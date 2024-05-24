using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;
using WorldServer.logic.behaviors;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Beeheemoth = () => Behav()
        .Init("EH Ev Chase Fat Bees",
            new State(
                new Follow(1, 12, 1.5),
                new Wander(0.1),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Ev Chase Red Fat Bees",
            new State(
                new Follow(0.8, 12, 1.5),
                new Wander(0.1),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Ev Chase Blue Fat Bees",
            new State(
                new Follow(1, 12, 1.5),
                new Wander(0.1),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Ev Fat Bees",
            new State(
                new State("init",
                    new Orbit(3, 2, 10, "EH Hive Bomb"),
                    new Shoot(10, 1, 0, 0, coolDown: 1000),
                    new EntityNotExistsTransition("EH Hive Bomb", 3, "bombDead")
                    ),
                new State("bombDead",
                    new Follow(0.8, 10, 1),
                    new Shoot(10, 1, 0, 0, coolDown: 1000)
                    )
                )
            )
        .Init("EH Ev Red Fat Bees",
            new State(
                new State("init",
                    new Orbit(3, 2, 10, "EH Hive Bomb"),
                    new Shoot(10, 1, 0, 0, coolDown: 1000),
                    new EntityNotExistsTransition("EH Hive Bomb", 3, "bombDead")
                    ),
                new State("bombDead",
                    new Follow(0.8, 10, 1),
                    new Shoot(10, 1, 0, 0, coolDown: 1000)
                    )
                )
            )
        .Init("EH Ev Blue Fat Bees",
            new State(
                new State("init",
                    new Orbit(3, 2, 10, "EH Hive Bomb"),
                    new Shoot(10, 1, 0, 0, coolDown: 1000),
                    new EntityNotExistsTransition("EH Hive Bomb", 3, "bombDead")
                    ),
                new State("bombDead",
                    new Follow(0.8, 10, 1),
                    new Shoot(10, 1, 0, 0, coolDown: 1000)
                    )
                )
            )
        .Init("EH Blue Guardian Bee",
            new State(
                new ScaleHP2(20),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(1500, "start")
                    ),
                new State("start",
                    new Follow(1.15, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 30, 25000),
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 150, 25000),
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 270, 25000),
                    new EntityNotExistsTransition("EH Red Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Yellow Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.5, "angy")
                    ),
                new State("angy",
                    new Follow(1.15, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntityNotExistsTransition("EH Red Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Yellow Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.1, "decay")
                    ), 
                new State("oneBeeDead",
                    new Orbit(3.8, 5, 30, "EH Event Hive Corpse"),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntitiesNotExistsTransition(30, "backToCenter", "EH Yellow Guardian Bee", "EH Red Guardian Bee"),
                    new HpLessTransition(0.1, "decay")
                    ),
                new State("backToCenter",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ReturnToSpawn(2, 1),
                    new TimedTransition(1500, "big")
                    ),
                new State("big",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "bigger")
                    ),
                new State("bigger",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "biggest")
                    ),
                new State("biggest",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "aggro")
                    ),
                new State("aggro",
                    new Follow(1, 12, 2),
                    new Shoot(10, 4, 90, 3, 45, coolDown: 400),
                    new Shoot(10, 4, 90, 4, 45, coolDown: 400, coolDownOffset: 200),

                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new HpLessTransition(0.1, "startDecay")
                    ),
                new State("startDecay",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ProcEvent(),
                    new Flash(0xff00000, 2, 4),
                    new TimedTransition(1500, "decay")
                    ),
                new State("decay",
                    new Shoot(10, 18, 20, 2, coolDown: 1000),
                    new Decay(100)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("EH Blue Quiver", 0.003),
                    new ItemLoot("EH Blue Bee Armor", 0.02)
                    ),
                new Threshold(.005,
                    LootTemplates.BasicDrop()
                    ),
                new Threshold(.005,
                    LootTemplates.BasicPots()
                    )
                )
        .Init("EH Yellow Guardian Bee",
            new State(
                new ScaleHP2(20),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(1500, "start")
                    ),
                new State("start",  
                    new Follow(1, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new TossObject("EH Ev Chase Fat Bees", 2, 30, 25000),
                    new TossObject("EH Ev Chase Fat Bees", 2, 150, 25000),
                    new TossObject("EH Ev Chase Fat Bees", 2, 270, 25000),
                    new EntityNotExistsTransition("EH Red Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Blue Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.5, "angy")
                    ),
                new State("angy",
                    new Follow(1, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntityNotExistsTransition("EH Red Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Blue Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.1, "decay")
                    ),
                new State("oneBeeDead",
                    new Orbit(4.4, 5, 30, "EH Event Hive Corpse"),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntitiesNotExistsTransition(30, "backToCenter", "EH Blue Guardian Bee", "EH Red Guardian Bee"),
                    new HpLessTransition(0.1, "decay")
                    ),
                new State("backToCenter",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ReturnToSpawn(2, 1),
                    new TimedTransition(1500, "big")
                    ),
                new State("big",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "bigger")
                    ),
                new State("bigger",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "biggest")
                    ),
                new State("biggest",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(300, "aggro")
                    ),
                new State("aggro",
                    new Follow(1, 12, 2),
                    new Shoot(10, 4, 90, 3, 45, coolDown: 400),
                    new Shoot(10, 4, 90, 4, 45, coolDown: 400, coolDownOffset: 200),

                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new HpLessTransition(0.1, "startDecay")
                    ),
                new State("startDecay",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ProcEvent(),
                    new Flash(0xff00000, 2, 4),
                    new TimedTransition(1500, "decay")
                    ),
                new State("decay",
                    new Shoot(10, 18, 20, 2, coolDown: 1000),
                    new Decay(100)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("EH Yellow Quiver", 0.003),
                    new ItemLoot("EH Yellow Bee Armor", 0.02)
                    ),
                new Threshold(.005,
                    LootTemplates.BasicDrop()
                    ),
                new Threshold(.005,
                    LootTemplates.BasicPots()
                    )
                )
        .Init("EH Red Guardian Bee",
            new State(
                new ScaleHP2(20),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(1500, "start")
                    ),
                new State("start",
                    new Follow(1.3, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new TossObject("EH Ev Chase Red Fat Bees", 2, 30, 25000),
                    new TossObject("EH Ev Chase Red Fat Bees", 2, 150, 25000),
                    new TossObject("EH Ev Chase Red Fat Bees", 2, 270, 25000),
                    new EntityNotExistsTransition("EH Blue Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Yellow Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.5, "angy")
                    ),
                new State("angy",
                    new Follow(1.3, 12, 2),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntityNotExistsTransition("EH Blue Guardian Bee", 30, "oneBeeDead"),
                    new EntityNotExistsTransition("EH Yellow Guardian Bee", 30, "oneBeeDead"),
                    new HpLessTransition(0.1, "decay")
                    ),
                new State("oneBeeDead",
                    new Orbit(5, 5, 30, "EH Event Hive Corpse"),
                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new EntitiesNotExistsTransition(30, "backToCenter", "EH Yellow Guardian Bee", "EH Blue Guardian Bee"),
                    new HpLessTransition(0.1, "decay")
                    ),
                new State("backToCenter",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ReturnToSpawn(2, 1),
                    new TimedTransition(1500, "big")
                    ),
                new State("big",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(500, "bigger")
                    ),
                new State("bigger",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(500, "biggest")
                    ),
                new State("biggest",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ChangeSize(25, 200),
                    new HealSelf(1000, 25, true),
                    new TimedTransition(500, "aggro")
                    ),
                new State("aggro",
                    new Follow(1, 12, 2),
                    new Shoot(10, 4, 90, 3, 45, coolDown: 400),
                    new Shoot(10, 4, 90, 4, 45, coolDown: 400, coolDownOffset: 200),

                    new Shoot(10, 4, 90, 0, coolDown: 1000),
                    new Shoot(10, 3, 15, 1, coolDown: 1500),
                    new Shoot(10, 6, 60, 2, angleOffset: 30, coolDown: 1500),
                    new Shoot(10, 3, 120, 3, 0, coolDown: 7000),
                    new HpLessTransition(0.1, "startDecay")
                    ),
                new State("startDecay",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ProcEvent(),
                    new Flash(0xff00000, 2, 4),
                    new TimedTransition(1500, "decay")
                    ),
                new State("decay",
                    new Shoot(10, 18, 20, 2, coolDown: 1000),
                    new Decay(100)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("EH Red Quiver", 0.003),
                    new ItemLoot("EH Red Bee Armor", 0.02)
                    ),
                new Threshold(.005,
                    LootTemplates.BasicDrop()
                    ),
                new Threshold(.005,
                    LootTemplates.BasicPots()
                    )
                )
        .Init("EH Hive Bomb",
            new State(
                new ScaleHP2(10),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedRandomTransition(1500, true, "blue", "yellow", "red")
                    ),
                new State("blue",
                    new TossObject("EH Ev Blue Fat Bees", 2, 0, 25000),
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 72, 25000),
                    new TossObject("EH Ev Blue Fat Bees", 2, 144, 25000),
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 216, 25000),
                    new TossObject("EH Ev Blue Fat Bees", 2, 288, 25000),
                    new Shoot(10, 4, 90, 3, 0, coolDown: 1800),
                    new Shoot(10, 4, 90, 3, 10, coolDown: 1800, coolDownOffset: 200),
                    new Shoot(10, 4, 90, 3, 20, coolDown: 1800, coolDownOffset: 400),
                    new Shoot(10, 4, 90, 3, 30, coolDown: 1800, coolDownOffset: 600),
                    new Shoot(10, 4, 90, 3, 40, coolDown: 1800, coolDownOffset: 800),
                    new Shoot(10, 4, 90, 3, 50, coolDown: 1800, coolDownOffset: 1000),
                    new Shoot(10, 4, 90, 3, 60, coolDown: 1800, coolDownOffset: 1200),
                    new Shoot(10, 4, 90, 3, 70, coolDown: 1800, coolDownOffset: 1400),
                    new Shoot(10, 4, 90, 3, 80, coolDown: 1800, coolDownOffset: 1600),
                    new HpLessTransition(0.2, "startDecay")
                    //new EntitiesNotExistsTransition(50, "yellow", "EH Ev Chase Blue Fat Bees", "EH Ev Blue Fat Bees")
                    ),
                new State("yellow",
                    new TossObject("EH Ev Fat Bees", 2, 0, 25000),
                    new TossObject("EH Ev Chase Fat Bees", 2, 72, 25000),
                    new TossObject("EH Ev Fat Bees", 2, 144, 25000),
                    new TossObject("EH Ev Chase Fat Bees", 2, 216, 25000),
                    new TossObject("EH Ev Fat Bees", 2, 288, 25000),
                    new Shoot(10, 4, 90, 4, 0, coolDown: 1800),
                    new Shoot(10, 4, 90, 4, 10, coolDown: 1800, coolDownOffset: 200),
                    new Shoot(10, 4, 90, 4, 20, coolDown: 1800, coolDownOffset: 400),
                    new Shoot(10, 4, 90, 4, 30, coolDown: 1800, coolDownOffset: 600),
                    new Shoot(10, 4, 90, 4, 40, coolDown: 1800, coolDownOffset: 800),
                    new Shoot(10, 4, 90, 4, 50, coolDown: 1800, coolDownOffset: 1000),
                    new Shoot(10, 4, 90, 4, 60, coolDown: 1800, coolDownOffset: 1200),
                    new Shoot(10, 4, 90, 4, 70, coolDown: 1800, coolDownOffset: 1400),
                    new Shoot(10, 4, 90, 4, 80, coolDown: 1800, coolDownOffset: 1600),
                    new HpLessTransition(0.2, "startDecay")
                    //new EntitiesNotExistsTransition(50, "yellow", "EH Ev Chase Blue Fat Bees", "EH Ev Blue Fat Bees")
                    ),
                new State("red",
                    new TossObject("EH Ev Red Fat Bees", 2, 0, 25000),
                    new TossObject("EH Ev Chase Red Fat Bees", 2, 72, 25000),
                    new TossObject("EH Ev Red Fat Bees", 2, 144, 25000),
                    new TossObject("EH Ev Chase Red Fat Bees", 2, 216, 25000),
                    new TossObject("EH Ev Red Fat Bees", 2, 288, 25000),
                    new Shoot(10, 4, 90, 5, 0, coolDown: 1800),
                    new Shoot(10, 4, 90, 5, 10, coolDown: 1800, coolDownOffset: 200),
                    new Shoot(10, 4, 90, 5, 20, coolDown: 1800, coolDownOffset: 400),
                    new Shoot(10, 4, 90, 5, 30, coolDown: 1800, coolDownOffset: 600),
                    new Shoot(10, 4, 90, 5, 40, coolDown: 1800, coolDownOffset: 800),
                    new Shoot(10, 4, 90, 5, 50, coolDown: 1800, coolDownOffset: 1000),
                    new Shoot(10, 4, 90, 5, 60, coolDown: 1800, coolDownOffset: 1200),
                    new Shoot(10, 4, 90, 5, 70, coolDown: 1800, coolDownOffset: 1400),
                    new Shoot(10, 4, 90, 5, 80, coolDown: 1800, coolDownOffset: 1600),
                    new HpLessTransition(0.2, "startDecay")
                    //new EntitiesNotExistsTransition(50, "yellow", "EH Ev Chase Blue Fat Bees", "EH Ev Blue Fat Bees")
                    ),
                new State("startDecay",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Shoot(10, 6, 60, 2, 30, coolDown: 1000),
                    new Shoot(10, 24, 15, 1, 7.5, coolDown: 1000),
                    new Shoot(10, 24, 15, 0, 7.5, coolDown: 1000),
                    new TimedTransition(250, "decay")
                    ),
                new State("decay",
                    new Decay(1)
                    )
                )
           )
        .Init("EH Event Hive Corpse",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(500, "checkBees")
                    ),
                new State("checkBees",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new EntitiesNotExistsTransition(30, "enrageRed", "EH Blue Guardian Bee", "EH Yellow Guardian Bee"),
                    new EntitiesNotExistsTransition(30, "enrageYellow", "EH Blue Guardian Bee", "EH Red Guardian Bee"),
                    new EntitiesNotExistsTransition(30, "enrageBlue", "EH Red Guardian Bee", "EH Yellow Guardian Bee")
                    ),
                new State("enrageRed",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(2000, "enragedRed")
                    ),
                new State("enrageYellow",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(2000, "enragedYellow")
                    ),
                new State("enrageBlue",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(2000, "enragedBlue")
                    ),
                new State("enragedRed",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Shoot(10, 12, 30, 0, 0, coolDown: 1400),
                    new Shoot(10, 12, 30, 0, 15, coolDown: 1400, coolDownOffset: 700),
                    new EntityNotExistsTransition("EH Red Guardian Bee", 20, "decay")
                    ),
                new State("enragedBlue",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Shoot(10, 12, 30, 1, 1, coolDown: 1400),
                    new Shoot(10, 12, 30, 1, 15, coolDown: 1400, coolDownOffset: 700),
                    new EntityNotExistsTransition("EH Blue Guardian Bee", 20, "decay")
                    ),
                new State("enragedYellow",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Shoot(10, 12, 30, 2, 2, coolDown: 1400),
                    new Shoot(10, 12, 30, 2, 15, coolDown: 1400, coolDownOffset: 700),
                    new EntityNotExistsTransition("EH Yellow Guardian Bee", 20, "decay")
                    ),
                new State("decay",
                    new Decay(1)
                    )
                )
            )
        .Init("EH Event Hive",
            new State(
                new ScaleHP2(20),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new PlaceMap("setpieces/killer_bee_nest.jm", true),
                new MoveLine(0.5, 315, 1),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(1000, "invincBlue")
                    ),
                new State("invincBlue",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Grenade(3.5, 100, coolDown: 1250, color: 255),
                    new Shoot(10, 6, 6, 5, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 270, coolDown: 3500),
                    new EntityNotExistsTransition("EH Hive Bomb", 20, "startBlue"),
                    new TimedTransition(3500, "invincRed")
                    ),
                new State("invincRed",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Grenade(3.5, 100, coolDown: 1250, color: 16742400),
                    new Shoot(10, 6, 6, 4, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 270, coolDown: 3500),
                    new EntityNotExistsTransition("EH Hive Bomb", 20, "startBlue"),
                    new TimedTransition(3500, "invincYellow")
                    ),
                new State("invincYellow",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Grenade(3.5, 100, coolDown: 1250, color: 16776960),
                    new Shoot(10, 6, 6, 3, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 270, coolDown: 3500),
                    new EntityNotExistsTransition("EH Hive Bomb", 20, "startBlue"),
                    new TimedTransition(3500, "invincBlue")
                    ),
                new State("startBlue",
                    new Grenade(3.5, 100, coolDown: 1250, color: 255),
                    new Grenade(1.5, 80, 8, 0, coolDown: 2000),
                    new Grenade(1.5, 80, 8, 120, coolDown: 2000),
                    new Grenade(1.5, 80, 8, 240, coolDown: 2000),
                    new Shoot(10, 3, 120, 1, 0, coolDown: 3500),
                    new Shoot(10, 2, 35, 1, 0, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 1, 120, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 1, 240, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 60, 1, 0, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 1, 120, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 1, 240, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 85, 1, 0, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 1, 120, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 1, 240, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 110, 1, 0, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 1, 120, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 1, 240, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 135, 1, 0, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 1, 120, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 1, 240, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 160, 1, 0, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 1, 120, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 1, 240, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 195, 1, 0, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 1, 120, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 1, 240, coolDown: 3500, coolDownOffset: 1400),
                    new TimedTransition(3250, "blueBuffer")
                    ),
                new State("blueBuffer",
                    new HpLessTransition(0.75, "kaboomBlue"),
                    new TimedTransition(250, "startRed")
                    ),
                new State("startRed",
                    new Grenade(3.5, 100, coolDown: 1250, color: 16742400),
                    new Grenade(1.5, 80, 8, 0, coolDown: 1500),
                    new Grenade(1.5, 80, 8, 120, coolDown: 1500),
                    new Grenade(1.5, 80, 8, 240, coolDown: 1500),
                    new Shoot(10, 3, 120, 0, 60, coolDown: 3500),
                    new Shoot(10, 2, 35, 0, 60, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 0, 180, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 0, 300, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 60, 0, 60, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 0, 180, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 0, 300, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 85, 0, 60, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 0, 180, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 0, 300, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 110, 0, 60, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 0, 180, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 0, 300, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 135, 0, 60, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 0, 180, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 0, 300, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 160, 0, 60, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 0, 180, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 0, 300, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 195, 0, 60, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 0, 180, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 0, 300, coolDown: 3500, coolDownOffset: 1400),
                    new TimedTransition(3250, "redBuffer")
                    ),
                new State("redBuffer",
                    new HpLessTransition(0.75, "kaboomRed"),
                    new TimedTransition(250, "startYellow")
                    ),
                new State("startYellow",
                    new Grenade(3.5, 100, coolDown: 1250, color: 16776960),
                    new Grenade(1.5, 80, 8, 0, coolDown: 1500),
                    new Grenade(1.5, 80, 8, 120, coolDown: 1500),
                    new Grenade(1.5, 80, 8, 240, coolDown: 1500),
                    new Shoot(10, 3, 120, 2, 0, coolDown: 3500),
                    new Shoot(10, 2, 35, 2, 0, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 2, 120, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 35, 2, 240, coolDown: 3500, coolDownOffset: 200),
                    new Shoot(10, 2, 60, 2, 0, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 2, 120, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 60, 2, 240, coolDown: 3500, coolDownOffset: 400),
                    new Shoot(10, 2, 85, 2, 0, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 2, 120, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 85, 2, 240, coolDown: 3500, coolDownOffset: 600),
                    new Shoot(10, 2, 110, 2, 0, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 2, 120, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 110, 2, 240, coolDown: 3500, coolDownOffset: 800),
                    new Shoot(10, 2, 135, 2, 0, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 2, 120, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 135, 2, 240, coolDown: 3500, coolDownOffset: 1000),
                    new Shoot(10, 2, 160, 2, 0, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 2, 120, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 160, 2, 240, coolDown: 3500, coolDownOffset: 1200),
                    new Shoot(10, 2, 195, 2, 0, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 2, 120, coolDown: 3500, coolDownOffset: 1400),
                    new Shoot(10, 2, 195, 2, 240, coolDown: 3500, coolDownOffset: 1400),
                    new TimedTransition(3250, "yellowBuffer")
                    ),
                new State("yellowBuffer",
                    new HpLessTransition(0.75, "kaboomYellow"),
                    new TimedTransition(250, "startBlue")
                    ),
                new State("kaboomBlue",
                    new Grenade(3.5, 100, coolDown: 1000, color: 255),
                    new Shoot(10, 6, 6, 5, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 1, 270, coolDown: 3500),
                    new HpLessTransition(0.5, "skipToBees"),
                    new TimedTransition(3500, "kaboomRed")
                    ),
                new State("kaboomRed",
                    new Grenade(3.5, 100, coolDown: 1250, color: 16742400),
                    new Shoot(10, 6, 6, 4, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 4, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 0, 270, coolDown: 3500),
                    new HpLessTransition(0.5, "skipToBees"),
                    new TimedTransition(3500, "kaboomYellow")
                    ),
                new State("kaboomYellow",
                    new Grenade(3.5, 100, coolDown: 1250, color: 16776960),
                    new Shoot(10, 6, 6, 3, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 270, coolDown: 3500),
                    new HpLessTransition(0.5, "skipToBees"),
                    new TimedTransition(3500, "kaboomBlue")
                    ),
                new State("skipToBees",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new Flash(0x00ff00, 0.5, 3),
                    new TimedTransition(2000, "spawnBees")
                    ),
                new State("spawnBees",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TossObject("EH Blue Guardian Bee", 2, 0, 25000),
                    new TossObject("EH Yellow Guardian Bee", 2, 120, 25000),
                    new TossObject("EH Red Guardian Bee", 2, 240, 25000),
                    new TimedTransition(1500, "idle")
                    ),
                new State("idle",
                    new Transform("EH Event Hive Corpse"),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    )
                )
            );
    }
}
