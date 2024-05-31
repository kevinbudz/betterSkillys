using Shared;
using Shared.database.account;
using Shared.database.market;
using Shared.database.vault;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing.market;
using WorldServer.utils;

namespace WorldServer.core.net.handlers.market
{
    public class MarketBuyHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.MARKET_BUY;

        private const int TAX_PERCENTAGE = 5;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var id = rdr.ReadInt32();

            if (!IsAvailable(client) || !IsEnabledOrAdminOnly(client))
                return;

            var player = client.Player;

            var marketData = DbMarketData.GetSpecificOffer(client?.Account?.Database, id);
            if (marketData == null)
            {
                client.SendPacket(new MarketBuyResult()
                {
                    Code = MarketBuyResult.ERROR,
                    Description = "Something wrong happened, try again. (Item doesn't exist in Market)"
                });
                player.SendError("That item doesn't exist.");
                return;
            }

            if (!player.GameServer.Resources.GameData.Items.TryGetValue(marketData.ItemType, out var item))
            {
                client.SendPacket(new MarketBuyResult()
                {
                    Code = MarketBuyResult.ERROR,
                    Description = "Something wrong happened, try again. (Item not registered in Server)"
                });
                client.Player?.SendError("Something wrong happened, try again. (Item not registered in Server)");
                return;
            }

            if (player.CurrentFame < marketData.Price)
            {
                client.SendPacket(new MarketBuyResult()
                {
                    Code = MarketBuyResult.ERROR,
                    Description = "Your fame is not enough to buy this item!"
                });
                client.Player?.SendError("Not enough Fame.");
                return;
            }

            var db = player.GameServer.Database;
            var sellerId = db.ResolveId(marketData.SellerName);
            var sellerAcc = db.GetAccount(sellerId);
            if (sellerAcc == null)
            {
                player.SendError("Unable to find seller.");
                return;
            }

            if (sellerId == 0 || sellerAcc == null)
            {
                client.SendPacket(new MarketBuyResult()
                {
                    Code = MarketBuyResult.ERROR,
                    Description = "Something wrong happened, try again. (Seller Account not exist)"
                });
                player.SendError("Something wrong happened, try again. (Seller Account not exist)");
                return;
            }

            StaticLogger.Instance.Warn($"<{player.Name} {player.AccountId}> brought: {item.ObjectId} on market for: {marketData.Price} from: <{sellerAcc.Name} {sellerAcc.AccountId}>");

            /* Add fame to the Seller */
            AddFameToSeller(client, sellerAcc, marketData.Price, item.ObjectId);

            /* Remove fame to Buyer */
            RemoveFameToBuyer(player, marketData.Price);

            db.RemoveMarketEntrySafety(sellerAcc, marketData.Id);

            if (!string.IsNullOrEmpty(marketData.ItemData))
                DbSpecialVault.AddItem(client.Account, marketData.ItemType, marketData.ItemData);
            else
                db.AddGift(client.Account, marketData.ItemType);

            client.SendPacket(new MarketBuyResult()
            {
                Code = -1,
                Description = $"You have successfully bought: {item.ObjectId}",
                OfferId = marketData.Id
            });
        }

        private void AddFameToSeller(Client client, DbAccount acc, int realPrice, string itemId)
        {
            var tax = GetTax(realPrice);
            var resultPrice = realPrice - tax;

            acc.Reload("fame");
            acc.Reload("totalFame");
            acc.Fame += resultPrice;
            acc.TotalFame += resultPrice;
            acc.FlushAsync();
            acc.Reload("fame");
            acc.Reload("totalFame");

            client.Player.GameServer.ChatManager.SendInfoMarket(acc.AccountId, itemId, realPrice, resultPrice, TAX_PERCENTAGE);
        }

        private void RemoveFameToBuyer(Player player, int price)
        {
            player.CurrentFame = player.Client.Account.Fame -= price;
            player.Client.Account.TotalFame += price;
            player.GameServer.Database.ReloadAccount(player.Client.Account);
            player.SendInfo("<Marketplace> The purchase item has been sent to your gift chests at Vault.");
        }

        internal class APIItem //if u want, you can remove this and make it different?
        {
            public string secret = "NEW_SECRET_KEY_HERE_TODO_SOMEONE_DONT_LET_THEM_KNOW_YOUR_NEXT_MOVE_OK2";
            public int itemID;
            public int value;
        }

        private int GetTax(int price) => TAX_PERCENTAGE * price / 100;
    }
}
