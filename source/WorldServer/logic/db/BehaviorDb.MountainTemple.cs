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
        private _ MountainTemple = () => Behav() // by runes :)
        .Init("Corrupted Armor",
            new State(
                new Shoot(10, 1, 0, coolDown: 400),
                new Shoot(10, 8, 45, 1, coolDown: 400)
                )
            )
        .Init("Corrupted Monk",
            new State(
                new Wander(0.8),
                new PlayerWithinTransition(8, "init"),
                    new State("init",
                        new Follow(0.6, 10, 2),
                        new Shoot(10, 5, 10, 0, coolDown: 1600)
                    )
                )
            )
        .Init("Corrupted Spawn",
            new State(
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, 0, 0, coolDown: 1000),
                new Shoot(10, 2, 20, 0, coolDown: 1000, coolDownOffset: 333),
                new Shoot(10, 8, 45, 0, coolDown: 2000, coolDownOffset: 666)
                )
            )
        .Init("Corrupted Spearman",
            new State(
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, 0, coolDown: 1000),
                new Shoot(10, 10, 36, 1, coolDown: 1000)
                )
            )
        .Init("Corrupted Caster",
            new State(
                new Follow(0.8, 10, 2),
                new Shoot(10, 1, 20, 0, coolDown: 1500),
                new Shoot(10, 8, 45, 1, coolDown: 1500)
                )
            )
        .Init("Corrupted Bowman",
            new State(
                new Wander(0.8),
                new PlayerWithinTransition(8, "charge"),
                    new State("charge",
                        new Follow(0.6, 10, 2),
                        new Shoot(10, 1, 0, 1, coolDown: 2000),
                        new Shoot(10, 2, 15, 0, coolDown: 2000, coolDownOffset: 600),
                        new Shoot(10, 2, 15, 0, coolDown: 2000, coolDownOffset: 1200),
                        new TimedTransition(4000, "idle")
                    ),
                    new State("idle",
                        new Wander(0.8),
                        new TimedTransition(750, "charge")
                    )
                )
            );
    }
}