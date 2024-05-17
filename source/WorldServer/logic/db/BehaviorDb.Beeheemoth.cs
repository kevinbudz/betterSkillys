using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;
using WorldServer.logic.behaviors;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Beeheemoth = () => Behav()
        .Init("EH Hive Bomb",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new TimedTransition(1000, "blue")
                    ),
                new State("blue",
                    new TossObject("EH Ev Chase Blue Fat Bees", 2, 30, 25000),
                    new TossObject("EH Ev Blue Fat Bees", 2, 120, 25000),
                    new TossObject("EH Ev Blue Fat Bees", 2, 90, 25000),
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
                new Orbit(2, 2, 10, "EH Hive Bomb"),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Ev Red Fat Bees",
            new State(
                new Orbit(2, 2, 10, "EH Hive Bomb"),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Ev Blue Fat Bees",
            new State(
                new Orbit(2, 2, 10, "EH Hive Bomb"),
                new Shoot(10, 1, 0, 0, coolDown: 1000)
                )
            )
        .Init("EH Event Hive",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new PlaceMap("setpieces/killer_bee_nest.jm", true),
                new MoveLine(0.5, 315, 1),
                new State("init",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new EntityNotExistsTransition("EH Hive Bomb", 20, "startBlue")
                    ),
                new State("startBlue",
                    new Grenade(2.5, 100, coolDown: 3500),
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
                    new HpLessTransition(0.8, "kaboomBlue"),
                    new TimedTransition(3500, "startRed")
                    ),
                new State("startRed",
                    new Grenade(2.5, 100, coolDown: 3500),
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
                    new HpLessTransition(0.8, "kaboomBlue"),
                    new TimedTransition(3500, "startYellow")
                    ),
                new State("startYellow",
                    new Grenade(2.5, 100, coolDown: 3500),
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
                    new HpLessTransition(0.8, "kaboomBlue"),
                    new TimedTransition(3500, "startBlue")
                    ),
                new State("kaboomBlue",
                    new Shoot(10, 6, 6, 3, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 3, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 270, coolDown: 3500),
                    new HpLessTransition(0.5, "skipToBees"),
                    new TimedTransition(3500, "kaboomRed")
                    ),
                new State("kaboomRed",
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
                    new Shoot(10, 6, 6, 5, 0, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 90, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 180, coolDown: 3500),
                    new Shoot(10, 6, 6, 5, 270, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 0, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 90, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 180, coolDown: 3500),
                    new Shoot(10, 5, 7, 2, 270, coolDown: 3500),
                    new HpLessTransition(0.5, "skipToBees"),
                    new TimedTransition(3500, "skipToBees")
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
                    new TimedTransition(1000, "idle")
                    ),
                new State("idle",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                    )
                )
            );
    }
}
