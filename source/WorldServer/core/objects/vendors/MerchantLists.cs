using Shared.resources;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core;

namespace WorldServer.core.objects.vendors
{
    public interface ISellableItem
    {
        int Count { get; }
        ushort ItemId { get; }
        int Price { get; }
    }

    internal static class MerchantLists
    {

        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private static readonly List<ISellableItem> Consumables = new List<ISellableItem>
        {
        };

        private static readonly List<ISellableItem> KeysGold = new List<ISellableItem>
        {
        };

        private static readonly List<ISellableItem> KeysFame = new List<ISellableItem>
        {
        };

        private static readonly List<ISellableItem> PurchasableFame = new List<ISellableItem>
        {
        };

        private static readonly List<ISellableItem> Special = new List<ISellableItem>
        {
        };

        public static void Initialize(GameServer gameServer)
        {
            InitDyes(gameServer);

            foreach (var shop in Shops)
            {
                var shopItems = shop.Value.Item1;

                if (shopItems == null)
                    continue;

                foreach (var shopItem in shopItems.OfType<ShopItem>())
                    if (!gameServer.Resources.GameData.IdToObjectType.TryGetValue(shopItem.Name, out ushort id))
                        Log.Warn("Item name: {0}, not found.", shopItem.Name);
                    else
                        shopItem.SetItem(id);
            }
        }

        public static readonly Dictionary<TileRegion, Tuple<List<ISellableItem>, CurrencyType, int>> Shops = new Dictionary<TileRegion, Tuple<List<ISellableItem>, CurrencyType, int>>()
        {
            { TileRegion.Store_1, new Tuple<List<ISellableItem>, CurrencyType, int>(PurchasableFame, CurrencyType.Fame, 0) },
            { TileRegion.Store_2, new Tuple<List<ISellableItem>, CurrencyType, int>(Consumables, CurrencyType.Fame, 0) },
            { TileRegion.Store_3, new Tuple<List<ISellableItem>, CurrencyType, int>(Special, CurrencyType.Gold, 0) },
            { TileRegion.Store_4, new Tuple<List<ISellableItem>, CurrencyType, int>(KeysGold, CurrencyType.Gold, 0) },
            { TileRegion.Store_11, new Tuple<List<ISellableItem>, CurrencyType, int>(KeysFame, CurrencyType.Fame, 0) }
        };

        private static void InitDyes(GameServer gameServer)
        {
            var d1 = new List<ISellableItem>();
            var d2 = new List<ISellableItem>();
            var c1 = new List<ISellableItem>();
            var c2 = new List<ISellableItem>();
            var petGenerators = new List<ISellableItem>();
            var supporterPetGenerators = new List<ISellableItem>();

            foreach (var i in gameServer.Resources.GameData.Items.Values)
            {
                if (i.InvUse && i.ObjectId.Contains("Generator"))
                {
                    if (i.DonorItem)
                    {
                        supporterPetGenerators.Add(new ShopItem(i.ObjectId, 1000));
                        continue;
                    }
                    petGenerators.Add(new ShopItem(i.ObjectId, 1250));
                    continue;
                }

                if (!i.Class.Equals("Dye"))
                    continue;

                if (i.Texture1 != 0)
                {
                    if (i.ObjectId.Contains("Cloth") && i.ObjectId.Contains("Large"))
                        d1.Add(new ShopItem(i.ObjectId, 25));

                    if (i.ObjectId.Contains("Dye") && i.ObjectId.Contains("Clothing"))
                        c1.Add(new ShopItem(i.ObjectId, 25));

                    continue;
                }

                if (i.Texture2 != 0)
                {
                    if (i.ObjectId.Contains("Cloth") && i.ObjectId.Contains("Small"))
                        d2.Add(new ShopItem(i.ObjectId, 10));
                    if (i.ObjectId.Contains("Dye") && i.ObjectId.Contains("Accessory"))
                        c2.Add(new ShopItem(i.ObjectId, 10));

                    continue;
                }
            }

            Shops[TileRegion.Store_5] = new Tuple<List<ISellableItem>, CurrencyType, int>(petGenerators, CurrencyType.Fame, 0);
            Shops[TileRegion.Store_10] = new Tuple<List<ISellableItem>, CurrencyType, int>(supporterPetGenerators, CurrencyType.Gold, 0);

            Shops[TileRegion.Store_6] = new Tuple<List<ISellableItem>, CurrencyType, int>(d1, CurrencyType.Fame, 0);
            Shops[TileRegion.Store_7] = new Tuple<List<ISellableItem>, CurrencyType, int>(d2, CurrencyType.Fame, 0);
            Shops[TileRegion.Store_8] = new Tuple<List<ISellableItem>, CurrencyType, int>(c1, CurrencyType.Fame, 0);
            Shops[TileRegion.Store_9] = new Tuple<List<ISellableItem>, CurrencyType, int>(c2, CurrencyType.Fame, 0);

        }
    }
}
