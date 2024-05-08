#region

using WorldServer.logic.behaviors;
using WorldServer.logic.transitions;

#endregion

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ ForbiddenJungle = () => Behav()
        .Init("Great Coil Snake",
            new State(
                new DropPortalOnDeath("Forbidden Jungle Portal", 65),
                new Prioritize(
                    new StayCloseToSpawn(1, 5),
                    new Wander(1)
                    ),
                new State("Waiting",
                    new PlayerWithinTransition(15, "Attacking")
                    ),
                new State("Attacking",
                    new Shoot(10, projectileIndex: 0, coolDown: 700, coolDownOffset: 600),
                    new Shoot(10, 10, 36, 1, coolDown: 2000),
                    new TossObject("Great Snake Egg", 4, 0, 5000, coolDownOffset: 0),
                    new TossObject("Great Snake Egg", 4, 90, 5000, 600),
                    new TossObject("Great Snake Egg", 4, 180, 5000, 1200),
                    new TossObject("Great Snake Egg", 4, 270, 5000, 1800),
                    new NoPlayerWithinTransition(30, "Waiting")
                    )
                )
            )
        .Init("Great Snake Egg",
            new State(
                new TransformOnDeath("Great Temple Snake", 1, 2),
                new State("Wait",
                    new TimedTransition(2500, "Explode"),
                    new PlayerWithinTransition(2, "Explode")
                    ),
                new State("Explode",
                    new Suicide()
                    )
                )
            )
        .Init("Great Temple Snake",
            new State(
                new Prioritize(
                    new Follow(1.5),
                    new Wander(1)
                    ),
                new Shoot(10, 2, 7, 0, coolDown: 1000, coolDownOffset: 0),
                new Shoot(10, 6, 60, 1, coolDown: 2000, coolDownOffset: 600)
                )
            )
        ;
    }
}
