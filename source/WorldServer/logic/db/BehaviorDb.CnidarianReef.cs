using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ CnidarianReef = () => Behav()

            .Init("CR Royal Cnidarian",
                new State(
                    new RealmPortalDrop(),
                    new State("Invunerable",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new TimedTransition(400, "PreIdle1")
                    ),
                    new State("PreIdle1",
                        new SetAltTexture(0),
                        new TimedTransition(400, "PreIdle2")
                    ),
                    new State("PreIdle2",
                        new SetAltTexture(1),
                        new TimedTransition(400, "PreIdle3")
                    ),
                    new State("PreIdle3",
                        new SetAltTexture(2),
                        new TimedTransition(400, "PreIdle4")
                    ),
                    new State("PreIdle4",
                        new SetAltTexture(3),
                        new TimedTransition(400, "PreIdle5")
                    ),
                    new State("PreIdle5",
                        new SetAltTexture(4),
                        new TimedTransition(400, "PreIdle6")
                    ),
                    new State("PreIdle6",
                        new SetAltTexture(0),
                        new TimedTransition(400, "PreIdle7")
                    ),
                    new State("PreIdle7",
                        new SetAltTexture(1),
                        new TimedTransition(400, "PreIdle8")
                    ),
                    new State("PreIdle8",
                        new SetAltTexture(2),
                        new TimedTransition(400, "PreIdle9")
                    ),
                    new State("PreIdle9",
                        new SetAltTexture(3),
                        new TimedTransition(400, "PreIdle10")
                    ),
                    new State("PreIdle10",
                        new SetAltTexture(4),
                        new TimedTransition(400, "Idle1")
                    ),
                    new State("Idle1",
                        new SetAltTexture(0),
                        new TimedTransition(400, "Idle2")
                    ),
                    new State("Idle2",
                        new SetAltTexture(1),
                        new TimedTransition(400, "Idle3")
                    ),
                    new State("Idle3",
                        new SetAltTexture(2),
                        new TimedTransition(400, "Idle4")
                    ),
                    new State("Idle4",
                        new SetAltTexture(3),
                        new TimedTransition(400, "Idle5")
                    ),
                    new State("Idle5",
                        new SetAltTexture(4),
                        new TimedTransition(400, "Idle6")
                    ),
                    new State("Idle6",
                        new SetAltTexture(0),
                        new TimedTransition(400, "Idle7")
                    ),
                    new State("Idle7",
                        new SetAltTexture(1),
                        new TimedTransition(400, "Idle8")
                    ),
                    new State("Idle8",
                        new SetAltTexture(2),
                        new TimedTransition(400, "Idle9")
                    ),
                    new State("Idle9",
                        new SetAltTexture(3),
                        new TimedTransition(400, "Idle10")
                    ),
                    new State("Idle10",
                        new SetAltTexture(4),
                        new TimedTransition(400, "FlashIdle1")
                    ),
                    new State("FlashIdle1",
                        new SetAltTexture(0),
                        new Flash(0xFF4F4F, 0.5, 1),
                        new TimedTransition(500, "FlashIdle2")
                    ),
                    new State("FlashIdle2",
                        new SetAltTexture(1),
                        new Flash(0xFF4F4F, 0.5, 1),
                        new TimedTransition(500, "FlashIdle3")
                    ),
                    new State("FlashIdle3",
                        new SetAltTexture(2),
                        new Flash(0xFF4F4F, 0.5, 1),
                        new TimedTransition(500, "FlashIdle4")
                    ),
                    new State("FlashIdle4",
                        new SetAltTexture(3),
                        new Flash(0xFF4F4F, 0.5, 1),
                        new TimedTransition(500, "FlashIdle5")
                    ),
                    new State("FlashIdle5",
                        new SetAltTexture(4),
                        new Flash(0xFF4F4F, 0.5, 1),
                        new TimedTransition(500, "First Phase")
                    ),
                    new State("First Phase",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(0),
                        new Shoot(radius: 8, projectileIndex: 1, coolDown: 250),
                        new Spawn("CR Gold Cnidarian", maxChildren: 1, initialSpawn: 1),
                        new Spawn("CR Blue Cnidarian", maxChildren: 3, initialSpawn: 1),
                        new Spawn("CR Green Cnidarian", maxChildren: 3, initialSpawn: 1),
                        new Spawn("CR Pink Cnidarian", maxChildren: 3, initialSpawn: 1),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new TimedTransition(500, "First Phase2")
                    ),
                    new State("First Phase2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(1),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new TimedTransition(500, "First Phase3")
                    ),
                    new State("First Phase3",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(2),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new Shoot(radius: 8, projectileIndex: 1, coolDown: 250),
                        new TimedTransition(500, "First Phase4")
                    ),
                    new State("First Phase4",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(3),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new TimedTransition(500, "First Phase5")
                    ),
                    new State("First Phase5",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(4),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new Shoot(radius: 8, projectileIndex: 1, coolDown: 250),
                        new TimedTransition(500, "First Phase6")
                    ),
                    new State("First Phase6",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(0),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Second Phase"),
                        new TimedTransition(500, "First Phase2")
                    ),
                    new State("Second Phase",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 135),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 90),
                        new Shoot(12, projectileIndex: 3, count: 3, shootAngle: 10),
                        new TimedTransition(4100, "First Phase"),
                        new HpLessTransition(0.85, "Third Phase")
                    ),
                    new State("Third Phase",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible, true),
                        new SetAltTexture(0),
                        new Shoot(radius: 8, projectileIndex: 1, coolDown: 250),
                        new EntityNotExistsTransition("CR Gold Cnidarian", 50, "Third Phase Return")
                    ),
                    new State("Third Phase Return",
                        new RemoveConditionalEffect(ConditionEffectIndex.Invincible),
                        new Order(20, "CR Blue Cnidarian", "Return Home"),
                        new Order(20, "CR Green Cnidarian", "Return Home"),
                        new Order(20, "CR Pink Cnidarian", "Return Home"),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 135),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 90),
                        new Shoot(0, projectileIndex: 0, count: 3),
                        new TimedTransition(2000, "Third Phase2")
                    ),
                    new State("Third Phase2",
                        new Order(50, "CR Blue Cnidarian", "Orbit Closer"),
                        new Order(50, "CR Green Cnidarian", "Orbit Closer"),
                        new Order(50, "CR Pink Cnidarian", "Orbit Closer"),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 135),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 90),
                        new Shoot(12, projectileIndex: 0, count: 3),
                        new TimedTransition(2000, "Third Phase3")
                    ),
                    new State("Third Phase3",
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 135),
                        new Shoot(0, count: 4, projectileIndex: 0, fixedAngle: 90),
                        new Shoot(0, projectileIndex: 0, count: 3)
                    ),
                    new State("Die",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Shoot(0, 10, 36, projectileIndex: 1, fixedAngle: 0),
                        new TimedTransition(1, "Suicide")
                    ),
                    new State("Suicide",
                        new Suicide()
                    )
                ),
                new Threshold(0.01,
                    new ItemLoot("Bottled Medusozoan", 0.03),
                    new ItemLoot("Cnidaria Rod", 0.06),
                    new ItemLoot("Large Blue Wave Cloth", 0.5),
                    new ItemLoot("Small Blue Wave Cloth", 0.5),
                    new ItemLoot("Yellow Clothing Dye", 0.5),
                    new ItemLoot("Yellow Accessory Dye", 0.5),
                    new ItemLoot("Potion of Mana", 1),
                    new ItemLoot("Potion of Wisdom", 1),
                    new ItemLoot("Potion of Vitality", 0.08)
                )
            )
            .Init("CR Blue Cnidarian",
                new State(
                    new State("Orbit",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 10, 15, "CR Royal Cnidarian"),
                        new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    ),
                    new State("Return Home",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                        new ReturnToSpawn(speed: 0.5)
                    ),
                    new State("Orbit Closer",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 8, 8, "CR Royal Cnidarian")
                    )
                )
            )
            .Init("CR Green Cnidarian",
                new State(
                    new State("Orbit",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 10, 15, "CR Royal Cnidarian"),
                        new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    ),
                    new State("Return Home",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                        new ReturnToSpawn(speed: 0.5)
                    ),
                    new State("Orbit Closer",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 8, 8, "CR Royal Cnidarian")
                    )
                )
            )
            .Init("CR Pink Cnidarian",
                new State(
                    new State("Orbit",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 10, 15, "CR Royal Cnidarian"),
                        new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    ),
                    new State("Return Home",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, false),
                        new ReturnToSpawn(speed: 0.5)
                    ),
                    new State("Orbit Closer",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 8, 8, "CR Royal Cnidarian")
                    )
                )
            )
            .Init("CR Gold Cnidarian",
                new State(
                    new State("Orbit",
                        new Orbit(1, 10, 15, "CR Royal Cnidarian"),
                        new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    ),
                    new State("Return Home",
                        new ReturnToSpawn(speed: 0.5)
                    ),
                    new State("Orbit Closer",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable, true),
                        new Orbit(1, 8, 8, "CR Royal Cnidarian")
                    )
                )
            );
    }
}