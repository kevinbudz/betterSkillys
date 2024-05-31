using Shared;
using Shared.database;
using System.Collections.Generic;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing.market;
using Shared.database.market;
using Shared.database.vault;
using WorldServer.core.worlds;
using WorldServer.core.net.datas;

namespace WorldServer.core.net.handlers.market
{
    public class MarketRemoveHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.MARKET_REMOVE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var id = rdr.ReadInt32();

            if (!IsAvailable(client) || !IsEnabledOrAdminOnly(client))
                return;

            var data = DbMarketData.GetSpecificOffer(client.Account.Database, id);
            client?.Account?.Reload("marketOffers");
            if (!HandleData(data, client) || !HandleInvalidPurchase(client, data.SellerId, client.Account.AccountId))
                return;

            var db = client.GameServer.Database;
            var task = db.RemoveMarketEntrySafety(client.Account, data.Id);

            if (task.IsCanceled)
            {
                client.Player.SendError("D'oh! Something went wrong, try again later...");
                return;
            }

            if (string.IsNullOrEmpty(data.ItemData))
            {
                if (!db.AddGift(client.Account, data.ItemType))
                {
                    client.Player.SendError("D'oh! Something went wrong, try again later...");
                    var list = new List<(ushort, string)> { (data.ItemType, data.ItemData) };
                    db.AddMarketEntrySafety(client.Account, list, data.SellerId, data.SellerName, data.Price, data.TimeLeft, data.Currency);
                    return;
                }
            }
            else if (!string.IsNullOrEmpty(data.ItemData))
            {
                if (!DbSpecialVault.AddItem(client.Account, data.ItemType, data.ItemData))
                {
                    client.Player.SendError("Something wrong happened while trying to add Item with Data, try again later.");
                    var list = new List<(ushort, string)> { (data.ItemType, data.ItemData) };
                    db.AddMarketEntrySafety(client.Account, list, data.SellerId, data.SellerName, data.Price, data.TimeLeft, data.Currency);
                    return;
                }
            }


            MarketData[] offers = new MarketData[client.Account.MarketOffers.Length];
            var playerOffers = client.Account.MarketOffers;

            for (var i = 0; i < playerOffers.Length; i++)
            {
                var dbData = DbMarketData.GetSpecificOffer(client.Account.Database, playerOffers[i]);
                if (dbData == null)
                    continue;

                var mData = new MarketData
                {
                    Id = dbData.Id,
                    ItemType = dbData.ItemType,
                    SellerId = dbData.SellerId,
                    SellerName = dbData.SellerName,
                    Currency = (int)dbData.Currency,
                    Price = dbData.Price,
                    StartTime = dbData.StartTime,
                    TimeLeft = dbData.TimeLeft,
                    ItemData = dbData.ItemData
                };

                offers[i] = mData;
            }

            client.SendPacket(new MarketMyOffersResult { Results = offers });
        }

        private bool HandleData(object data, Client client)
        {
            if (data == null)
            {
                client.SendPacket(new MarketRemoveResult
                {
                    Code = MarketRemoveResult.ITEM_DOESNT_EXIST,
                    Description = "D'oh! Something is wrong, this item was removed already."
                });
                return false;
            }

            return true;
        }

        private bool HandleInvalidPurchase(Client client, int selledId, int accountId)
        {
            if (selledId != accountId)
            {
                client.SendPacket(new MarketRemoveResult
                {
                    Code = MarketRemoveResult.NOT_YOUR_ITEM,
                    Description = "D'oh! Somethins is wrong, you cannot remove items whose don't belongs to you."
                });
                return false;
            }

            return true;
        }
    }
}