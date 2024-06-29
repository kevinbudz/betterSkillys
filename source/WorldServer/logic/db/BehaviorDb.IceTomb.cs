using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ IceTomb = () => Behav()
            .Init("Aqua Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 3, 30, "Ice Tomb Support")
                    ),
                    new Shoot(16, count: 1, shootAngle: 12, coolDown: 1500)
                )
            )
            .Init("Aqua Artifact 2",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Defender")
                        ),
                        new Shoot(16, count: 1, shootAngle: 12, coolDown: 1500),
                        new EntityNotExistsTransition("Ice Tomb Defender", 50, "Attacker Exist?")
                    ),
                    new State("Attacker Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Attacker")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Attacker", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("Aqua Artifact 3",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Attacker")
                        ),
                        new Shoot(16, count: 1, shootAngle: 12, coolDown: 1500),
                        new EntityNotExistsTransition("Ice Tomb Attacker", 50, "Defender Exist?")
                    ),
                    new State("Defender Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Defender")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Defender", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("Ice Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 3, 30, "Ice Tomb Defender")
                    ),
                    new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000)
                )
            )
            .Init("Ice Artifact 2",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Support")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Support", 50, "Attacker Exist?")
                    ),
                    new State("Attacker Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Attacker")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Attacker", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("Ice Artifact 3",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Attacker")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Attacker", 50, "Support Exist?")
                    ),
                    new State("Support Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "Ice Tomb Support")
                        ),
                        new Shoot(4, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("Ice Tomb Support", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("Ice Tomb Defender Statue",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("idle",
                        new EntityNotExistsTransition("Activator", 999, "transform")
                    ),
                    new State("transform",
                        new Transform("Ice Tomb Defender")
                    )
                )
            )
            .Init("Activator",
                new State(
                    new State("idle",
                        new HpLessTransition(0.80, "1")
                    ),
                    new State("1",
                        new HpLessTransition(0.60, "2"),
                        new SetAltTexture(1)
                    ),
                    new State("2",
                        new HpLessTransition(0.40, "3"),
                        new SetAltTexture(2)
                    ),
                    new State("3",
                        new HpLessTransition(0.20, "4"),
                        new SetAltTexture(3)
                    ),
                    new State("4",
                        new HpLessTransition(0.10, "5"),
                        new SetAltTexture(4)
                    ),
                    new State("5",
                        new SetAltTexture(5)
                    )
                )
            )
            .Init("Ice Golem",
                new State(
                    new Prioritize(
                        new Follow(2, 7, 1)
                    ),
                    new Shoot(1.4, count: 1, projectileIndex: 0, coolDown: 1950),
                    new Shoot(1.4, count: 5, projectileIndex: 1, coolDown: 1525)
                )
            )
            .Init("Ice Tomb Support Statue",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("idle",
                        new EntityNotExistsTransition("Activator", 999, "transform")
                    ),
                    new State("transform",
                        new Transform("Ice Tomb Support")
                    )
                )
            )
            .Init("Ice Tomb Attacker Statue",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new State("idle",
                        new EntityNotExistsTransition("Activator", 999, "transform")
                    ),
                    new State("transform",
                        new Transform("Ice Tomb Attacker")
                    )
                )
            )
            .Init("Ice Tomb Defender",
                new State(
                    new State("idle",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Orbit(.6, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new HpLessTransition(.99, "weakning")
                    ),
                    new State("weakning",
                        new Orbit(.6, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 24, projectileIndex: 3, coolDown: 6000, coolDownOffset: 2000),
                        new HpLessTransition(.97, "active")
                    ),
                    new State("active",
                        new Orbit(.7, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 8, projectileIndex: 2, coolDown: 1000, coolDownOffset: 500),
                        new Shoot(50, 4, projectileIndex: 1, coolDown: 3000, coolDownOffset: 500),
                        new Shoot(50, 6, projectileIndex: 0, coolDown: 3100, coolDownOffset: 500),
                        new HpLessTransition(.9, "boomerang")
                    ),
                    new State("boomerang",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Orbit(.6, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 8, projectileIndex: 2, coolDown: 1000, coolDownOffset: 500),
                        new Shoot(50, 8, 10, 1, coolDown: 4750, coolDownOffset: 500),
                        new Shoot(50, 1, 10, 0, coolDown: 4750, coolDownOffset: 500),
                        new HpLessTransition(.66, "double shot")
                    ),
                    new State("double shot",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Orbit(.7, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 8, projectileIndex: 2, coolDown: 1000, coolDownOffset: 500),
                        new Shoot(50, 8, 10, 1, coolDown: 4750, coolDownOffset: 500),
                        new Shoot(50, 2, 10, 0, coolDown: 4750, coolDownOffset: 500),
                        new HpLessTransition(.5, "artifacts")
                    ),
                    new State("triple shot",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Orbit(.6, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 8, projectileIndex: 2, coolDown: 1000, coolDownOffset: 500),
                        new Shoot(50, 8, 10, 1, coolDown: 4750, coolDownOffset: 500),
                        new Shoot(50, 3, 10, 0, coolDown: 4750, coolDownOffset: 500),
                        new HpLessTransition(.1, "rage")
                    ),
                    new State("artifacts",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Orbit(.6, 5, target: "Ice Tomb Boss Anchor", radiusVariance: 0.5),
                        new Shoot(50, 8, projectileIndex: 2, coolDown: 1000, coolDownOffset: 500),
                        new Shoot(50, 8, 10, 1, coolDown: 4750, coolDownOffset: 500),
                        new Shoot(50, 2, 10, 0, coolDown: 4750, coolDownOffset: 500),
                        new Spawn("shard Artifact 1", 3, 3, 2000),
                        new Reproduce("shard Artifact 1", 10, 3, 1500),
                        new Spawn("shard Artifact 2", 3, 0, 3500000),
                        new Reproduce("shard Artifact 2", 10, 3, 1500),
                        new Spawn("shard Artifact 3", 3, 0, 3500000),
                        new Reproduce("shard Artifact 3", 10, 3, 1500),
                        new HpLessTransition(.33, "triple shot")
                    ),
                    new State("rage",
                        new Follow(0.6, range: 1, duration: 5000, coolDown: 0),
                        new Flash(0xfFF0000, 1, 9000001),
                        new Shoot(50, 8, 10, 1, coolDown: 4750, coolDownOffset: 500),
                        new Shoot(50, 4, 10, 4, coolDown: 300),
                        new Shoot(50, 3, 10, 0, coolDown: 4750, coolDownOffset: 500)
                    )
                )
            )
            .Init("Ice Tomb Support",
                new State(
                    new State("Idle",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new EntityNotExistsTransition("Ice Tomb Boss Anchor", 50, "IdlePhase1"),
                        new EntityExistsTransition("Ice Tomb Boss Anchor", 50, "IdlePhase2")
                    ),
                    new State("IdlePhase1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new HpLessTransition(0.99, "Phase1")
                    ),
                    new State("IdlePhase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HpLessTransition(0.98, "2Phase1")
                    ),
                    new State("Phase1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Wander(0.3)
                        ),
                        new HealEntity(20, "Ice Tomb Bosses", coolDown: 1500),
                        new HpLessTransition(0.97, "Phase2")
                    ),
                    new State("Phase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Wander(0.3)
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(60, count: 15, fixedAngle: 360 / 15, projectileIndex: 7, coolDown: 10000),
                        new HpLessTransition(0.94, "Phase3")
                    ),
                    new State("Phase3",
                        new Prioritize(
                            new Wander(0.3)
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new HpLessTransition(0.92, "Phase4")
                    ),
                    new State("Phase4",
                        new Prioritize(
                            new Wander(0.3)
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2000),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new HpLessTransition(0.80, "Phase5")
                    ),
                    new State("Phase5",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 2000),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 2500),
                        new HpLessTransition(0.60, "Phase6")
                    ),
                    new State("Phase6",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2600),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2000),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 2400),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 1500),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 1800),
                        new Shoot(40, count: 2, fixedAngle: 140, shootAngle: 9, projectileIndex: 8, coolDown: 1000),
                        new HpLessTransition(0.50, "Phase7")
                    ),
                    new State("Phase7",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Spawn("ice artifact 1", 3, initialSpawn: 1),
                        new Spawn("ice artifact 2", 3, initialSpawn: 1),
                        new Spawn("ice artifact 3", 3, initialSpawn: 1),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2600),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2000),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 2400),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 1500),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 1800),
                        new HpLessTransition(0.30, "Phase8")
                    ),
                    new State("Phase8",
                        new Prioritize(
                            new Wander(0.6)
                        ),
                        new Spawn("ice artifact 1", 3, coolDown: 20000),
                        new Spawn("ice artifact 2", 3, coolDown: 20000),
                        new Spawn("ice artifact 3", 3, coolDown: 20000),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2300),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 1700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 2000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 1300),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 1500),
                        new HpLessTransition(0.10, "Rage")
                    ),
                    new State("Rage",
                        new Flash(0xFF0000, .1, 1000),
                        new Prioritize(
                            new Follow(1, 10, 3)
                        ),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2600),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2000),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 2400),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 1500),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 1800),
                        new Shoot(40, count: 7, fixedAngle: 160, shootAngle: 12, projectileIndex: 8, coolDown: 1500)
                    ),
                    new State("2Phase1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new HpLessTransition(0.97, "2Phase2")
                    ),
                    new State("2Phase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(60, count: 15, fixedAngle: 360 / 15, projectileIndex: 7, coolDown: 10000),
                        new HpLessTransition(0.94, "2Phase3")
                    ),

                    new State("2Phase3",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new HpLessTransition(0.92, "2Phase4")
                    ),
                    new State("2Phase4",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HealGroup(1, "Ice Tomb Bosses", 1500, 1500),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2000),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new HpLessTransition(0.80, "2Phase5")
                    ),
                    new State("2Phase5",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 3000),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 1000),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 2000),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 2500),
                        new HpLessTransition(0.60, "2Phase6")
                    ),
                    new State("2Phase6",
                        new Prioritize(
                            new Orbit(0.4, 5, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2600),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 2000),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 2500),
                        new Shoot(40, count: 4, fixedAngle: 140, shootAngle: 9, projectileIndex: 8, coolDown: 1000),
                        new HpLessTransition(0.50, "2Phase7")
                    ),
                    new State("2Phase7",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("ice artifact 1", 3, initialSpawn: 1),
                        new Spawn("ice artifact 2", 3, initialSpawn: 1),
                        new Spawn("ice artifact 3", 3, initialSpawn: 1),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2600),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 2000),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 2500),
                        new HpLessTransition(0.30, "2Phase8")
                    ),
                    new State("2Phase8",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("ice artifact 1", 3, coolDown: 20000),
                        new Spawn("ice artifact 2", 3, coolDown: 20000),
                        new Spawn("ice artifact 3", 3, coolDown: 20000),
                        new Shoot(16, count: 1, projectileIndex: 6, coolDown: 2300),
                        new Shoot(32, count: 1, projectileIndex: 5, coolDown: 800),
                        new Shoot(16, count: 3, shootAngle: 360 / 3, projectileIndex: 1, coolDown: 2700),
                        new Shoot(16, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 3000),
                        new Shoot(16, count: 6, shootAngle: 360 / 6, projectileIndex: 4, coolDown: 2000),
                        new Shoot(16, count: 5, shootAngle: 360 / 5, projectileIndex: 3, coolDown: 2500),
                        new HpLessTransition(0.10, "Rage")
                    )
                )
            )
            .Init("Ice Tomb Attacker",
                new State(
                    new State("Idle",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new EntityNotExistsTransition("Ice Tomb Boss Anchor", 50, "IdlePhase1"),
                        new EntityExistsTransition("Ice Tomb Boss Anchor", 50, "IdlePhase2")
                    ),
                    new State("IdlePhase1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new HpLessTransition(0.99, "1Phase")
                    ),
                    new State("IdlePhase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new HpLessTransition(0.98, "1Phase2")
                    ),
                    new State("1Phase",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Wander(0.3)
                        ),
                        new Shoot(60, count: 15, fixedAngle: 360 / 15, projectileIndex: 3, coolDown: 10000),
                        new HpLessTransition(0.97, "2Phase")
                    ),
                    new State("2Phase",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 3000),
                        new HpLessTransition(.9, "3Phase")
                    ),
                    new State("3Phase",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.8, "4Phase")
                    ),
                    new State("4Phase",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.7, "5Phase")
                    ),
                    new State("5Phase",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.5, "6Phase")
                    ),
                    new State("6Phase",
                        new Prioritize(
                            new Wander(0.4)
                        ),
                        new Spawn("aqua Artifact 1", 3, initialSpawn: 1),
                        new Spawn("aqua Artifact 2", 3, initialSpawn: 1),
                        new Spawn("aqua Artifact 3", 3, initialSpawn: 1),
                        new Shoot(20, count: 5, shootAngle: 360 / 5, projectileIndex: 2, coolDown: 2000),
                        new Shoot(20, count: 4, shootAngle: 40, projectileIndex: 5, coolDown: 1500),
                        new Shoot(20, count: 3, shootAngle: 10, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 5000),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 1500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2000),
                        new Reproduce("ice golem", 3, 3, coolDown: 10000),
                        new HpLessTransition(0.30, "7Phase")
                    ),
                    new State("7Phase",
                        new Prioritize(
                            new Wander(0.6)
                        ),
                        new Spawn("aqua Artifact 1", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 2", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 3", 3, coolDown: 20000),
                        new Shoot(20, count: 5, shootAngle: 360 / 5, projectileIndex: 2, coolDown: 2000),
                        new Shoot(20, count: 4, shootAngle: 40, projectileIndex: 5, coolDown: 1500),
                        new Shoot(20, count: 3, shootAngle: 10, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 5000),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 1500, predictive: 0.5),
                        new Grenade(3, 50, 10, coolDown: 2000),
                        new Reproduce("ice golem", 3, 3, coolDown: 10000),
                        new HpLessTransition(0.10, "Rage")
                    ),
                    new State("Rage",
                        new Flash(0xFF0000, 1, 1000),
                        new Prioritize(
                            new StayBack(1, 7)
                        ),
                        new Spawn("aqua Artifact 1", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 2", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 3", 3, coolDown: 20000),
                        new Reproduce("ice golem", 3, 3, coolDown: 5000),
                        new Grenade(4, 50, 7, coolDown: 2000),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3000),
                        new Shoot(20, count: 1, fixedAngle: 10, projectileIndex: 5),
                        new Shoot(20, count: 1, fixedAngle: 350, projectileIndex: 5),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5)
                    ),
                    //                                                                                              IfAnchorExist  
                    new State("1Phase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Shoot(60, count: 15, fixedAngle: 360 / 15, projectileIndex: 3, coolDown: 10000),
                        new HpLessTransition(0.97, "2Phase2")
                    ),
                    new State("2Phase2",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 3000),
                        new HpLessTransition(.9, "3Phase2")
                    ),
                    new State("3Phase2",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.8, "4Phase2")
                    ),
                    new State("4Phase2",
                        new Prioritize(
                            new Orbit(0.4, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.7, "5Phase2")
                    ),
                    new State("5Phase2",
                        new Prioritize(
                            new Orbit(0.6, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("ice golem", 3),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 3500),
                        new Shoot(20, count: 4, shootAngle: 360 / 4, projectileIndex: 2, coolDown: 1500),
                        new Shoot(20, count: 2, shootAngle: 12, projectileIndex: 5, coolDown: 1500),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 2300),
                        new Shoot(20, count: 1, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2500),
                        new HpLessTransition(.5, "6Phase2")
                    ),
                    new State("6Phase2",
                        new Prioritize(
                            new Orbit(0.6, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("aqua Artifact 1", 3, initialSpawn: 1),
                        new Spawn("aqua Artifact 2", 3, initialSpawn: 1),
                        new Spawn("aqua Artifact 3", 3, initialSpawn: 1),
                        new Shoot(20, count: 5, shootAngle: 360 / 5, projectileIndex: 2, coolDown: 2000),
                        new Shoot(20, count: 4, shootAngle: 40, projectileIndex: 5, coolDown: 1500),
                        new Shoot(20, count: 3, shootAngle: 10, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 5000),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 1500, predictive: 0.5),
                        new Grenade(3, 50, 7, coolDown: 2000),
                        new Reproduce("ice golem", 3, 3, coolDown: 10000),
                        new HpLessTransition(0.30, "7Phase2")
                    ),
                    new State("7Phase2",
                        new Prioritize(
                            new Orbit(0.6, 3, 20, "Ice Tomb Boss Anchor")
                        ),
                        new Spawn("aqua Artifact 1", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 2", 3, coolDown: 20000),
                        new Spawn("aqua Artifact 3", 3, coolDown: 20000),
                        new Shoot(20, count: 5, shootAngle: 360 / 5, projectileIndex: 2, coolDown: 2000),
                        new Shoot(20, count: 4, shootAngle: 40, projectileIndex: 5, coolDown: 1500),
                        new Shoot(20, count: 3, shootAngle: 10, projectileIndex: 2, coolDown: 500, predictive: 0.5),
                        new Shoot(14.4, count: 8, fixedAngle: 360 / 8, projectileIndex: 1, coolDown: 5000),
                        new Shoot(16, count: 1, projectileIndex: 0, coolDown: 1500, predictive: 0.5),
                        new Grenade(3, 50, 10, coolDown: 2000),
                        new Reproduce("ice golem", 3, 3, coolDown: 10000),
                        new HpLessTransition(0.10, "Rage")
                    )
                )
            )
            .Init("shard Artifact 1",
                new State(
                    new Prioritize(
                        new Orbit(1, 3, 30, "ice tomb Attacker")
                    ),
                    new Shoot(12, count: 1, shootAngle: 12, coolDown: 1500)
                )
            )
            .Init("shard Artifact 2",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "ice tomb Defender")
                        ),
                        new Shoot(12, count: 1, shootAngle: 12, coolDown: 1500),
                        new EntityNotExistsTransition("ice tomb Defender", 50, "Support Exist?")
                    ),
                    new State("Support Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "ice tomb Support")
                        ),
                        new Shoot(12, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("ice tomb Support", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("shard Artifact 3",
                new State(
                    new State("Normal",
                        new Prioritize(
                            new Orbit(1, 3, 30, "ice tomb Support")
                        ),
                        new Shoot(12, count: 1, shootAngle: 12, coolDown: 1500),
                        new EntityNotExistsTransition("ice tomb Support", 50, "Defender Exist?")
                    ),
                    new State("Defender Exist?",
                        new Prioritize(
                            new Orbit(1, 3, 30, "ice tomb Defender")
                        ),
                        new Shoot(12, count: 1, shootAngle: 12, coolDown: 1000),
                        new EntityNotExistsTransition("ice tomb Defender", 50, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                )
            )
            .Init("iceTomb Chest Spawner",
                new State(
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new State("Wait",
                        new EntitiesNotExistsTransition(30, "Wait2", "Activator")
                    ),
                    new State("Wait2",
                        new TimedTransition(5000, "Wait3")
                    ),
                    new State("Wait3",
                        new EntitiesNotExistsTransition(30, "Spawn", "Ice Tomb Support", "Ice Tomb Attacker", "Ice Tomb Defender")
                    ),
                    new State("Spawn",
                        new Transform("iceTomb Chest")
                    )
                )
            )
            .Init("iceTomb Chest",
                new State(
                    new State("Wait",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Open")
                    ),
                    new State("Open",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invulnerable)
                    )
                ),
                new Threshold(.01,
                    new ItemLoot("Ring of the Northern Light", 0.02),
                    new ItemLoot("Enchanted Ice Shard", 0.02),
                    new ItemLoot("Frimarra", 0.02),
                    new ItemLoot("Freezing Quiver", 0.005),
                    new ItemLoot("Potion of Life", .35, 3),
                    new ItemLoot("Ice Crown", .0025)
                )
            );
    }
}