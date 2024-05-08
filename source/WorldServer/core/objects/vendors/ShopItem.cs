using System;

namespace WorldServer.core.objects.vendors
{
    public class ShopItem : ISellableItem
    {
        public string Name;

        public ShopItem(string name, ushort price, int count = -1)
        {
            ItemId = ushort.MaxValue;
            Price = price;
            Count = count;
            Name = name;
        }

        public int Count { get; }
        public ushort ItemId { get; private set; }
        public int Price { get; }

        public void SetItem(ushort item)
        {
            if (ItemId != ushort.MaxValue)
                throw new AccessViolationException("Can't change item after it has been set.");

            ItemId = item;
        }
    }
}
