using Shared.resources;
using WorldServer.core.net.stats;

namespace WorldServer.core.objects.inventory
{
    public class PotionStack
    {
        private readonly StatTypeValue<int> _count;

        public int Count
        {
            get => _count.GetValue(); 
            set => _count.SetValue(value);
        }

        public Item Item { get; private set; }
        public int MaxCount { get; private set; }
        public int Slot { get; private set; }

        public PotionStack(Player player, int slot, ushort objectType, int count, int maxCount)
        {
            Slot = slot;
            MaxCount = maxCount;
            Item = player.GameServer.Resources.GameData.Items[objectType];

            _count = new StatTypeValue<int>(player, GetStatsType(slot), count);
        }

        public Item Pop()
        {
            if (Count > 0)
            {
                Count--;
                return Item;
            }
            return null;
        }

        public Item Push(Item item)
        {
            if (Count < MaxCount && item == Item)
            {
                Count++;
                return null;
            }
            return item;
        }

        private static StatDataType GetStatsType(int slot)
        {
            return slot switch
            {
                254 => StatDataType.HealthStackCount,
                255 => StatDataType.MagicStackCount,
                _ => StatDataType.None,
            };
        }
    }
}
