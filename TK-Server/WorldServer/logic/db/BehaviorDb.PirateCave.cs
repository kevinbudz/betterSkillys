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
        private _ PirateCave = () => Behav()
        .Init("Dreadstump the Pirate King",
            new State(
                new RealmPortalDrop(),
                new State("Idle",
                    new PlayerWithinTransition(15, "swiggity")
                    ),
                new State("swiggity",
                    new StayCloseToSpawn(1, 7),
                    new Wander(0.3),
                    new Shoot(radius: 8, count: 1, projectileIndex: 1, coolDown: 2000, predictive: 0.9),
                    new Shoot(radius: 8, count: 1, projectileIndex: 0, coolDown: 1000, predictive: 0.9),
                    new Taunt(0.3, 14000,
                        "Hah! I'll drink my rum out of your skull!",
                        "Eat cannonballs!",
                        "Arrrr..."
                        )
                    )
                ),
            new Threshold(0.03,
                new ItemLoot("Pirate Cave Key", 0.01)
                ),
            new TierLoot(4, ItemType.Weapon, 0.01),
            new TierLoot(3, ItemType.Weapon, 0.05),
            new TierLoot(2, ItemType.Weapon, 0.15),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(2, ItemType.Armor, 0.1),
            new TierLoot(3, ItemType.Armor, 0.05),
            new TierLoot(4, ItemType.Armor, 0.01),
            new TierLoot(1, ItemType.Ring, 0.1),
            new ItemLoot("Pirate Rum", 0.01)
            )
        .Init("Pirate Lieutenant",
            new State(
                new Prioritize(
                    new Protect(0.4, "Dreadstump the Pirate King", protectionRange: 6),
                    new Wander(0.5),
                    new Follow(1, 6, 1, -1, 0)
                    ),
                new Shoot(radius: 7, projectileIndex: 0, predictive: 1, coolDown: 1500)
                ),
            new TierLoot(3, ItemType.Weapon, 0.05),
            new TierLoot(2, ItemType.Weapon, 0.15),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(1, ItemType.Ring, 0.1),
            new ItemLoot("Pirate Rum", 0.01)
            )
        .Init("Pirate Captain",
            new State(
                new Prioritize(
                    new Protect(0.4, "Dreadstump the Pirate King", protectionRange: 6),
                    new Wander(0.5),
                    new Follow(1, 6, 1, -1, 0)
                    ),
                new Shoot(radius: 7, projectileIndex: 0, predictive: 1, coolDown: 1500)
                ),
            new TierLoot(3, ItemType.Weapon, 0.05),
            new TierLoot(2, ItemType.Weapon, 0.15),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(1, ItemType.Ring, 0.1),
            new ItemLoot("Pirate Rum", 0.01) //swiggity
            )
        .Init("Pirate Commander",
            new State(
                new Prioritize(
                    new Protect(0.4, "Dreadstump the Pirate King", protectionRange: 6),
                    new Wander(0.5)
                    ),
                new Shoot(radius: 7, projectileIndex: 0, predictive: 1, coolDown: 1500)
                ),
            new TierLoot(3, ItemType.Weapon, 0.05),
            new TierLoot(2, ItemType.Weapon, 0.15),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(1, ItemType.Ring, 0.1),
            new ItemLoot("Pirate Rum", 0.01) //swooty
            )
        .Init("Cave Pirate Brawler",
            new State(
                new State("that",
                    new Follow(1, 6, 1, -1, 0),
                    new Wander(0.3),
                    new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    )
                ),
            new ItemLoot("Magic Potion", 0.2)
            )
        .Init("Cave Pirate Sailor",
            new State(
                new State("booty",
                    new Wander(0.4),
                    new Follow(0.8, 6, 1, -1, 0),
                    new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    )
                ),
            new ItemLoot("Magic Potion", 0.2)
            )
        .Init("Cave Pirate Cabin Boy",
            new State(
                new Prioritize(
                    new Wander(0.5)
                    )
                ),
            new TierLoot(1, ItemType.Weapon, 0.4)
            )
        .Init("Cave Pirate Macaw",
            new State(
                new Prioritize(
                    new Wander(0.5)
                    )
                ),
            new TierLoot(1, ItemType.Ability, 0.2)
            )
        .Init("Cave Pirate Moll",
            new State(
                new Prioritize(
                    new Wander(0.1)
                    )
                ),
            new TierLoot(1, ItemType.Ability, 0.2)
            )
        .Init("Cave Pirate Monkey",
            new State(
                new Prioritize(
                    new Wander(0.1)
                    )
                ),
            new TierLoot(1, ItemType.Ability, 0.2)
            )
        .Init("Cave Pirate Parrot",
            new State(
                new Prioritize(
                    new Wander(0.1)
                    )
                ),
            new TierLoot(1, ItemType.Ability, 0.2)
            )
        .Init("Cave Pirate Hunchback",
            new State(
                new Prioritize(
                    new Wander(0.5)
                    )
                ),
            new TierLoot(1, ItemType.Ability, 0.2)
            )
        .Init("Cave Pirate Veteran",
            new State(
                new State("woot",
                    new Follow(1, 6, 1, -1, 0),
                    new Wander(0.4),
                    new Shoot(radius: 5, count: 1, projectileIndex: 0, coolDown: 1000)
                    )
                ),
            new ItemLoot("Magic Potion", 0.2)
            )
        .Init("Pirate Admiral",
            new State(
                new Prioritize(
                    new Protect(0.4, "Dreadstump the Pirate King", protectionRange: 6),
                    new Wander(0.5),
                    new Follow(1, 6, 1, -1, 0)
                    ),
                new Shoot(radius: 7, projectileIndex: 0, predictive: 1, coolDown: 1500)
                ),
            new TierLoot(3, ItemType.Weapon, 0.05),
            new TierLoot(2, ItemType.Weapon, 0.15),
            new TierLoot(1, ItemType.Armor, 0.2),
            new TierLoot(2, ItemType.Armor, 0.1),
            new TierLoot(1, ItemType.Ring, 0.1),
            new ItemLoot("Pirate Rum", 0.01) //coming for that booty
            );
    }
}
