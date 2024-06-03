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
        private _ IceTomb = () => Behav()
            .Init("Ice Tomb Defender",
                new State(
                    new ScaleHP2(40, 3, 15),
                    new State("idle",
                        new Taunt(true, "THIS WILL NOW BE YOUR TOMB!"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, true),
                        new Prioritize(
                            new Orbit(.3, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                            new Wander(0.3)
                        ),
                        new HpLessTransition(.989, "weakning")
                    ),
                    new State("weakning",
                        new Prioritize(
                            new Orbit(.3, 4, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Taunt(true, "Impudence! I am an Immortal, I needn't waste time on you!"),
                        new Shoot(12, 20, projectileIndex: 3, coolDown: 10000),
                        new Shoot(12, 20, projectileIndex: 3, coolDown: 10000, coolDownOffset: 1000),
                        new HpLessTransition(.979, "active")
                    ),
                    new State("active",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 12000),
                        new Prioritize(
                            new Orbit(.3, 4, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new Shoot(3.8, 8, 45, 2, 0, 0, coolDown: 1200),
                        new Shoot(12, 3, 100, 1, 0, 0, coolDown: 5400, predictive: 0.6),
                        new Shoot(0, 6, 60, 0, 0, 0, coolDown: 5000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new HpLessTransition(.7, "boomerang")
                    ),
                    new State("boomerang",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 10000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Prioritize(
                            new Orbit(.325, 4, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.325)
                        ),
                        new Shoot(0, 6, shootAngle: 60, projectileIndex: 0, coolDown: 8000),
                        new Shoot(12, 1, projectileIndex: 0, coolDown: 3000, predictive: 0.6),
                        new Shoot(3.8, 8, projectileIndex: 2, coolDown: 1200),
                        new Shoot(12, 4, 60, 1, coolDown: 6000, predictive: 0.6),
                        new Shoot(12, 3, 10, 1, coolDown: 6000, predictive: 0.6),
                        new HpLessTransition(.55, "double shot")
                    ),
                    new State("double shot",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 4000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 10000),
                        new Prioritize(
                            new Orbit(.35, 4, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.35)
                        ),
                        new Shoot(3.8, 9, shootAngle: 40, projectileIndex: 2, coolDown: 1000),
                        new Shoot(12, 2, 5, 0, coolDown: 3200, predictive: 0.6),
                        new Shoot(12, 4, 30, 1, coolDown: 6000, predictive: 0.6),
                        new Shoot(12, 2, 10, 1, coolDown: 6000, predictive: 0.6),
                        new HpLessTransition(.4, "artifacts")
                    ),
                    new State("artifacts",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 10000),
                        new Prioritize(
                            new Orbit(.375, 6, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.375)
                        ),
                        new Shoot(3.8, 10, shootAngle: 36, projectileIndex: 2, coolDown: 1000),
                        new Shoot(12, 2, 5, 0, coolDown: 3000, predictive: 0.6),
                        new Shoot(12, 6, 24, 1, coolDown: 6000, predictive: 0.6),
                        new Shoot(12, 3, 10, 1, coolDown: 6000, predictive: 0.6),
                        new Spawn("Shard Artifact 1", 3, 0),
                        new Spawn("Shard Artifact 2", 2, 0),
                        new Spawn("Shard Artifact 3", 1, 0),
                        new HpLessTransition(.25, "artifacts 2")
                    ),
                    new State("artifacts 2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new ConditionEffectBehavior(ConditionEffectIndex.ArmorBroken, duration: 10000),
                        new Taunt(true, "My artifacts shall prove my wall of defense is impenetrable!"),
                        new Prioritize(
                            new Orbit(.4, 6, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(4, 10, shootAngle: 36, projectileIndex: 2, coolDown: 900),
                        new Shoot(12, 3, 15, 0, coolDown: 2800, predictive: 0.6),
                        new Shoot(12, 7, 24, 1, coolDown: 6000, predictive: 0.6),
                        new Shoot(12, 3, 10, 1, coolDown: 6000, predictive: 0.6),
                        new Spawn("Shard Artifact 1", 3, 0),
                        new Spawn("Shard Artifact 2", 2, 0),
                        new Spawn("Shard Artifact 3", 1, 0),
                        new HpLessTransition(.06, "rage")
                    ),
                    new State("rage",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 5400),
                        new Taunt(true, "The end of your path is here!"),
                        new Prioritize(
                            new StayCloseToSpawn(0.8, 7),
                            new Follow(0.5, 10, 2.4)
                        ),
                        new Spawn("Shard Artifact 1", 3, 0),
                        new Spawn("Shard Artifact 2", 2, 0),
                        new Spawn("Shard Artifact 3", 2, 0),
                        new Flash(0xFF0000, 10, 6000),
                        new Shoot(0, 6, 60, 0, coolDown: 8000),
                        new Shoot(20, 1, 60, 0, coolDown: 1400, predictive: 0.6),
                        new Shoot(20, 12, 6, 4, coolDown: 800),
                        new Shoot(20, 7, 24, 1, coolDown: 5500, predictive: 0.6),
                        new Shoot(20, 3, 10, 1, coolDown: 5500, predictive: 0.6),
                        new Shoot(0, 5, 5, 4, 0, 15, coolDown: 400)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("Enchanted Ice Blade", 0.006),
                    new ItemLoot("Freezing Quiver", 0.004)
                )
            )
            .Init("Ice Tomb Support",
                new State(
                    new ScaleHP2(40, 3, 15),
                    new State("idle",
                        new Taunt(true, "ENOUGH OF YOUR VANDALISM!"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(.3, 4.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new HpLessTransition(.989, "weakning")
                    ),
                    new State("weakning",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored, duration: 12000),
                        new Shoot(12, 20, projectileIndex: 7, coolDown: 10000),
                        new Shoot(12, 20, projectileIndex: 7, coolDown: 10000, coolDownOffset: 1000),
                        new Taunt("Impudence! I am an immortal, I needn't take your seriously."),
                        new Prioritize(
                            new Orbit(.3, 4.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new HpLessTransition(.979, "active")
                    ),
                    new State("active",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Prioritize(
                            new Orbit(.4, 4.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(12, 6, projectileIndex: 6, coolDown: 6000, predictive: 0.6),
                        new Shoot(10, 3, 120, 1, 0, coolDown: 6000, coolDownOffset: 4000),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 5000, coolDownOffset: 6000),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 4000, coolDownOffset: 8000),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 8000, coolDownOffset: 10000),
                        new Shoot(12, 1, projectileIndex: 5, coolDown: 800),
                        new HpLessTransition(.9, "boomerang")
                    ),
                    new State("boomerang",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Prioritize(
                            new Orbit(.4, 4.2, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new HealEntity(10, "Ice Tomb Defender", 100, coolDown: 500),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 5000, coolDownOffset: 4200),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 4000, coolDownOffset: 3400),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 8000, coolDownOffset: 2800),
                        new HpLessTransition(.7, "paralyze")
                    ),
                    new State("paralyze",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.45, 4.2, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.45)
                        ),
                        new Shoot(12, 1, projectileIndex: 6, coolDown: 5600, predictive: 0.6),
                        new Shoot(10, 3, 120, 1, 0, coolDown: 5600, coolDownOffset: 2000),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 4700, coolDownOffset: 3000),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 3800, coolDownOffset: 4000),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 7800, coolDownOffset: 5000),
                        new Shoot(12, 1, projectileIndex: 5, coolDown: 800),
                        new HpLessTransition(.5, "artifacts")
                    ),
                    new State("artifacts",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.5, 4.2, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.5)
                        ),
                        new Shoot(12, 1, projectileIndex: 6, coolDown: 5300, predictive: 0.6),
                        new Shoot(10, 3, 120, 1, 0, coolDown: 5300),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 4700),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 3600),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 7200),
                        new Shoot(12, 1, projectileIndex: 5, coolDown: 700),
                        new HealEntity(10, "Ice Tomb Attacker", 40, coolDown: 500),
                        new Spawn("Ice Artifact 1", 3, 0),
                        new Spawn("Ice Artifact 2", 3, 0),
                        new Spawn("Ice Artifact 3", 3, 0),
                        new HpLessTransition(.3, "double shoot")
                    ),
                    new State("double shoot",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.4, 4.2, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(12, 1, projectileIndex: 6, coolDown: 5000, predictive: 0.6),
                        new Shoot(10, 3, 120, 1, 0, coolDown: 5000),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 4800),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 3400),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 6400),
                        new Shoot(12, 1, projectileIndex: 5, coolDown: 600),
                        new Spawn("Ice Artifact 1", 3, 0),
                        new Spawn("Ice Artifact 2", 3, 0),
                        new Spawn("Ice Artifact 3", 3, 0),
                        new HpLessTransition(.06, "rage")
                    ),
                    new State("rage",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Flash(0xFF0000, 10, 6000),
                        new Taunt(true, "This cannot be! You shall not succeed!"),
                        new Prioritize(
                            new StayCloseToSpawn(0.8, 10),
                            new Follow(0.65, 10, 2.4, duration: 30000, coolDown: 6000)
                        ),
                        new Spawn("Ice Artifact 1", 3, 0),
                        new Spawn("Ice Artifact 2", 3, 0),
                        new Spawn("Ice Artifact 3", 3, 0),
                        new Shoot(12, 2, shootAngle: 10, projectileIndex: 6, coolDown: 4000, predictive: 0.6),
                        new Shoot(12, 2, shootAngle: 15, projectileIndex: 0, coolDown: 700, predictive: 0.6),
                        new Shoot(10, 3, 120, 1, 0, coolDown: 5000),
                        new Shoot(10, 4, 90, 2, 0, coolDown: 3600),
                        new Shoot(10, 5, 72, 3, 0, coolDown: 2800),
                        new Shoot(10, 6, 60, 4, 0, coolDown: 6000),
                        new Shoot(12, 1, projectileIndex: 5, coolDown: 600)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("Frozen Wand", 0.006),
                    new ItemLoot("Eternal Snowflake Wand", 0.004)
                )
            )
            .Init("Ice Tomb Attacker",
                new State(
                    new ScaleHP2(40, 3, 15),
                    new State("idle",
                        new Taunt(true, "YOU HAVE AWAKENED US!"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(.3, 5.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new HpLessTransition(.989, "weakning")
                    ),
                    new State("weakning",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Prioritize(
                            new Orbit(.3, 5.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.3)
                        ),
                        new Shoot(12, 20, projectileIndex: 3, coolDown: 10000),
                        new Shoot(12, 20, projectileIndex: 3, coolDown: 10000, coolDownOffset: 1000),
                        new HpLessTransition(.979, "active")
                    ),
                    new State("active",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Prioritize(
                            new Orbit(.4, 5.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(12, 2, 5, 2, coolDown: 600, predictive: 0.6),
                        new Grenade(3, 120, 10, coolDown: 3500),
                        new Grenade(4, 120, 10, coolDown: 6000),
                        new Shoot(0, 6, shootAngle: 60, projectileIndex: 0, coolDown: 5000),
                        new HpLessTransition(.72, "lets dance")
                    ),
                    new State("lets dance",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.4, 5.8, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(12, 2, 40, 0, coolDown: 2000, predictive: 0.6),
                        new Shoot(12, 8, 45, 1, 0, coolDown: 5000),
                        new Shoot(12, 4, 80, 2, coolDown: 1000, predictive: 0.6),
                        new Shoot(12, 1, 40, 0, coolDown: 1400),
                        new Shoot(12, 1, 80, 2, coolDown: 400, predictive: 0.6),
                        new Grenade(3, 100, 10, coolDown: 4000),
                        new Grenade(4, 120, 10, coolDown: 6000),
                        new Spawn("Scarab", 4, 0),
                        new HpLessTransition(.6, "more muthafucka")
                    ),
                    new State("more muthafucka",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.4, 5, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.4)
                        ),
                        new Shoot(12, 2, 40, 0, coolDown: 2000, predictive: 0.6),
                        new Shoot(12, 10, 36, 1, 0, coolDown: 5000),
                        new Shoot(12, 5, 60, 2, coolDown: 1200, predictive: 0.6),
                        new Shoot(12, 1, 40, 0, coolDown: 1200),
                        new Shoot(12, 1, 80, 2, coolDown: 600, predictive: 0.6),
                        new Grenade(3, 100, 10, coolDown: 3750),
                        new Grenade(4, 120, 10, coolDown: 5750),
                        new Spawn("Scarab", 4, 0),
                        new HpLessTransition(.4, "artifacts")
                    ),
                    new State("artifacts",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.5, 5, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.5)
                        ),
                        new Shoot(12, 4, 35, 0, coolDown: 2000, predictive: 0.6),
                        new Shoot(12, 10, 36, 1, 0, coolDown: 15000),
                        new Shoot(12, 5, 60, 2, coolDown: 1200, predictive: 0.6),
                        new Shoot(12, 1, 40, 0, coolDown: 1400),
                        new Shoot(12, 2, 15, 2, coolDown: 600, predictive: 0.6),
                        new Grenade(3, 100, 10, coolDown: 3500),
                        new Grenade(4, 120, 10, coolDown: 5500),
                        new Grenade(6, 40, 10, coolDown: 2000),
                        new Spawn("Scarab", 4, 0),
                        new Spawn("Aqua Artifact 1", 2, 0),
                        new Spawn("Aqua Artifact 2", 2, 0),
                        new Spawn("Aqua Artifact 3", 2, 0),
                        new HpLessTransition(.2, "artifacts 2")
                    ),
                    new State("artifacts 2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 6000),
                        new Prioritize(
                            new Orbit(.55, 5, target: "Ice Tomb Boss Anchor"),
                            new Wander(0.55)
                        ),
                        new Shoot(12, 4, 35, 0, coolDown: 1800, predictive: 0.6),
                        new Shoot(12, 10, 36, 1, 0, coolDown: 14000),
                        new Shoot(12, 5, 60, 2, coolDown: 1200, predictive: 0.6),
                        new Shoot(12, 1, 40, 0, coolDown: 1400),
                        new Shoot(12, 1, 15, 2, coolDown: 600, predictive: 0.6),
                        new Grenade(3, 100, 10, coolDown: 3000),
                        new Grenade(4, 120, 10, coolDown: 5000),
                        new Spawn("Scarab", 4, 0),
                        new Spawn("Aqua Artifact 1", 2, 0),
                        new Spawn("Aqua Artifact 2", 2, 0),
                        new Spawn("Aqua Artifact 3", 2, 0),
                        new HpLessTransition(.06, "rage")
                    ),
                    new State("rage",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, duration: 2000),
                        new Taunt(true, "Argh! You shall pay for your crimes!"),
                        new Flash(0xFF0000, 10, 6000),
                        new Prioritize(
                            new StayCloseToSpawn(2, 7),
                            new StayBack(0.9, 1.8, null)
                        ),
                        new Shoot(12, 2, 35, 0, coolDown: 1000, predictive: 0.6),
                        new Shoot(12, 10, 36, 1, 0, coolDown: 4800),
                        new Shoot(12, 5, 42, 2, coolDown: 1200, predictive: 0.6),
                        new Shoot(12, 2, 5, 0, coolDown: 1400),
                        new Shoot(12, 1, 15, 2, coolDown: 400, predictive: 0.6),
                        new Grenade(3, 120, 12, coolDown: 3500),
                        new Grenade(4, 150, 12, coolDown: 5500),
                        new Spawn("Scarab", 4, 0),
                        new Spawn("Aqua Artifact 1", 2, 0),
                        new Spawn("Aqua Artifact 2", 2, 0),
                        new Spawn("Aqua Artifact 3", 2, 0),
                        new Shoot(0, 1, 0, projectileIndex: 5, 0, 15, coolDown: 400)
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("Arctic Bow", 0.004),
                    new ItemLoot("Staff of IceBlast", 0.006)
                )
            )
            //Minions
            .Init("Shard Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Defender", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(3, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Shard Artifact 2",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Attacker", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(3, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Shard Artifact 3",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Support", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(3, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Ice Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Defender", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, 1, coolDown: 2500)
                    )
            )
            .Init("Ice Artifact 2",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Attacker", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, 1, coolDown: 2500)
                    )
            )
            .Init("Ice Artifact 3",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Support", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, 1, coolDown: 2500)
                    )
            )
            .Init("Aqua Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Defender", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Aqua Artifact 2",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Attacker", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Aqua Artifact 3",
                new State(
                    new Prioritize(
                        new Orbit(1, 2, target: "Ice Tomb Support", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 5000, coolDown: 0)
                        ),
                    new Shoot(12, 3, 120, coolDown: 2500)
                    )
            )
            .Init("Ice Tomb Defender Statue",
                new State(
                    new State(
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new EntityNotExistsTransition("Activator", 1000, "ItsGoTime")
                        ),
                    new State("ItsGoTime",
                        new Transform("Ice Tomb Defender")
                        )
                    ))
            .Init("Ice Tomb Support Statue",
                new State(
                    new State(
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new EntityNotExistsTransition("Activator", 1000, "ItsGoTime")
                        ),
                    new State("ItsGoTime",
                        new Transform("Ice Tomb Support")
                        )
                    ))
            .Init("Ice Tomb Attacker Statue",
                new State(
                    new State(
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new EntityNotExistsTransition("Activator", 1000, "ItsGoTime")
                        ),
                    new State("ItsGoTime",
                        new Transform("Ice Tomb Attacker")
                        )
                    )
            )
            .Init("Ice Tomb Boss Anchor",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                    new TransformOnDeath("Ice Tomb Chest"),
                    new State("Idle",
                        new EntitiesNotExistsTransition(300, "Death", "Ice Tomb Support", "Ice Tomb Attacker", "Ice Tomb Defender", "Ice Tomb Defender Statue", "Ice Tomb Support Statue", "Ice Tomb Attacker Statue")
                    ),
                    new State("Death",
                        new Suicide()
                    )
                )
            )
            .Init("Activator",
                new State(
                    new State("Idle",
                        new Taunt("Welcome Champions. Break me free from this ice prison and I shall reward you!"),
                        new HpLessTransition(0.8, "2")
                    ),
                    new State("2",
                        new SetAltTexture(1),
                        new HpLessTransition(0.6, "3")
                    ),
                    new State("3",
                        new SetAltTexture(2),
                        new HpLessTransition(0.3, "4")
                    ),
                    new State("4",
                        new SetAltTexture(3),
                        new HpLessTransition(0.2, "5")
                    ),
                    new State("5",
                        new SetAltTexture(4),
                        new HpLessTransition(0.1, "6")
                    ),
                    new State("6",
                        new SetAltTexture(5)
                    )
                )
            )
            .Init("Ice Tomb Chest",
                new State(
                    new ScaleHP2(40, 3, 15),
                    new State("Idle",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "UnsetEffect")
                    ),
                    new State("UnsetEffect")
                ),
                new Threshold(0.005,
                    new ItemLoot("Ring of the Northern Light", 0.004),
                    new ItemLoot("Frimarra", 0.004),
                    new ItemLoot("Enchanted Ice Shard", 0.004),
                    new ItemLoot("Ice Crown", 0.001),
                    new ItemLoot("Potion of Life", 1),
                    new ItemLoot("Potion of Life", 0.5),
                    new ItemLoot("Potion of Life", 0.3),
                    new ItemLoot("Ice Tomb Key", 0.01)
                )
            );
    }
}