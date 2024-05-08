using System.Collections.Generic;
using Shared.database.character.inventory;
using WorldServer.core.miscfile;
using WorldServer.core.objects.containers;

namespace WorldServer.core.objects.inventory
{
    public class InventoryDataTransaction : IEnumerable<ItemData>
    {
        public ItemData[] ChangedItems;
        public ItemData[] OriginalItems;

        private readonly IContainer _parent;

        public InventoryDataTransaction(IContainer parent)
        {
            _parent = parent;

            OriginalItems = parent.Inventory.Data.GetDatas();
            ChangedItems = (ItemData[])OriginalItems.Clone();
        }

        public int Length => OriginalItems.Length;

        public ItemData this[int index] { get => ChangedItems[index]; set => ChangedItems[index] = value; }

        public void Execute()
        {
            var inv = _parent.Inventory.Data;

            for (var i = 0; i < inv.Length; i++)
                if (OriginalItems[i] != ChangedItems[i])
                    inv[i] = ChangedItems[i];
        }

        public IEnumerator<ItemData> GetEnumerator() => ((IEnumerable<ItemData>)ChangedItems).GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => ChangedItems.GetEnumerator();

        public void Revert()
        {
            var inv = _parent.Inventory.Data;

            for (var i = 0; i < inv.Length; i++)
                if (OriginalItems[i] != ChangedItems[i])
                    inv[i] = OriginalItems[i];
        }

        public bool Validate(bool revert = false)
        {
            if (_parent == null)
                return false;

            var items = revert ? ChangedItems : OriginalItems;

            for (var i = 0; i < items.Length; i++)
                if (items[i] != _parent.Inventory.Data[i])
                    return false;

            return true;
        }
    }
}
