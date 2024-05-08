using System;
using System.Collections.Generic;
using System.Linq;
using Shared;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.objects.vendors;
using WorldServer.core.setpieces;
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
        public static float WeekendLootBoostEvent = 0.0f;
        public static int GetCurrentMonth = 0;
        public bool MarketEnabled = true;

        public KingdomPortalMonitor PortalMonitor { get; private set; }

        public NexusWorld(GameServer gameServer, int id, WorldResource resource) : base(gameServer, id, resource)
        {
        }

        public override void Init()
        {
            GetCurrentMonth = 1; //DateTime.Now.Month;
            var lootRegions = GetRegionPoints(TileRegion.Hallway_1);

            PortalMonitor = new KingdomPortalMonitor(GameServer, this);

            foreach (var shop in MerchantLists.Shops)
            {
                var positions = Map.Regions.Where(r => shop.Key == r.Value);
                foreach (var data in positions)
                {
                    var merchantData = new MerchantData();
                    merchantData.TileRegion = data.Value;
                    merchantData.Position = data.Key;
                    InactiveStorePoints.Add(merchantData);
                }
            }

            base.Init();
        }

        private List<MerchantData> InactiveStorePoints = new List<MerchantData>();
        private List<MerchantData> ActiveStorePoints = new List<MerchantData>();

        public void SendOutMerchant(MerchantData merchantData)
        {
            InactiveStorePoints.Remove(merchantData);
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
                ActiveStorePoints.Add(merchantData);
            }
        }

        private void HandleMerchants(ref TickTime time)
        {
            var merchantsToAdd = new List<MerchantData>();
            foreach (var merchantData in InactiveStorePoints)
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
            InactiveStorePoints.Add(merchantData);
        }

        protected override void UpdateLogic(ref TickTime time)
        {
            CheckWeekendLootBoostEvent();
            HandleMerchants(ref time);
            //HandleEngineTimeouts(ref time);
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
    }
}
