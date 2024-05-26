using Shared;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Hide : Command
        {
            public override RankingType RankRequirement => RankingType.Moderator;
            public override string CommandName => "hide";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var acc = player.Client.Account;

                acc.Hidden = !acc.Hidden;
                acc.FlushAsync();

                if (acc.Hidden)
                {
                    player.IsHidden = true;
                    player.ApplyPermanentConditionEffect(ConditionEffectIndex.Invincible);
                    player.GameServer.ConnectionManager.Clients[player.Client].Hidden = true;
                }
                else
                {
                    player.IsHidden = false;
                    player.RemoveCondition(ConditionEffectIndex.Invincible);
                    player.GameServer.ConnectionManager.Clients[player.Client].Hidden = false;
                }

                return true;
            }
        }
    }
}
