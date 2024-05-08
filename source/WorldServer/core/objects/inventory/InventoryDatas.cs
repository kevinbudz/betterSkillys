using System;
using Shared.database.character.inventory;
using WorldServer.core.miscfile;
using WorldServer.core.net.stats;
using WorldServer.core.objects.containers;

namespace WorldServer.core.objects.inventory
{
    public class InventoryDatas
    {
        private ItemData[] _datas;
        private StatTypeValue<string>[] _datasValues;

        public InventoryDatas(IContainer container, ItemData[] datas)
        {
            _datasValues = new StatTypeValue<string>[datas.Length];
            _datas = new ItemData[datas.Length];

            for (var i = 0; i < datas.Length; i++)
            {
                var sti = (int)StatDataType.InventoryData0 + i;
                if (i >= 12)
                    sti = (int)StatDataType.BackPackData0 + i - 12;

                _datasValues[i] = new StatTypeValue<string>(container as Entity, (StatDataType)sti, datas[i]?.GetData() ?? "{}", container is Player && i > 3);
                _datas[i] = datas[i];
            }
        }

        public int Length => _datas.Length;

        public ItemData this[int index]
        {
            get => _datas[index];
            set
            {
                _datasValues[index].SetValue(value?.GetData() ?? "{}");
                _datas[index] = value;
            }
        }

        public ItemData[] GetDatas() => (ItemData[])_datas.Clone();

        public void SetDatas(ItemData[] datas)
        {
            if (datas.Length > Length)
                throw new InvalidOperationException("Item array must be <= the size of the initialized array.");

            for (var i = 0; i < datas.Length; i++)
            {
                _datasValues[i].SetValue(datas[i]?.GetData() ?? "{}");
                _datas[i] = datas[i];
            }
        }
    }
}
