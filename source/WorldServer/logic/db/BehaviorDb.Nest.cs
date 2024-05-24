using Shared.resources;
using WorldServer.logic.behaviors;
using WorldServer.logic.loot;
using WorldServer.logic.transitions;
using WorldServer.logic.behaviors.@new.movements;
namespace WorldServer.logic
{
    partial class BehaviorDb
    {
        private _ Nest = () => Behav()
        .Init("EH Large Yellow Bee",
            new State(
                new State("wait",
                    new ConditionEffectBehavior(ConditionEffectIndex.Invulnerable),
                    new PlayerWithinTransition(10, "charge")
                    ),
                new State("charge",
                    new Charge(3, 10)

                    )
                )
            );
    }
}