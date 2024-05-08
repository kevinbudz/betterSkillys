using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb             //might not be EXACT, but close enough anyway, made by hydranoid800
    {
        private _ ForestMaze = () => Behav()
        .Init("Mama Megamoth",
            new State(
                new State("swaggin around",
                    new Charge(3, 10, 2000),
                    new Wander(1),
                    new Spawn("Mini Megamoth", coolDown: 2000, initialSpawn: 1),
                    new Reproduce("Mini Megamoth", coolDown: 4000, densityMax: 4),
                    new Shoot(radius: 10, count: 1, projectileIndex: 0, coolDown: 50)
                    )
                ),
            new Threshold(0.03,
                new ItemLoot("Forest Maze Key", 0.01)
                )
            )
        .Init("Mini Megamoth",
            new State(
                new State("protect the queen",
                    new EntityExistsTransition("Mama Megamoth", 100, "protecto the queen"),
                    new EntityNotExistsTransition("Mama Megamoth", 100, "oh crap there is no queen")
                    ),
                new State("protecto the queen",
                    new Protect(1, "Mama Megamoth", 100, 3, 1),
                    new Wander(1),
                    new TimedTransition(5000, "swaggin shot time 1")
                    ),
                new State("swaggin shot time 1",
                    new Shoot(radius: 8, count: 1, coolDown: 100),
                    new TimedTransition(3000, "protecto the queen")
                    ),
                new State("oh crap there is no queen",
                    new Wander(1),
                    new Shoot(radius: 10, count: 1, projectileIndex: 0, predictive: 1, coolDown: 1000),
                    new TimedTransition(5000, "swaggin shots tiem")
                    ),
                new State("swaggin shots tiem",
                    new Shoot(radius: 8, count: 1, coolDown: 100),
                    new TimedTransition(3000, "oh crap there is no queen")
                    )
                )
            )
        .Init("Armored Squirrel",
            new State(
                new Prioritize(
                    new Follow(2, 6, 1, -1, 0),
                    new Wander(1),
                    new Shoot(radius: 7, count: 2, projectileIndex: 0, predictive: 1, coolDown: 1000, shootAngle: 15)
                    )
                )
            )
        .Init("Ultimate Squirrel",
            new State(
                new Prioritize(
                    new Follow(2, 6, 1, -1, 0),
                    new Wander(1)
                    ),
                new Shoot(radius: 7, count: 3, projectileIndex: 0, shootAngle: 20, coolDown: 2000)
                )
            )
        .Init("Forest Goblin",
            new State(
                new Prioritize(
                    new Wander(2),
                    new Follow(1, 10, 3, -1, 0),
                    new Shoot(radius: 4, count: 1, projectileIndex: 0, coolDown: 500)
                    )
                )
            )
        .Init("Forest Goblin Mage",
            new State(
                new Prioritize(
                    new Wander(1),
                    new Shoot(radius: 10, count: 2, projectileIndex: 0, predictive: 1, coolDown: 500, shootAngle: 2)
                    )
                )
            );
    }
}
