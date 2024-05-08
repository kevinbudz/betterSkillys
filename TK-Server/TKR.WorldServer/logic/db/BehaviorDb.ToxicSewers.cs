using TKR.Shared.resources;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.transitions;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ ToxicSewers = () => Behav()

        #region Boss

        .Init("DS Gulpord the Slime God",
            new State(
                new ScaleHP2(20),
                new State("Waiting Player",
                    new PlayerWithinTransition(10, "Start Shooting")
                    ),
                new State("Start Shooting",
                    new Wander(0.3),
                    new StayCloseToSpawn(0.3, 1),
                    new Shoot(15, 8, projectileIndex: 1, fixedAngle: 0, coolDown: 500),
                    new TimedTransition(10000, "Shooting 2")
                    ),
                new State("Shooting 2",
                    new Wander(0.3),
                    new StayCloseToSpawn(0.3, 1),

                    new Shoot(15, 8, projectileIndex: 1, fixedAngle: 0, coolDown: 500),

                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 90, shootAngle: 10, coolDown: 3400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 110, shootAngle: 10, coolDown: 3400, coolDownOffset: 200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 130, shootAngle: 10, coolDown: 3400, coolDownOffset: 400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 150, shootAngle: 10, coolDown: 3400, coolDownOffset: 600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 170, shootAngle: 10, coolDown: 3400, coolDownOffset: 800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 190, shootAngle: 10, coolDown: 3400, coolDownOffset: 1000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 210, shootAngle: 10, coolDown: 3400, coolDownOffset: 1200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 230, shootAngle: 10, coolDown: 3400, coolDownOffset: 1400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 250, shootAngle: 10, coolDown: 3400, coolDownOffset: 1600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 270, shootAngle: 10, coolDown: 3400, coolDownOffset: 1800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 290, shootAngle: 10, coolDown: 3400, coolDownOffset: 2000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 310, shootAngle: 10, coolDown: 3400, coolDownOffset: 2200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 330, shootAngle: 10, coolDown: 3400, coolDownOffset: 2400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 350, shootAngle: 10, coolDown: 3400, coolDownOffset: 2600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 370, shootAngle: 10, coolDown: 3400, coolDownOffset: 2800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 390, shootAngle: 10, coolDown: 3400, coolDownOffset: 3000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 410, shootAngle: 10, coolDown: 3400, coolDownOffset: 3200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 430, shootAngle: 10, coolDown: 3400, coolDownOffset: 3400),

                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 15, shootAngle: 10, coolDown: 7000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 35, shootAngle: 10, coolDown: 7000, coolDownOffset: 400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 55, shootAngle: 10, coolDown: 7000, coolDownOffset: 800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 75, shootAngle: 10, coolDown: 7000, coolDownOffset: 1200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 95, shootAngle: 10, coolDown: 7000, coolDownOffset: 1600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 115, shootAngle: 10, coolDown: 7000, coolDownOffset: 2200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 135, shootAngle: 10, coolDown: 7000, coolDownOffset: 2600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 155, shootAngle: 10, coolDown: 7000, coolDownOffset: 3000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 175, shootAngle: 10, coolDown: 7000, coolDownOffset: 3400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 195, shootAngle: 10, coolDown: 7000, coolDownOffset: 3800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 215, shootAngle: 10, coolDown: 7000, coolDownOffset: 4200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 235, shootAngle: 10, coolDown: 7000, coolDownOffset: 4600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 255, shootAngle: 10, coolDown: 7000, coolDownOffset: 5000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 275, shootAngle: 10, coolDown: 7000, coolDownOffset: 5400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 295, shootAngle: 10, coolDown: 7000, coolDownOffset: 5800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 315, shootAngle: 10, coolDown: 7000, coolDownOffset: 6200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 335, shootAngle: 10, coolDown: 7000, coolDownOffset: 6600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 355, shootAngle: 10, coolDown: 7000, coolDownOffset: 7000),

                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 90, shootAngle: 10, coolDown: 3400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 110, shootAngle: 10, coolDown: 3400, coolDownOffset: 200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 130, shootAngle: 10, coolDown: 3400, coolDownOffset: 400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 150, shootAngle: 10, coolDown: 3400, coolDownOffset: 600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 170, shootAngle: 10, coolDown: 3400, coolDownOffset: 800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 190, shootAngle: 10, coolDown: 3400, coolDownOffset: 1000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 210, shootAngle: 10, coolDown: 3400, coolDownOffset: 1200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 230, shootAngle: 10, coolDown: 3400, coolDownOffset: 1400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 250, shootAngle: 10, coolDown: 3400, coolDownOffset: 1600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 270, shootAngle: 10, coolDown: 3400, coolDownOffset: 1800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 290, shootAngle: 10, coolDown: 3400, coolDownOffset: 2000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 310, shootAngle: 10, coolDown: 3400, coolDownOffset: 2200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 330, shootAngle: 10, coolDown: 3400, coolDownOffset: 2400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 350, shootAngle: 10, coolDown: 3400, coolDownOffset: 2600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 370, shootAngle: 10, coolDown: 3400, coolDownOffset: 2800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 390, shootAngle: 10, coolDown: 3400, coolDownOffset: 3000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 410, shootAngle: 10, coolDown: 3400, coolDownOffset: 3200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 430, shootAngle: 10, coolDown: 3400, coolDownOffset: 3400),

                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 295, shootAngle: 10, coolDown: 7000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 315, shootAngle: 10, coolDown: 7000, coolDownOffset: 400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 335, shootAngle: 10, coolDown: 7000, coolDownOffset: 800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 355, shootAngle: 10, coolDown: 7000, coolDownOffset: 1200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 375, shootAngle: 10, coolDown: 7000, coolDownOffset: 1600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 395, shootAngle: 10, coolDown: 7000, coolDownOffset: 2200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 415, shootAngle: 10, coolDown: 7000, coolDownOffset: 2600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 435, shootAngle: 10, coolDown: 7000, coolDownOffset: 3000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 455, shootAngle: 10, coolDown: 7000, coolDownOffset: 3400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 475, shootAngle: 10, coolDown: 7000, coolDownOffset: 3800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 495, shootAngle: 10, coolDown: 7000, coolDownOffset: 4200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 515, shootAngle: 10, coolDown: 7000, coolDownOffset: 4600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 535, shootAngle: 10, coolDown: 7000, coolDownOffset: 5000),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 555, shootAngle: 10, coolDown: 7000, coolDownOffset: 5400),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 575, shootAngle: 10, coolDown: 7000, coolDownOffset: 5800),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 595, shootAngle: 10, coolDown: 7000, coolDownOffset: 6200),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 615, shootAngle: 10, coolDown: 7000, coolDownOffset: 6600),
                    new Shoot(15, 2, projectileIndex: 0, fixedAngle: 635, shootAngle: 10, coolDown: 7000, coolDownOffset: 7000),

                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 90, shootAngle: 10, coolDown: 3400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 110, shootAngle: 10, coolDown: 3400, coolDownOffset: 200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 130, shootAngle: 10, coolDown: 3400, coolDownOffset: 400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 150, shootAngle: 10, coolDown: 3400, coolDownOffset: 600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 170, shootAngle: 10, coolDown: 3400, coolDownOffset: 800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 190, shootAngle: 10, coolDown: 3400, coolDownOffset: 1000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 210, shootAngle: 10, coolDown: 3400, coolDownOffset: 1200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 230, shootAngle: 10, coolDown: 3400, coolDownOffset: 1400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 250, shootAngle: 10, coolDown: 3400, coolDownOffset: 1600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 270, shootAngle: 10, coolDown: 3400, coolDownOffset: 1800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 290, shootAngle: 10, coolDown: 3400, coolDownOffset: 2000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 310, shootAngle: 10, coolDown: 3400, coolDownOffset: 2200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 330, shootAngle: 10, coolDown: 3400, coolDownOffset: 2400),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 350, shootAngle: 10, coolDown: 3400, coolDownOffset: 2600),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 370, shootAngle: 10, coolDown: 3400, coolDownOffset: 2800),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 390, shootAngle: 10, coolDown: 3400, coolDownOffset: 3000),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 410, shootAngle: 10, coolDown: 3400, coolDownOffset: 3200),
                    new Shoot(15, 3, projectileIndex: 0, fixedAngle: 430, shootAngle: 10, coolDown: 3400, coolDownOffset: 3400),
                    new HpLessTransition(0.70, "Shooting 3 Prepare"),
                    new TimedTransition(15000, "Shooting 3 Prepare")
                    ),
                new State("Shooting 3 Prepare",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 500),
                    new ReturnToSpawn(1),
                    new TimedTransition(500, "Shooting 3")
                    ),
                new State("Shooting 3",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 500),
                    new Shoot(15, 1, projectileIndex: 3, coolDown: 500),
                    new Shoot(15, 8, projectileIndex: 1, fixedAngle: 0, coolDown: 500),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 0, coolDown: 9200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 10, coolDown: 9200, coolDownOffset: 200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 20, coolDown: 9200, coolDownOffset: 400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 30, coolDown: 9200, coolDownOffset: 600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 15, coolDown: 9200, coolDownOffset: 800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 40, coolDown: 9200, coolDownOffset: 1000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 50, coolDown: 9200, coolDownOffset: 1200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 60, coolDown: 9200, coolDownOffset: 1400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 70, coolDown: 9200, coolDownOffset: 1600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 45, coolDown: 9200, coolDownOffset: 1800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 80, coolDown: 9200, coolDownOffset: 2000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 90, coolDown: 9200, coolDownOffset: 2200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 100, coolDown: 9200, coolDownOffset: 2400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 110, coolDown: 9200, coolDownOffset: 2600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 85, coolDown: 9200, coolDownOffset: 2800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 120, coolDown: 9200, coolDownOffset: 3000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 130, coolDown: 9200, coolDownOffset: 3200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 140, coolDown: 9200, coolDownOffset: 3400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 150, coolDown: 9200, coolDownOffset: 3600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 125, coolDown: 9200, coolDownOffset: 3800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 160, coolDown: 9200, coolDownOffset: 4000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 170, coolDown: 9200, coolDownOffset: 4200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 180, coolDown: 9200, coolDownOffset: 4400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 190, coolDown: 9200, coolDownOffset: 4600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 165, coolDown: 9200, coolDownOffset: 4800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 200, coolDown: 9200, coolDownOffset: 5000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 210, coolDown: 9200, coolDownOffset: 5200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 220, coolDown: 9200, coolDownOffset: 5400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 230, coolDown: 9200, coolDownOffset: 5600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 205, coolDown: 9200, coolDownOffset: 5800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 240, coolDown: 9200, coolDownOffset: 6000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 250, coolDown: 9200, coolDownOffset: 6200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 260, coolDown: 9200, coolDownOffset: 6400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 270, coolDown: 9200, coolDownOffset: 6600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 245, coolDown: 9200, coolDownOffset: 6800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 280, coolDown: 9200, coolDownOffset: 7000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 290, coolDown: 9200, coolDownOffset: 7200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 300, coolDown: 9200, coolDownOffset: 7400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 310, coolDown: 9200, coolDownOffset: 7600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 285, coolDown: 9200, coolDownOffset: 7800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 310, coolDown: 9200, coolDownOffset: 8000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 320, coolDown: 9200, coolDownOffset: 8200),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 330, coolDown: 9200, coolDownOffset: 8400),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 340, coolDown: 9200, coolDownOffset: 8600),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 315, coolDown: 9200, coolDownOffset: 8800),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 350, coolDown: 9200, coolDownOffset: 9000),
                    new Shoot(15, 8, projectileIndex: 0, fixedAngle: 360, coolDown: 9200, coolDownOffset: 9200),
                    new HpLessTransition(.5, "Minions v1")
                    ),
                new State("Minions v1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false, 1100),
                    new ChangeSize(-35, 0),
                    new TimedTransition(1100, "Minions v2")
                    ),
                new State("Minions v2",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Spawn("DS Gulpord the Slime God M", 2, 1, 0, true),
                    new EntitiesNotExistsTransition(30, "Chase v1", "DS Gulpord the Slime God M", "DS Gulpord the Slime God S")
                    ),
                new State("Chase v1",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new ChangeSize(35, 120),
                    new TimedTransition(1100, "Chase v2")
                    ),
                new State("Chase v2",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new Flash(0xFF0000, 0.5, 6),
                    new TimedTransition(1500, "Chase v3")
                    ),
                new State("Chase v3",
                    new ConditionEffectBehavior(ConditionEffectIndex.StunImmune),
                    new ConditionEffectBehavior(ConditionEffectIndex.ParalyzeImmune),
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false, 2000),
                    new Follow(1, 15, 0),
                    new Shoot(15, 2, shootAngle: 25, projectileIndex: 0, coolDown: 100),
                    new Shoot(15, 8, fixedAngle: 0, projectileIndex: 2, coolDown: 500, coolDownOffset: 500),
                    new Shoot(15, 1, projectileIndex: 1, coolDown: 400),
                    new HpLessTransition(0.05, "dead1")
                    ),
                new State("dead1",
                    new Suicide()
                    )
                ),
            new Threshold(0.01,
                new TierLoot(11, ItemType.Weapon, 0.15),
                new TierLoot(12, ItemType.Weapon, 0.07),
                new TierLoot(11, ItemType.Armor, 0.15),
                new TierLoot(12, ItemType.Armor, 0.07),
                new TierLoot(4, ItemType.Ability, 0.1),
                new TierLoot(5, ItemType.Ability, 0.07),
                new TierLoot(5, ItemType.Ring, 0.07),
                new ItemLoot("Potion of Defense", 1),
                new ItemLoot("Potion of Defense", 1)
                ),
            new Threshold(0.03,
                new ItemLoot("Void Blade", 0.01, threshold: 0.03),
                new ItemLoot("Murky Toxin", 0.01),
                new ItemLoot("Toxic Sewers Key", 0.1, 0, 0.03)
                )
            )
        .Init("DS Gulpord the Slime God M",
            new State(
                new State("Shooting",
                    new Shoot(15, 8, projectileIndex: 1, fixedAngle: 0, coolDown: 1000, coolDownOffset: 1000),
                    new Shoot(15, 5, shootAngle: 25, projectileIndex: 0, coolDown: 1000),
                    new Orbit(1, 4, 20, "DS Gulpord the Slime God", orbitClockwise: true),
                    new TransformOnDeath("DS Gulpord the Slime God S", 2, 2, 1)
                    )
                )
            )
        .Init("DS Gulpord the Slime God S",
            new State(
                new State("Shooting",
                    new Shoot(15, 8, projectileIndex: 1, fixedAngle: 0, coolDown: 1000, coolDownOffset: 1000),
                    new Shoot(15, 5, shootAngle: 25, projectileIndex: 0, coolDown: 1000),
                    new Orbit(1, 4, 20, "DS Gulpord the Slime God", orbitClockwise: true),
                    new HpLessTransition(.15, "Back")
                    ),
                new State("Back",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new ReturnToSpawn(0.5),
                    new TimedTransition(1000, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                )
            )

        #endregion Boss

        #region Mobs

        .Init("DS Alligator",
            new State(
                new Wander(.6),
                new Shoot(5, 3, shootAngle: 15, projectileIndex: 0, coolDown: 1500)
                )
            )
        .Init("DS Bat",
            new State(
                new State("Without player",
                    new Wander(.7),
                    new Shoot(3, coolDown: 100),
                    new PlayerWithinTransition(5, "Player")
                    ),
                new State("Player",
                    new Charge(3, 8, 2000),
                    new Follow(0.7, 5, 0),
                    new Shoot(3, coolDown: 100),
                    new NoPlayerWithinTransition(5, "Without player")
                    )
                )
            )
        .Init("DS Brown Slime",
            new State(
                new State("No Player",
                    new Follow(0.6, 5, 0),
                    new Wander(0.6),
                    new Shoot(10, 8, projectileIndex: 0, coolDown: 1500),
                    new Reproduce("DS Brown Slime Trail", 100, 10, 50),
                    new PlayerWithinTransition(5, "Player")
                    ),
                new State("Player",
                    new Follow(0.6, 5, 0),
                    new Shoot(10, 8, projectileIndex: 0, coolDown: 1500),
                    new Reproduce("DS Brown Slime Trail", 100, 10, 50),
                    new NoPlayerWithinTransition(5, "No Player")
                    )
                )
            )
        .Init("DS Brown Slime Trail",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new Shoot(1, 1, projectileIndex: 0, coolDown: 50),
                new State("Start",
                    new TimedTransition(500, "Dissapear")
                    ),
                new State("Dissapear",
                    new ChangeSize(-10, 0),
                    new TimedTransition(500, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                )
            )
        .Init("DS Goblin Brute",
            new State(
                new Follow(0.8, 9, 0),
                new Shoot(10, 4, shootAngle: 15, projectileIndex: 0, coolDown: 1000)
                )
            )
        .Init("DS Goblin Knight",
            new State(
                new State("Waiting player",
                    new PlayerWithinTransition(5, "Player founded")
                    ),
                new State("Player founded",
                    new Wander(0.6),
                    new Follow(0.6, 10, 1),
                    new Shoot(10, 1, projectileIndex: 0, coolDown: 1000, predictive: 0.5)
                    )
                ),
            new Threshold(0.01,
                new TierLoot(7, ItemType.Weapon, 0.09),
                new TierLoot(7, ItemType.Armor, 0.09)
                )
            )
        .Init("DS Goblin Peon",
            new State(
                new Follow(0.7, 10, 1),
                new Shoot(9, 2, shootAngle: 20, projectileIndex: 0, coolDown: 500)
                )
            )
        .Init("DS Goblin Sorcerer",
            new State(
                new Wander(0.6),
                new Shoot(10, 5, shootAngle: 20, projectileIndex: 0, coolDown: 1000),
                new Grenade(3, 30, 4, coolDown: 1000, effect: ConditionEffectIndex.Confused, effectDuration: 3000)
                )
            )
        .Init("DS Goblin Warlock",
            new State(
                new Wander(0.6),
                new StayBack(0.6, 6),
                new Shoot(10, 2, projectileIndex: 0, shootAngle: 0, coolDown: 1000),
                new Shoot(10, 1, projectileIndex: 1, coolDown: 1000)
                ),
            new Threshold(0.01,
                new TierLoot(4, ItemType.Ability, 0.03)
                )
            )
        .Init("DS Fly",
            new State(
                new Wander(0.3),
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible)
                )
            )
        .Init("DS Golden Rat",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.StasisImmune),
                new ConditionEffectBehavior(ConditionEffectIndex.StunImmune),
                new ConditionEffectBehavior(ConditionEffectIndex.ParalyzeImmune),
                new State("No player",
                    new Wander(0.6),
                    new PlayerWithinTransition(10, "Player")
                    ),
                new State("Player",
                    new Taunt("Squeerk!"),
                    new StayBack(.9, 99),
                    new TimedTransition(15000, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                ),
            new Threshold(0.3,
                new ItemLoot("Potion of Defense", 1),
                new ItemLoot("Murky Toxin", 0.01)
                )
            )
        .Init("DS Natural Slime God",
            new State(
                new Prioritize(
                    new StayAbove(1, 200),
                    new Follow(1, range: 7),
                    new Wander(0.4)
                    ),
                new Shoot(12, projectileIndex: 0, count: 5, shootAngle: 10, predictive: 1, coolDown: 1000),
                new Shoot(10, projectileIndex: 1, predictive: 0, coolDown: 650)
                ),
            new TierLoot(6, ItemType.Weapon, 0.04),
            new Threshold(0.18,
                new ItemLoot("Potion of Defense", 0.03),
                new TierLoot(7, ItemType.Weapon, 0.1),
                new TierLoot(8, ItemType.Weapon, 0.08),
                new TierLoot(7, ItemType.Armor, 0.1),
                new TierLoot(8, ItemType.Armor, 0.08),
                new TierLoot(9, ItemType.Armor, 0.05),
                new TierLoot(4, ItemType.Ability, 0.05)
                )
            )
        .Init("DS Rat",
            new State(
                new Follow(0.6, 10, 1),
                new Shoot(10, 3, shootAngle: 20, projectileIndex: 0, coolDown: 1000)
                ),
            new Threshold(0.01,
                new TierLoot(7, ItemType.Weapon, 0.05)
                )
            )
        .Init("DS Yellow Slime",
            new State(
                new State("No Player",
                    new Follow(0.6, 5, 0),
                    new Wander(0.6),
                    new Shoot(10, 8, projectileIndex: 0, coolDown: 1500),
                    new Reproduce("DS Brown Slime Trail", 100, 10, 50),
                    new PlayerWithinTransition(5, "Player")
                    ),
                new State("Player",
                    new Follow(0.6, 5, 0),
                    new Shoot(10, 8, projectileIndex: 0, coolDown: 1500),
                    new Reproduce("DS Brown Slime Trail", 100, 10, 50),
                    new NoPlayerWithinTransition(5, "No Player")
                    )
                ),
            new TierLoot(1, ItemType.Potion, 1)
            )
        .Init("DS Yellow Slime Trail",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new Shoot(1, 1, projectileIndex: 0, coolDown: 50),
                new State("Start",
                    new TimedTransition(500, "Dissapear")
                    ),
                new State("Dissapear",
                    new ChangeSize(-10, 0),
                    new TimedTransition(500, "Suicide")
                    ),
                new State("Suicide",
                    new Suicide()
                    )
                )
            )

        #endregion Mobs

        #region Treasure

        .Init("DS Master Rat",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                new State("Waiting player",
                    new PlayerWithinTransition(7, "Start")
                    ),
                new State("Start",
                    new Taunt("Hello young adventurers, will you be able to answer my question correctly?"),
                    new TimedRandomTransition(2000, false, "First", "Second", "Third", "Four", "Five")
                    ),
                new State("First",
                    new Taunt("What time is it?"),
                    new PlayerTextTransition("Correct!", "Its pizza time!", 20, true, true),
                    new TimedTransition(10000, "Incorrect")
                    ),
                new State("Second",
                    new Taunt("Where is the safest place in the world?"),
                    new PlayerTextTransition("Correct!", "Inside my shell.", 20, true, true),
                    new TimedTransition(10000, "Incorrect")
                    ),
                new State("Third",
                    new Taunt("What is fast, quiet and hidden by the night?"),
                    new PlayerTextTransition("Correct!", "A ninja of course!", 20, true, true),
                    new TimedTransition(10000, "Incorrect")
                    ),
                new State("Four",
                    new Taunt("How do you like your pizza?"),
                    new PlayerTextTransition("Correct!", "Extra cheese, hold the anchovies.", 20, true, true),
                    new TimedTransition(10000, "Incorrect")
                    ),
                new State("Five",
                    new Taunt("Who did this to me?"),
                    new PlayerTextTransition("Correct!", "Dr. Terrible, the mad scientist.", 20, true, true),
                    new TimedTransition(10000, "Incorrect")
                    ),
                new State("Correct!",
                    new Taunt("Cowabunga!"),
                    new TossObject2("DS Blue Turtle", 3, coolDown: 1000, randomToss: true),
                    new TossObject2("DS Orange Turtle", 3, coolDown: 1000, randomToss: true),
                    new TossObject2("DS Purple Turtle", 3, coolDown: 1000, randomToss: true),
                    new TossObject2("DS Red Turtle", 3, coolDown: 1000, randomToss: true),
                    new TimedTransition(500, "Spawn Correct")
                    ),
                new State("Spawn Correct",
                    new Suicide()
                    ),
                new State("Incorrect",
                    new Taunt("It's time you turtles learned your place!"),
                    new TimedTransition(300, "Incorrect Kill")
                    ),
                new State("Incorrect Kill",
                    new Shoot(20, 16, projectileIndex: 0, fixedAngle: 0, coolDown: 100000),
                    new Suicide()
                    )
                )
            )
        .Init("DS Blue Turtle",
            new State(
                new Wander(0.3),
                new StayCloseToSpawn(0.3, 5)
                ),
            new Threshold(0.03,
                new ItemLoot("Potion of Defense", 0.09),
                new ItemLoot("Sludge-Covered Cane", 0.001),
                new ItemLoot("Void Blade", 0.01, threshold: 0.03),
                new ItemLoot("Murky Toxin", 0.01)
                )
            )
        .Init("DS Orange Turtle",
            new State(
                new Wander(0.3),
                new StayCloseToSpawn(0.3, 5)
                ),
            new Threshold(0.03,
                new ItemLoot("Potion of Defense", 0.09),
                new ItemLoot("Sludge-Covered Cane", 0.001),
                new ItemLoot("Void Blade", 0.01, threshold: 0.03),
                new ItemLoot("Murky Toxin", 0.01)
                )
            )
        .Init("DS Purple Turtle",
            new State(
                new Wander(0.3),
                new StayCloseToSpawn(0.3, 5)
                ),
            new Threshold(0.03,
                new ItemLoot("Potion of Defense", 0.09),
                new ItemLoot("Sludge-Covered Cane", 0.001),
                new ItemLoot("Void Blade", 0.01, threshold: 0.03),
                new ItemLoot("Murky Toxin", 0.01)
                )
            )
        .Init("DS Red Turtle",
            new State(
                new Wander(0.3),
                new StayCloseToSpawn(0.3, 5)
                ),
            new Threshold(0.03,
                new ItemLoot("Potion of Defense", 0.09),
                new ItemLoot("Sludge-Covered Cane", 0.001),
                new ItemLoot("Void Blade", 0.01, threshold: 0.03),
                new ItemLoot("Murky Toxin", 0.01)
                )
            )

        #endregion Treasure

        ;
    }
}
