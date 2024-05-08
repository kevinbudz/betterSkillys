using Shared;
using WorldServer.core.objects.inventory;

namespace WorldServer.core.objects.containers
{
    public interface IContainer
    {
        RInventory DbLink { get; }
        Inventory Inventory { get; }
        int[] SlotTypes { get; }
    }
}
