using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Shared.resources;
using WorldServer.core.net.stats;
using WorldServer.core.objects.inventory;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;

namespace WorldServer.core.objects.vendors
{
    public class NexusMerchant : SellableObject
    {
        private StatTypeValue<int> merchandiseType_;
        public int Type
        {
            get => merchandiseType_.GetValue();
            set => merchandiseType_.SetValue(value);
        }

        private StatTypeValue<int> merchandisePrice_;
        public new int Price
        {
            get => merchandisePrice_.GetValue();
            set => merchandisePrice_.SetValue(value);
        }

        private StatTypeValue<int> merchandiseCurrency_;
        public new int Currency
        {
            get => merchandiseCurrency_.GetValue();
            set => merchandiseCurrency_.SetValue(value);
        }

        private StatTypeValue<int> merchandiseCount_;
        public int Count
        {
            get => merchandiseCount_.GetValue();
            set => merchandiseCount_.SetValue(value);
        }

        private StatTypeValue<int> merchandiseTime_;
        public int MinsLeft
        {
            get => merchandiseTime_.GetValue();
            set => merchandiseTime_.SetValue(value);
        }

        private StatTypeValue<int> merchandiseDiscount_;
        public int Discount
        {
            get => merchandiseDiscount_.GetValue();
            set => merchandiseDiscount_.SetValue(value);
        }

        private StatTypeValue<int> merchandiseRankRequired_;
        public new int RankRequired
        {
            get => merchandiseRankRequired_.GetValue();
            set => merchandiseRankRequired_.SetValue(value);
        }

        private bool IsNew { get; set; }
        private float OneMinuteTime { get; set; }
        private float AliveTime { get; set; }

        private volatile bool BeingPurchased;

        public MerchantData MerchantData { get; private set; }

        public NexusMerchant(GameServer gameServer, ushort objType) : base(gameServer, objType)
        {
            merchandiseType_ = new StatTypeValue<int>(this, StatDataType.MerchandiseType, -1);
            merchandisePrice_ = new StatTypeValue<int>(this, StatDataType.MerchandisePrice, 0);
            merchandiseCurrency_ = new StatTypeValue<int>(this, StatDataType.MerchandiseCurrency, 0);
            merchandiseCount_ = new StatTypeValue<int>(this, StatDataType.MerchandiseCount, 0);
            merchandiseTime_ = new StatTypeValue<int>(this, StatDataType.MerchandiseMinsLeft, int.MaxValue);
            merchandiseDiscount_ = new StatTypeValue<int>(this, StatDataType.MerchandiseDiscount, -1);
            merchandiseRankRequired_ = new StatTypeValue<int>(this, StatDataType.MerchandiseRankReq, -1);
        }

        public override void Buy(Player player)
        {
            if (BeingPurchased)
            {
                SendFailed(player, BuyResult.BeingPurchased);
                return;
            }

            BeingPurchased = true;

            var item = GameServer.Resources.GameData.Items[(ushort)Type];

            var result = ValidateCustomer(player, item);
            if (result != BuyResult.Ok)
            {
                SendFailed(player, result);
                BeingPurchased = false;
                return;
            }

            PurchaseItem(player, item);
        }

        protected new BuyResult ValidateCustomer(Player player, Item item)
        {
            if (World is TestWorld)
                return BuyResult.IsTestMap;

            if (player.Stars < RankRequired)
                return BuyResult.InsufficientRank;

            var acc = player.Client.Account;

            if (acc.Guest)
            {
                // reload guest prop just in case user registered in game
                acc.Reload("guest");

                if (acc.Guest)
                    return BuyResult.IsGuest;
            }

            if (player.GetCurrency((CurrencyType)Currency) < Price)
                return BuyResult.InsufficientFunds;

            if (item != null) // not perfect, but does the job for now
            {
                var availableSlot = player.Inventory.CreateTransaction().GetAvailableInventorySlot(item);
                if (availableSlot == -1)
                    return BuyResult.NotEnoughSlots;
            }

            return BuyResult.Ok;
        }

        public void SetData(MerchantData data)
        {
            MerchantData = data;
        }

        public override void Init(World world)
        {
            base.Init(world);

            IsNew = true;

            var data = MerchantData;

            var sellableItem = data.SellableItem;
            var price = sellableItem.Price;

            Type = sellableItem.ItemId;
            Price = price;
            Currency = (int)data.CurrencyType;
            Count = Random.Shared.Next(5, 15);
            RankRequired = data.RankRequired;

            if (sellableItem.ItemId == 0x7021 || sellableItem.ItemId == 0x7019 || sellableItem.ItemId == 0x7018 || sellableItem.ItemId == 0x7017 || sellableItem.ItemId == 0x7016)
                return;

            var discountChance = Random.Shared.NextDouble();
            if (discountChance < 0.1)
            {
                var discountType = Random.Shared.Next(0, 100);
                if (discountType < 2)
                    Discount = 50;
                else if (discountType < 5)
                    Discount = 25;
                else if (discountType < 10)
                    Discount = 15;
                else if (discountType < 15)
                    Discount = 10;

                var discountPrice = (int)(Price * (Discount / 100.0));
                Price -= discountPrice;
            }
        }

        public override void Tick(ref TickTime time)
        {
            var dt = time.DeltaTime;

            AliveTime += dt;
            OneMinuteTime += dt;

            if (IsNew && AliveTime > 15.0f)
            {
                MinsLeft = Random.Shared.Next(10, 30);
                IsNew = false;
            }

            if (OneMinuteTime >= 60.0f)
            {
                MinsLeft--;
                OneMinuteTime = 0.0f;
            }

            if (MinsLeft == 0 || Count == 0)
                (World as NexusWorld).ReturnMerchant(MerchantData);
            base.Tick(ref time);
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.MerchandiseType] = Type;
            stats[StatDataType.MerchandisePrice] = Price;
            stats[StatDataType.MerchandiseCurrency] = Currency;
            stats[StatDataType.MerchandiseCount] = Count;
            stats[StatDataType.MerchandiseMinsLeft] = MinsLeft;
            stats[StatDataType.MerchandiseDiscount] = Discount;
            stats[StatDataType.MerchandiseRankReq] = base.RankRequired;
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
            var t1 = db.UpdateCurrency(player.Client.Account, -Price, (CurrencyType)Currency, trans);
            var invTrans = TransactionItem(player, item);
            var t2 = trans.ExecuteAsync();

            await Task.WhenAll(t1, t2);

            var success = !t2.IsCanceled && t2.Result;
            TransactionItemComplete(player, invTrans, success);
            if (success)
                Count--;
            BeingPurchased = false;
        }
    }

}
