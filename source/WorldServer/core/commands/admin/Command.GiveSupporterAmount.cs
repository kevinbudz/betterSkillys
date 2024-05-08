using Shared;
using Shared.database.account;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {

        internal class GiveSupporterAmount : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "gds";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var index = args.IndexOf(' ');
                if (string.IsNullOrEmpty(args) || index == -1)
                {
                    player.SendInfo("Usage: /gds <player name> <amount>");
                    return false;
                }

                var name = args.Substring(0, index);
                var amount = int.Parse(args.Substring(index + 1));
                if(amount <= 0)
                {
                    player.SendInfo("Usage: /gds <player name> <amount>");
                    return false;
                }

                var id = player.GameServer.Database.ResolveId(name);
                if (id == player.AccountId)
                {
                    player.SendError($"Cannot give ${amount} to self");
                    return false;
                }

                var acc = player.GameServer.Database.GetAccount(id);
                if (id == 0 || acc == null)
                {
                    player.SendError("Account not found!");
                    return false;
                }

                var rank = new DbRank(acc.Database, id);
                rank.NewAmountDonated += amount;
                rank.Flush();

                player.SendInfo($"{acc.Name} has been given ${amount} towards his supporter rank");
                return false;
            }
        }

    }
}
