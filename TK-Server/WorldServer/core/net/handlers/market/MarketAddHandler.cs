using Shared;
using Shared.database;
using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing.market;
using WorldServer.core.objects;
using Shared.database.character.inventory;
using WorldServer.utils;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers.market
{
    public class MarketAddHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.MARKET_ADD;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var slots = new byte[rdr.ReadByte()];
            for (var i = 0; i < slots.Length; i++)
                slots[i] = rdr.ReadByte();
            var price = rdr.ReadInt32();
            var currency = rdr.ReadInt32();
            var hours = rdr.ReadInt32();

            if (!IsAvailable(client) || !IsEnabledOrIsVipMarket(client))
                return;

            var player = client.Player;

            if (!HandleInvalidUptime(client, hours) || !HandleInvalidPrice(client, price) || !HandleInvalidCurrency(client, currency))
                return;

            var amountOfItems = -1;
            var transaction = client.Player.Inventory.CreateTransaction();
            var dataTrans = client.Player.Inventory.CreateDataTransaction();
            var pendingItems = new List<(byte slotId, Item item, ItemData data)>();

            for (var i = 0; i < slots.Length; i++)
            {
                var slotId = slots[i];
                var item = transaction[slotId];
                var data = dataTrans[slotId];

                if (item == null)
                {
                    client.SendPacket(new MarketAddResult
                    {
                        Code = MarketAddResult.SLOT_IS_NULL,
                        Description = $"There is no item on slot {slotId + 1}."
                    });
                    return;
                }

                if (item.Soulbound)
                {
                    client.SendPacket(new MarketAddResult
                    {
                        Code = MarketAddResult.ITEM_IS_SOULBOUND,
                        Description = "You cannot sell soulbound items."
                    });
                    return;
                }

                pendingItems.Add((slotId, item, data));
            }

            if (pendingItems.Count == 0)
            {
                client.Player.SendError("There is no item to perform this action, try again later.");
                return;
            }

            if (!transaction.Validate() || !dataTrans.Validate())
            {
                client.Player.SendError("Your inventory was recently updated, try again later.");
                return;
            }

            for (var j = 0; j < pendingItems.Count; j++)
            {
                var slotId = pendingItems[j].slotId;

                transaction[slotId] = null;
                dataTrans[slotId] = null;
            }

            amountOfItems = pendingItems.Count;

            client.Player = OverrideInventory(transaction.ChangedItems, dataTrans.ChangedItems, client.Player);

            var db = client.GameServer.Database;
            var task = db.AddMarketEntrySafety(
                client.Account,
                pendingItems.Select(pendingItem => (pendingItem.item.ObjectType, pendingItem.data?.GetData() ?? null)).ToList(),
                client.Player.AccountId,
                client.Player.Name,
                price,
                DateTime.UtcNow.AddHours(hours).ToUnixTimestamp(),
                (CurrencyType)currency
            );

            if (task.IsCanceled)
            {
                client.Player = OverrideInventory(transaction.OriginalItems, dataTrans.OriginalItems, client.Player);
                client.Player.SendError("D'oh! Something went wrong, try again later...");
                return;
            }

            client.SendPacket(new MarketAddResult
            {
                Code = -1,
                Description = $"Successfully added {amountOfItems} item{(amountOfItems > 1 ? "s" : "")} to the market."
            });

            StaticLogger.Instance.Warn($"<{player.Name} {player.AccountId}> Added {slots.Length} item's on market for: {price}");
        }

        private bool HandleInvalidCurrency(Client client, int currency)
        {
            if (!Enum.IsDefined(typeof(CurrencyType), currency) || currency == (int)CurrencyType.GuildFame)
            {
                client.SendPacket(new MarketAddResult
                {
                    Code = MarketAddResult.INVALID_CURRENCY,
                    Description = "Invalid currency."
                });
                return false;
            }

            return true;
        }

        private bool HandleInvalidPrice(Client client, int price)
        {
            if (price <= 0)
            {
                client.SendPacket(new MarketAddResult
                {
                    Code = MarketAddResult.INVALID_PRICE,
                    Description = "You cannot sell items for 0 or less."
                });
                return false;
            }

            return true;
        }

        private bool HandleInvalidUptime(Client client, int hours)
        {
            if (hours <= 0 || hours > 24)
            {
                client.SendPacket(new MarketAddResult
                {
                    Code = MarketAddResult.INVALID_UPTIME,
                    Description = "Only 1-24 hours uptime allowed."
                });
                return false;
            }

            return true;
        }

        private Player OverrideInventory(Item[] items, ItemData[] datas, Player player)
        {
            player.Inventory.SetItems(items);
            player.Inventory.Data.SetDatas(datas);
            player.SaveToCharacter();

            return player;
        }
    }
}
