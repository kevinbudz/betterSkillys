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
        private _ RockDragon = () => Behav()
            .Init("Dragon Head",
                new State(
                    new PlaceMap("setpieces/rock_dragon.jm", true),
                    new Reproduce("Rock Dragon Bat", 5, 5, coolDown: 10000),
                    new DropPortalOnDeath("Lair of Draconis Portal", 1),
                    new State("default",
                        new PlayerWithinTransition(10, "spawnbody")
                        ),
                    new State("spawnbody",
                        new ChangeSize(60, 120),
                        new SetAltTexture(0),
                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                        new Spawn("Body Segment A", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment B", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment C", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment D", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment E", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment F", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment G", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment H", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment I", 1, 1, coolDown: 99999),
                        new Spawn("Body Segment Tail", 1, 1, coolDown: 99999),
                        new TimedTransition(400, "weirdmovement")
                        ),
                    new State("weirdmovement",

                        new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                       new StayAbove(2, 265),
                        new Sequence(
                            new Timed(1000,
                                new ReturnToSpawn(0.6)
                                ),
                            new Timed(5000,
                            new Prioritize(
                                new Swirl(1.25, 8, targeted: false),
                                new Wander(0.2)
                                )
                                ),
                            new Timed(700,
                                new Prioritize(
                                    new Follow(0.9, 11, 1),
                                    new StayCloseToSpawn(0.5, 3)
                                    )
                                )
                            ),
                        new Shoot(4, count: 8, shootAngle: 8, projectileIndex: 1, coolDown: 1250),
                        new EntitiesNotExistsTransition(9999, "vulnerable", "Body Segment A", "Body Segment B", "Body Segment C", "Body Segment D", "Body Segment E", "Body Segment F", "Body Segment G", "Body Segment H", "Body Segment I")
                        ),
                    new State("vulnerable",
                        new ChangeSize(60, 165),
                        new SetAltTexture(1),
                        new RemoveEntity(9999, "Body Segment Tail"),
                        new Sequence(
                            new Timed(1250,
                                new ReturnToSpawn(0.6)
                                ),
                            new Timed(1000,
                                new BackAndForth(0.96, 5)
                                ),
                            new Timed(2700,
                                new Prioritize(
                                    new Follow(1.1, 11, 1),
                                    new StayCloseToSpawn(0.95, 8)
                                    )
                                )
                            ),
                        new Shoot(8, count: 6, projectileIndex: 3, coolDown: 3000),
                        new Shoot(10, 1, projectileIndex: 2, coolDown: 4123),
                        new TimedTransition(11000, "spawnbody")
                        )
                    ),
                new Threshold(0.005,
                    LootTemplates.BasicDrop()
                    ),
                new Threshold(0.005,
                    LootTemplates.BasicPots()
                    ),
                new Threshold(0.01,
                    new ItemLoot("Ray Katana", .01)
                )
            )
                .Init("Body Segment Bomb",
                    new State(
                      new State("BoutToBlow",
                      new TimedTransition(1620, "bom")
                        ),
                    new State("bom",
                       new Shoot(8.4, count: 13, projectileIndex: 0),
                       new Suicide()
                    )))
       .Init("Body Segment A",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment B",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment A", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment A")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )

                 )
            )
         .Init("Body Segment C",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment B", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment B")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment D",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment C", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment C")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment E",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment D", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment D")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment F",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment E", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment E")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment G",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment E", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment F")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment H",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment G", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment G")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
         .Init("Body Segment I",
             new State(
              new TransformOnDeath("Body Segment Bomb", 1, 1, 1),
               new State("go",
                   new Protect(0.97, "Body Segment H", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment H")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
        .Init("Body Segment Tail",
             new State(
              new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
               new State("go",
                   new Protect(0.97, "Body Segment I", protectionRange: 1),
                   new EntitiesNotExistsTransition(9999, "2plan", "Body Segment I")
                        ),
               new State("2plan",
                   new Protect(0.97, "Dragon Head", protectionRange: 1)
                        )
                 )
            )
           .Init("Rock Dragon Bat",
                    new State(
                      new State("BoutToBlow",
                      new Prioritize(
                        new Follow(0.5, 8, 1),
                        new Wander(0.2)
                        ),
                      new Shoot(7, count: 3, shootAngle: 8, projectileIndex: 3, coolDown: 1300),
                      new HpLessTransition(0.11, "bom"),
                      new TimedTransition(5500, "bom")
                        ),
                    new State("bom",
                       new Shoot(8.4, count: 7, projectileIndex: 2),
                       new Suicide()
                    )))
        ;
    }
}