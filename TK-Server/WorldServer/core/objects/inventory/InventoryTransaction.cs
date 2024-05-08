using Shared.resources;
using System.Collections.Generic;
using WorldServer.core.miscfile;
using WorldServer.core.objects.containers;

namespace WorldServer.core.objects.inventory
{
    public class InventoryTransaction : IEnumerable<Item>
    {
        public Item[] ChangedItems;
        public Item[] OriginalItems;

        private readonly IContainer _parent;

        public InventoryTransaction(IContainer parent)
        {
            _parent = parent;

            OriginalItems = parent.Inventory.GetItems();
            ChangedItems = (Item[])OriginalItems.Clone();
        }

        public int Length => OriginalItems.Length;

        public Item this[int index] { get => ChangedItems[index]; set => ChangedItems[index] = value; }

        public void Execute()
        {
            var inv = _parent.Inventory;
            for (var i = 0; i < inv.Length; i++)
                if (OriginalItems[i] != ChangedItems[i])
                    inv[i] = ChangedItems[i];
        }

        public int GetAvailableInventorySlot(Item item)
        {
            if (_parent is Player plr)
            {
                var playerDesc = plr.GameServer.Resources.GameData
                    .Classes[plr.ObjectDesc.ObjectType];
                for (var i = 0; i < 4; i++)
                    if (ChangedItems[i] == null && playerDesc.SlotTypes[i] == item.SlotType)
                        return i;

                for (var i = 4; i < 12 || plr.HasBackpack && i < plr.Inventory.Length; i++)
                    if (ChangedItems[i] == null)
                        return i;
            }
            else
            {
                for (var i = 0; i < 8; i++)
                    if (ChangedItems[i] == null)
                        return i;
            }

            return -1;
        }

        public IEnumerator<Item> GetEnumerator() => ((IEnumerable<Item>)ChangedItems).GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => ChangedItems.GetEnumerator();

        public void Revert()
        {
            var inv = _parent.Inventory;

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
                if (items[i] != _parent.Inventory[i])
                    return false;

            return true;
        }
    }
}
