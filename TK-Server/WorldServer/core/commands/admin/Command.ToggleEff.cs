using Shared;
using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class ToggleEff : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "eff";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (!Enum.TryParse(args, true, out ConditionEffectIndex effect))
                {
                    player.SendError("Invalid effect!");
                    return false;
                }

                if (!player.HasConditionEffect(effect))
                {
                    player.ApplyPermanentConditionEffect(effect);
                    player.SendInfo($"You have been given '{effect}'!");
                }
                else
                {
                    player.RemoveCondition(effect);
                    player.SendInfo($"Your '{effect}' has been removed!");
                }
                return true;
            }
        }
    }
}
