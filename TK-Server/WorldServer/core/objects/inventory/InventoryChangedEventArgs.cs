using Shared.resources;
using System;

namespace WorldServer.core.objects.inventory
{
    public class InventoryChangedEventArgs : EventArgs
    {
        //index = -1 -> reset
        public InventoryChangedEventArgs(Item[] old, Item[] @new)
        {
            OldItems = old;
            NewItems = @new;
        }

        public Item[] NewItems { get; private set; }
        public Item[] OldItems { get; private set; }
    }
}
