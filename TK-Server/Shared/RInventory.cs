using System.Linq;
using Shared.database;
using Shared.database.character.inventory;

namespace Shared
{
    public abstract class RInventory : RedisObject
    {
        public string Field { get; protected set; }
        public string DataField { get; protected set; }

        public ushort[] Items
        {
            get => GetValue<ushort[]>(Field) ?? Enumerable.Repeat((ushort)0xffff, 8).ToArray(); 
            set => SetValue(Field, value); 
        }
        public ItemData[] ItemDatas
        {
            get => GetValue<ItemData[]>(DataField) ?? new ItemData[28];
            set => SetValue(DataField, value);
        }
    }
}
