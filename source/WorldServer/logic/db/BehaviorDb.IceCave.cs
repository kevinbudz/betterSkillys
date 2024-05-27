using Shared.resources;
using WorldServer.logic.loot;
using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ IceCave = () => Behav()
             .Init("Big Yeti",
             new State(
                   new State("geticey",
                       new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new PlayerWithinTransition(8, "leggo")
                        ),
                  new State("leggo",
                     new Follow(0.3, 8, 1),
                     new ConditionEffectBehavior(ConditionEffectIndex.Armored),
                       new Taunt(0.50, "MRRRRRRTTTTTT!"),
                        new Taunt(0.25, "Mwruuuu!"),
                       new Flash(0xFF0000, 2, 18),
                       new Spawn("Mini Yeti", 1, 4, coolDown: 10000)
                        )

                  )
            )
            .Init("Mini Yeti",
                new State(
                    new Flash(0xFF0000, 2, 6),
                     new Orbit(0.3, 3, 20, "Big Yeti", speedVariance: 0.1),
                     new Shoot(8.4, count: 1, projectileIndex: 0, predictive: 1, coolDown: 1750),
                     new Shoot(8.4, count: 1, projectileIndex: 0, coolDown: 1200)
                    )
            )
                     .Init("Snow Bat Mama",
             new State(
                   new State("geticey",
                       new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new PlayerWithinTransition(8, "leggo")
                        ),
                  new State("leggo",
                     new Follow(0.4, 8, 1),
                      new Shoot(8.4, count: 1, projectileIndex: 0, predictive: 1, coolDown: 2750),
                     new Shoot(8.4, count: 1, projectileIndex: 1, coolDown: 2300),
                      new Shoot(8.4, count: 1, projectileIndex: 2, coolDown: 1000),
                      new Shoot(8.4, count: 1, projectileIndex: 3, coolDown: 1250),
                       new Spawn("Snow Bat", 1, 4, coolDown: 10000)
                        ))
            )
            .Init("Snow Bat",
                new State(
                     new Wander(0.4),
                     new Shoot(8.4, count: 6, projectileIndex: 0, coolDown: 25)
                    )
            )
                    .Init("ic shielded king",
                new State(
                     new Taunt(0.40, "GRUUUUUUUUUUUUUU!"),
                      new Taunt(0.25, "Ssssshrrrrrrrrrrr!"),
                       new Taunt(0.10, "BRRRRRR!"),
                     new Follow(0.55, 8, 1),
                     new Shoot(8.4, count: 1, projectileIndex: 0, coolDown: 1100)
                    )
            )
                            .Init("ic CreepyTime",
                new State(
                     new Follow(0.4, 8, 1)
                    )
            )
                            .Init("ic Whirlwind",
                new State(
                     new Follow(0.32, 8, 1),
                     new Shoot(8.4, count: 7, projectileIndex: 1, coolDown: 2500)
                    )
            )
                                    .Init("ic boss purifier",
                new State(
                    new TransformOnDeath("ic boss purifier generator", 1, 1, 1),
                    new Spawn("ic Whirlwind", 1, 1, coolDown: 3500),
                     new Shoot(8.4, count: 1, predictive: 1, projectileIndex: 0, coolDown: 2000)
                    )
            )
             .Init("ic boss purifier generator",
               new State(
                     new State("StagesStart",
                         new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                          new EntitiesNotExistsTransition(9999, "leggo", "ic boss manager"),
                         new EntitiesNotExistsTransition(9999, "TheKingIsDead", "ic Esben the Unwilling")
                          ),
                    new State("leggo",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                         new Spawn("ic shielded king", 1, 1, coolDown: 10000),
                         new EntityExistsTransition("ic boss manager", 9999, "StagesBegin"),
                        new EntitiesNotExistsTransition(9999, "TheKingIsDead", "ic Esben the Unwilling")
                          ),
                     new State("StagesBegin",
                         new TransformOnDeath("ic boss purifier", 1, 1, 1),
                         new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                          new EntitiesNotExistsTransition(9999, "leggo", "ic boss manager"),
                           new EntitiesNotExistsTransition(9999, "TheKingIsDead", "ic Esben the Unwilling"),
                           new Suicide()
                          ),
                       new State("TheKingIsDead",
                         new TransformOnDeath("ic CreepyTime", 1, 1, 1),
                         new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                           new Suicide()
                          )
                   )
              )

           .Init("InnerSanctum Task Master",
                        new State(
                    new State("Spook",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                    new EntitiesNotExistsTransition(9999, "Commence", "Snow Bat Mama")
                        ),
                    new State("Commence",
                       new DropPortalOnDeath("Inner Sanctum Portal", 100, timeout: 99999),
                       new Taunt(true, "Innocent souls. So delicious. You have sated me. Now come, I shall give you your reward."),
                       new Suicide()
                    )))

        //ESBEN LETS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!
             .Init("ic Esben the Unwilling",
                new State(
                    new RealmPortalDrop(),
                    new TransformOnDeath("ic Loot Balloon", 1, 1, 1),
                    new State("Esben1",
                        new Taunt(0.40, "Your souls will soon nourish me."),
                        new Taunt(0.35, "Icicles, rend their flesh."),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Shoot(10, 8, 7, projectileIndex: 3, coolDown: 1350),
                        new Shoot(10, 6, 7, projectileIndex: 3, coolDown: 4250),
                        new Shoot(10, 4, 7, projectileIndex: 3, coolDown: 3250),
                        new Shoot(10, 2, 7, projectileIndex: 3, predictive: 2, coolDown: 2250),
                        new EntitiesNotExistsTransition(9999, "spooked", "ic boss purifier"),
                        new Spawn("ic boss manager", initialSpawn: 1, maxChildren: 1, coolDown: 10000),
                        new TimedTransition(8750, "Esben2")
                        ),
                    new State("Esben2",
                        new Taunt(0.50, "Ice is cold, blood is think, you being alive makes me sick!"),
                        new Taunt(0.35, "The ice I throw is of my construction, but when it hits you it means destruction!"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Shoot(8.4, count: 69, shootAngle: 6, projectileIndex: 0, coolDown: 3250),
                        new Shoot(8.4, count: 2, fixedAngle: 0, projectileIndex: 2, coolDown: 1000),
                        new Shoot(8.4, count: 2, fixedAngle: 90, projectileIndex: 2, coolDown: 1000),
                        new Shoot(8.4, count: 2, fixedAngle: 180, projectileIndex: 2, coolDown: 1000),
                        new Shoot(8.4, count: 2, fixedAngle: 270, projectileIndex: 2, coolDown: 1000),
                        new Shoot(8.4, count: 1, fixedAngle: 40, projectileIndex: 2, coolDown: 1000),
                        new Shoot(8.4, count: 1, fixedAngle: 135, projectileIndex: 2, coolDown: 1200),
                        new Shoot(8.4, count: 1, fixedAngle: 225, projectileIndex: 2, coolDown: 1200),
                        new Shoot(8.4, count: 1, fixedAngle: 315, projectileIndex: 2, coolDown: 1200),
                          new EntitiesNotExistsTransition(9999, "spooked", "ic boss purifier"),
                        new TimedTransition(8750, "Esben3")
                        ),
                    new State("Esben3",
                        new Taunt(0.60, "I will cut you to shreds."),
                         new Taunt(0.30, "Bad puns I may use to cause offense, but the pain you feel shall be immense!"),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Shoot(18, 2, 7, projectileIndex: 1, coolDown: 700),
                        new Shoot(10, 6, 7, projectileIndex: 1, predictive: 2, coolDown: 800),
                        new Shoot(18, 1, 7, projectileIndex: 1, coolDown: 14),
                          new EntitiesNotExistsTransition(9999, "spooked", "ic boss purifier"),
                        new TimedTransition(8750, "Esben1")
                        ),
                    new State("spooked",
                        new Wander(0.1),
                        new SetAltTexture(1),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new Shoot(8.4, count: 16, shootAngle: 60, projectileIndex: 1, coolDown: 1000),
                        new Taunt(1.00, "H..help me...."),
                        new RemoveEntity(9999, "ic boss manager"),
                        new TimedTransition(6200, "spookedwaitforkill")
                        ),
                    new State("spookedwaitforkill",
                        new Wander(0.1),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                        new EntitiesNotExistsTransition(9999, "spooked1", "ic shielded king")
                        ),
                    new State("spooked1",
                            new Wander(0.1),
                        new SetAltTexture(2),
                        new Taunt(1.00, "Help..help me....PLEASE!"),
                        new TimedTransition(6570, "transformationstart")
                        ),
                    new State("transformationstart",
                         new Prioritize(
                            new StayCloseToSpawn(0.5, 10),
                            new Wander(1)
                        ),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new Taunt(1.00, "NO, NO I DON'T WANNA GO BACK TooOooo..AAHHH!!!!"),
                         new Taunt(0.30, "LET ME GOOOOOOO!"),
                         new SetAltTexture(4),
                        new TimedTransition(250, "transformation1")
                        ),
                      new State("transformation1",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(2),
                        new TimedTransition(10, "transformation2")
                        ),
                    new State("transformation2",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(4),
                        new TimedTransition(1, "transformation3")
                        ),
                   new State("transformation3",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(2),
                        new TimedTransition(1, "transformation4")
                        ),
                  new State("transformation4",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(4),
                        new TimedTransition(1, "transformation5")
                        ),
                         new State("transformation5",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(2),
                        new TimedTransition(1, "transformation6")
                        ),
                      new State("transformation6",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(4),
                        new TimedTransition(1, "transformation7")
                        ),
                        new State("transformation7",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(2),
                        new TimedTransition(1, "transformation8")
                        ),
                       new State("transformation8",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(4),
                        new TimedTransition(1, "transformation9")
                        ),
                        new State("transformation9",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(2),
                        new TimedTransition(1, "transformation10")
                        ),
                         new State("transformation10",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                         new SetAltTexture(0),
                         new Spawn("ic boss manager", initialSpawn: 1, maxChildren: 1, coolDown: 10000),
                        new TimedTransition(10, "Esben1")

                        )

                    )
            )
                    .Init("ic Loot Balloon",
                new State(
                    new State("Idle",
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "UnsetEffect")
                    ),
                    new State("UnsetEffect")
                ),
                new Threshold(0.005,
                    LootTemplates.StrongerDrop()
                    ),
                new Threshold(0.15,
                    new ItemLoot("Potion of Mana", 1),
                    new ItemLoot("Potion of Mana", 0.5),
                    new ItemLoot("Staff of Esben", 0.004),
                    new ItemLoot("Skullish Remains of Esben", 0.004)
                    )
                );
    }
}