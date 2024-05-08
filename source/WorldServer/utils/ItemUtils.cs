using Shared.resources;
using WorldServer.core.objects.containers;

namespace WorldServer.utils
{
    public static class ItemUtils
    {
        public static bool AuditItem(this IContainer container, Item item, int slot)
        {
            if (container is GiftChest && item != null || container is SpecialChest && item != null)
                return false;
            return item == null || container.SlotTypes[slot] == 0 || item.SlotType == container.SlotTypes[slot];
        }
    }
}
