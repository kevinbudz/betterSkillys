using Shared;
using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects.vendors;
using WorldServer.core.structures;

namespace WorldServer.core.worlds.impl
{
    public sealed class MerchantData
    {
        public TileRegion TileRegion;
        public float TimeToSpawn;
        public IntPoint Position;
        public NexusMerchant NewMerchant;
        public ISellableItem SellableItem;
        public CurrencyType CurrencyType;
        public int RankRequired;
    }

    public sealed class NexusWorld : World
    {
        // i dont really want to use static but it works so?
        public static float WeekendLootBoostEvent { get; private set; } = 0.0f;
        public static int CurrentMonth => 1;

        private readonly List<MerchantData> _inactiveStorePoints = new List<MerchantData>();
        private readonly List<MerchantData> _activeStorePoints = new List<MerchantData>();

        public RealmPortalMonitor PortalMonitor { get; private set; }
        public bool MarketEnabled { get; set; } = true;

        public NexusWorld(GameServer gameServer, int id, WorldResource resource) 
            : base(gameServer, id, resource)
        {
            PortalMonitor = new RealmPortalMonitor(gameServer, this);
        }

        public override void Init()
        {
            foreach (var shop in MerchantLists.Shops)
                foreach (var data in Map.Regions.Where(r => shop.Key == r.Value))
                    _inactiveStorePoints.Add(new MerchantData()
                    {
                        TileRegion = data.Value,
                        Position = data.Key
                    });

            base.Init();
        }

        protected override void UpdateLogic(ref TickTime time)
        {
            CheckWeekendLootBoostEvent();
            HandleMerchants(ref time);
            PortalMonitor.Update(ref time);
            base.UpdateLogic(ref time);
        }

        private void CheckWeekendLootBoostEvent()
        {
            var day = DateTime.Now.DayOfWeek;
            if (day != DayOfWeek.Saturday && day != DayOfWeek.Sunday)
                return;
            
            if (WeekendLootBoostEvent == 0.0f)
                WeekendLootBoostEvent = 0.30f;
            else if(WeekendLootBoostEvent == 0.30f && day == DayOfWeek.Monday)
            {
                WeekendLootBoostEvent = 0.0f;
                GameServer.ChatManager.ServerAnnounce("The weekend loot event has ended!");
            }
        }

        public void SendOutMerchant(MerchantData merchantData)
        {
            _inactiveStorePoints.Remove(merchantData);
            if (MerchantLists.Shops.TryGetValue(merchantData.TileRegion, out var data))
            {
                var items = data.Item1;
                if (items.Count == 0)
                    return;

                var x = merchantData.Position.X;
                var y = merchantData.Position.Y;

                merchantData.NewMerchant = new NexusMerchant(GameServer, 0x01ca);
                merchantData.NewMerchant.Move(x + 0.5f, y + 0.5f);
                merchantData.CurrencyType = data.Item2;
                merchantData.RankRequired = data.Item3;

                merchantData.SellableItem = Random.Shared.NextLength(items);
                merchantData.NewMerchant.SetData(merchantData);
                _ = MerchantLists.Shops[merchantData.TileRegion].Item1.Remove(merchantData.SellableItem);

                EnterWorld(merchantData.NewMerchant);
                _activeStorePoints.Add(merchantData);
            }
        }

        private void HandleMerchants(ref TickTime time)
        {
            var merchantsToAdd = new List<MerchantData>();
            foreach (var merchantData in _inactiveStorePoints)
            {
                merchantData.TimeToSpawn -= time.DeltaTime;
                if (merchantData.TimeToSpawn <= 0.0f)
                    merchantsToAdd.Add(merchantData);
            }

            foreach (var merchant in merchantsToAdd)
                SendOutMerchant(merchant);
        }

        public void ReturnMerchant(MerchantData merchantData)
        {
            merchantData.TimeToSpawn = 10.0f;
            MerchantLists.Shops[merchantData.TileRegion].Item1.Add(merchantData.SellableItem);
            LeaveWorld(merchantData.NewMerchant);
            merchantData.NewMerchant = null;
            _inactiveStorePoints.Add(merchantData);
        }

    }
}
