using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;

namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Pentaract = () => Behav()
        .Init("Pentaract Eye",
            new State(
                new Prioritize(
                    new Swirl(2, 8, 20, true),
                    new Protect(2, "Pentaract Tower", 20, 6, 4)
                    ),
                new Shoot(9, 1, coolDown: 1000)
                )
            )
        .Init("Pentaract Tower",
            new State(
                new ScaleHP2(20),
                new Spawn("Pentaract Eye", 5, coolDown: 5000, givesNoXp: false),
                new Grenade(4, 100, 8, coolDown: 5000),
                new TransformOnDeath("Pentaract Tower Corpse"),
                new TransferDamageOnDeath("Pentaract"),
                // needed to avoid crash, Oryx.cs needs player name otherwise hangs server (will patch that later)
                new TransferDamageOnDeath("Pentaract Tower Corpse")
                )
            )
        .Init("Pentaract",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Waiting",
                    new EntityNotExistsTransition("Pentaract Tower", 50, "Die")
                    ),
                new State("Die",
                    new Suicide()
                    )
                )
            )
        .Init("Pentaract Tower Corpse",
            new State(
                new ConditionEffectBehavior(ConditionEffectIndex.Invincible),
                new State("Waiting",
                    new TimedTransition(15000, "Spawn"),
                    new EntityNotExistsTransition("Pentaract Tower", 50, "Die")
                    ),
                new State("Spawn",
                    new Transform("Pentaract Tower")
                    ),
                new State("Die",
                    new Suicide()
                    )
                ),
            new Threshold(0.01,
                new ItemLoot("Seal of Blasphemous Prayer", 0.003)
                ),
            new Threshold(.005,
                LootTemplates.BasicDrop()
                ),
            new Threshold(0.001,
                LootTemplates.PentaractPots()
                )
            )
        ;
    }
}
