using Org.BouncyCastle.Crmf;
using Shared;
using Shared.database.account;
using WorldServer.core.net.stats;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        // dont remove these arent used but need to exist so we can export the stats to client
        private StatTypeValue<int> _rank;
        public RankingType Rank => (RankingType)_rank.GetValue();

        private StatTypeValue<bool> _admin;

        public bool IsAdmin => Rank == RankingType.Admin;
        public bool IsSupporter1 => Rank == RankingType.Supporter1;
        public bool IsSupporter2 => Rank == RankingType.Supporter2;
        public bool IsSupporter3 => Rank == RankingType.Supporter3;
        public bool IsSupporter4 => Rank == RankingType.Supporter4;
        public bool IsSupporter5 => Rank == RankingType.Supporter5;
        public bool IsCommunityManager => Rank == RankingType.CommunityModerator;

        public void InitializeRank(DbAccount account)
        {
            var rank = Client.Rank;

            CalculateRank(rank);

            _rank = new StatTypeValue<int>(this, StatDataType.Rank, (int)rank.Rank);
            _admin = new StatTypeValue<bool>(this, StatDataType.Admin, rank.IsAdmin);
        }

        public void CalculateRank(DbRank rank)
        {
            if (rank.IsAdmin)
                return;

            var newAmountDonated = rank.NewAmountDonated; // add $10
            var amountDonated = rank.TotalAmountDonated;

            var currentRank = rank.Rank;
            while (newAmountDonated > 0)
            {
                amountDonated++;
                newAmountDonated--;

                if (currentRank == RankingType.Regular && amountDonated >= 10 && amountDonated < 20)
                {
                    currentRank = RankingType.Supporter1;
                    GameServer.Database.UpdateCredit(Client.Account, 1000);
                }
                else if (currentRank == RankingType.Supporter1 && amountDonated >= 20 && amountDonated < 30)
                {
                    currentRank = RankingType.Supporter2;
                    GameServer.Database.UpdateCredit(Client.Account, 1000);
                }
                else if (currentRank == RankingType.Supporter2 && amountDonated >= 30 && amountDonated < 40)
                {
                    currentRank = RankingType.Supporter3;
                    GameServer.Database.UpdateCredit(Client.Account, 1000);
                }
                else if (currentRank == RankingType.Supporter3 && amountDonated >= 40 && amountDonated < 50)
                {
                    currentRank = RankingType.Supporter4;
                    GameServer.Database.UpdateCredit(Client.Account, 1000);
                }
                else if (currentRank == RankingType.Supporter4 && amountDonated < 50)
                {
                    currentRank = RankingType.Supporter5;
                    GameServer.Database.UpdateCredit(Client.Account, 1000);
                }
            }

            rank.TotalAmountDonated = amountDonated;
            rank.NewAmountDonated = newAmountDonated;
            rank.Rank = currentRank;
            rank.Flush();
        }
    }
}