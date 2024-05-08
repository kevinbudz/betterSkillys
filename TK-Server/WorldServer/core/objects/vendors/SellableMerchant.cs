using Shared.resources;
using System.Collections.Generic;
using System.Threading.Tasks;
using WorldServer.core.worlds;
using System.Linq;
using Shared;
using WorldServer.core.worlds.impl;
using WorldServer.utils;
using WorldServer.core.objects;
using WorldServer.core.objects.inventory;
using WorldServer.core.net.stats;

namespace WorldServer.core.objects.vendors
{
    public class SellableMerchant : SellableObject
    {
        public int Count { get => _count.GetValue(); set => _count.SetValue(value); }
        public ushort Item { get => _item.GetValue(); set => _item.SetValue(value); }
        public int ReloadOffset { get; set; }
        public bool Rotate { get; set; }
        public int TimeLeft { get => _timeLeft.GetValue(); set => _timeLeft.SetValue(value); }

        public volatile bool AwaitingReload;
        public volatile bool BeingPurchased;
        public volatile bool Reloading;

        private StatTypeValue<int> _count;
        private StatTypeValue<ushort> _item;
        private StatTypeValue<int> _timeLeft;

        public SellableMerchant(GameServer manager, ushort objType) : base(manager, objType)
        {
            _item = new StatTypeValue<ushort>(this, StatDataType.MerchandiseType, 0xa00);
            _count = new StatTypeValue<int>(this, StatDataType.MerchandiseCount, -1);
            _timeLeft = new StatTypeValue<int>(this, StatDataType.MerchandiseMinsLeft, -1);

            Rotate = false;
        }

        public override void Buy(Player player)
        {
            if (BeingPurchased)
            {
                SendFailed(player, BuyResult.BeingPurchased);
                return;
            }

            BeingPurchased = true;

            var item = GameServer.Resources.GameData.Items[Item];
            var result = ValidateCustomer(player, item);

            if (result != BuyResult.Ok)
            {
                SendFailed(player, result);
                BeingPurchased = false;

                return;
            }

            PurchaseItem(player, item);
        }

        public virtual void Reload()
        { }

        public override void Tick(ref TickTime time)
        {
            base.Tick(ref time);

            var a = time.TotalElapsedMs % 20000;
            if (AwaitingReload || a - time.ElapsedMsDelta <= ReloadOffset && a > ReloadOffset)
            {
                if (!AwaitingReload && !Rotate)
                    return;

                if (this.AnyPlayerNearby(2))
                {
                    AwaitingReload = true;
                    return;
                }

                if (BeingPurchased)
                {
                    AwaitingReload = true;
                    return;
                }

                BeingPurchased = true;

                TimeLeft = -1; // needed for player merchant to function properly with new rotation method
                Reload();
                BeingPurchased = false;
                AwaitingReload = false;
            }
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.MerchandiseType] = (int)Item;
            stats[StatDataType.MerchandiseCount] = Count;
            stats[StatDataType.MerchandiseMinsLeft] = -1; //(int)(TimeLeft / 60000f);

            base.ExportStats(stats, isOtherPlayer);
        }

        protected virtual void SendNotifications(Player player, bool gift)
        {
            player.Client.SendPacket(new networking.packets.outgoing.BuyResultMessage
            {
                Result = 0,
                ResultString = "Item purchased!"
            });
        }

        protected InventoryTransaction TransactionItem(Player player, Item item)
        {
            var invTrans = player.Inventory.CreateTransaction();
            var slot = invTrans.GetAvailableInventorySlot(item);
            if (slot == -1)
                return null;
            invTrans[slot] = item;
            return invTrans;
        }

        protected void TransactionItemComplete(Player player, InventoryTransaction invTrans, bool success)
        {
            var acc = player.Client.Account;

            if (!success)
            {
                SendFailed(player, BuyResult.TransactionFailed);
                player.SendError("An error ocurred, restart your Character (Go Char Selector).");
                return;
            }

            // update player currency values
            player.Credits = acc.Credits;
            player.CurrentFame = acc.Fame;

            if (invTrans != null)
            {
                Inventory.Execute(invTrans);
                SendNotifications(player, false);
            }
            else
                return;
        }

        private async void PurchaseItem(Player player, Item item)
        {
            var db = GameServer.Database;
            var trans = db.Conn.CreateTransaction();
            var t1 = db.UpdateCurrency(player.Client.Account, -Price, Currency, trans);
            var invTrans = TransactionItem(player, item);
            var t2 = trans.ExecuteAsync();

            await Task.WhenAll(t1, t2);

            var success = !t2.IsCanceled && t2.Result;

            TransactionItemComplete(player, invTrans, success);

            if (success && Count != -1 && --Count <= 0)
            {
                Reload();
                AwaitingReload = false;
            }

            BeingPurchased = false;
        }
    }
}
