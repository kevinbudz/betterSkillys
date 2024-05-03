using TKR.Shared.resources;
using TKR.WorldServer.logic.behaviors;
using TKR.WorldServer.logic.behaviors.@new;
using TKR.WorldServer.logic.behaviors.@new.movements;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.logic.transitions;

namespace TKR.WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Shore = () => Behav()
        .Init("Pirate",
            new State(
                new Shoot(3, coolDown: 2500),
                new OrderedBehavior(
                    new NewFollow(range: 1, speed: 0.85f),
                    new NewWander(0.4f)
                    )
                ),
            new TierLoot(1, ItemType.Weapon, 0.2),
            new ItemLoot("Health Potion", 0.03)
            )
        .Init("Piratess",
            new State(
                new Prioritize(
                    new Follow(1.1, range: 1, duration: 3000, coolDown: 1500),
                    new Wander(0.6)
                    ),
                new Shoot(3, coolDown: 2500),
                new Reproduce("Pirate", densityMax: 5),
                new Reproduce("Piratess", densityMax: 5)
                ),
            new TierLoot(1, ItemType.Armor, 0.2),
            new ItemLoot("Health Potion", 0.03)
            )
        .Init("Snake",
            new State(
                new Wander(0.4),
                new Shoot(10, coolDown: 2000),
                new Reproduce(densityMax: 5)
                ),
            new ItemLoot("Health Potion", 0.03),
            new ItemLoot("Magic Potion", 0.02)
            )
        .Init("Poison Scorpion",
            new State(
                new Prioritize(
                    new Protect(0.4, "Scorpion Queen"),
                    new Wander(0.4)
                    ),
                new Shoot(8, coolDown: 2000)
                )
            )
        .Init("Scorpion Queen",
            new State(
                new ChangeSize(100, 200),
                new Wander(0.2),
                new Spawn("Poison Scorpion", givesNoXp: false),
                new Reproduce("Poison Scorpion", coolDown: 10000, densityMax: 10),
                new Reproduce(densityMax: 2, densityRadius: 40)
                ),
            new ItemLoot("Health Potion", 0.03),
            new ItemLoot("Magic Potion", 0.02)
            )
        .Init("Bandit Enemy",
            new State(
                new State("fast_follow",
                    new Shoot(3),
                    new Prioritize(
                        new Protect(0.6, "Bandit Leader", acquireRange: 9, protectionRange: 7, reprotectRange: 3),
                        new Follow(1, range: 1),
                        new Wander(0.6)
                        ),
                    new TimedTransition(3000, "scatter1")
                    ),
                new State("scatter1",
                    new Prioritize(
                        new Protect(0.6, "Bandit Leader", acquireRange: 9, protectionRange: 7, reprotectRange: 3),
                        new Wander(1),
                        new Wander(0.6)
                        ),
                    new TimedTransition(2000, "slow_follow")
                    ),
                new State("slow_follow",
                    new Shoot(4.5),
                    new Prioritize(
                        new Protect(0.6, "Bandit Leader", acquireRange: 9, protectionRange: 7, reprotectRange: 3),
                        new Follow(0.5, acquireRange: 9, range: 3.5, duration: 4000),
                        new Wander(0.5)
                        ),
                    new TimedTransition(3000, "scatter2")
                    ),
                new State("scatter2",
                    new Prioritize(
                        new Protect(0.6, "Bandit Leader", acquireRange: 9, protectionRange: 7, reprotectRange: 3),
                        new Wander(1),
                        new Wander(0.6)
                        ),
                    new TimedTransition(2000, "fast_follow")
                    ),
                new State("escape",
                    new StayBack(0.5, 8),
                    new TimedTransition(15000, "fast_follow")
                    )
                )
            )
        .Init("Bandit Leader",
            new State(
                new Spawn("Bandit Enemy", coolDown: 8000, maxChildren: 4, givesNoXp: false),
                new State("bold",
                    new State("warn_about_grenades",
                        new Taunt(0.15, "Catch!"),
                        new TimedTransition(400, "wimpy_grenade1")
                        ),
                    new State("wimpy_grenade1",
                        new Grenade(1.4, 12, coolDown: 10000),
                        new Prioritize(
                            new StayAbove(0.3, 7),
                            new Wander(0.3)
                            ),
                        new TimedTransition(2000, "wimpy_grenade2")
                        ),
                    new State("wimpy_grenade2",
                        new Grenade(1.4, 12, coolDown: 10000),
                        new Prioritize(
                            new StayAbove(0.5, 7),
                            new Wander(0.5)
                            ),
                        new TimedTransition(3000, "slow_follow")
                        ),
                    new State("slow_follow",
                        new Shoot(13, coolDown: 1000),
                        new Prioritize(
                            new StayAbove(0.4, 7),
                            new Follow(0.4, acquireRange: 9, range: 3.5, duration: 4000),
                            new Wander(0.4)
                            ),
                        new TimedTransition(4000, "warn_about_grenades")
                        ),
                    new HpLessTransition(0.45, "meek")
                    ),
                new State("meek",
                    new Taunt(0.5, "Forget this... run for it!"),
                    new StayBack(0.5, 6),
                    new Order(10, "Bandit Enemy", "escape"),
                    new TimedTransition(12000, "bold")
                    )
                ),
            new TierLoot(1, ItemType.Weapon, 0.2),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(2, ItemType.Weapon, 0.12),
            new TierLoot(2, ItemType.Armor, 0.12),
            new ItemLoot("Health Potion", 0.12),
            new ItemLoot("Magic Potion", 0.14)
            )
        .Init("Red Gelatinous Cube",
            new State(
                new Shoot(8, count: 2, shootAngle: 10, predictive: 0.2, coolDown: 1000),
                new Wander(0.4),
                new Reproduce(densityMax: 5),
                new DropPortalOnDeath("Pirate Cave Portal", .01)
                ),
            new ItemLoot("Health Potion", 0.04),
            new ItemLoot("Magic Potion", 0.04)
            )
        .Init("Purple Gelatinous Cube",
            new State(
                new Shoot(8, predictive: 0.2, coolDown: 600),
                new Wander(0.4),
                new Reproduce(densityMax: 5),
                new DropPortalOnDeath("Pirate Cave Portal", .01)
                ),
            new ItemLoot("Health Potion", 0.04),
            new ItemLoot("Magic Potion", 0.04)
            )
        .Init("Green Gelatinous Cube",
            new State(
                new Shoot(8, count: 5, shootAngle: 72, predictive: 0.2, coolDown: 1800),
                new Wander(0.4),
                new Reproduce(densityMax: 5),
                new DropPortalOnDeath("Pirate Cave Portal", .01)
                ),
            new ItemLoot("Health Potion", 0.04),
            new ItemLoot("Magic Potion", 0.04)
            );
    }
}
