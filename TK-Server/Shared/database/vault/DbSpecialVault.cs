using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Shared.database.account;
using Shared.database.character.inventory;

namespace Shared.database.vault
{
    public class DbSpecialVault : RInventory
    {
        public DbSpecialVault(DbAccount acc, int vaultIndex, bool isAsync = false)
        {
            Field = "specialVault." + vaultIndex;
            DataField = "specialVaultData." + vaultIndex;

            InitTwo(acc.Database, "specialVault." + acc.AccountId, new string[] { Field, DataField }, isAsync);

            var items = GetValue<ushort[]>(Field);

            if (items != null)
                return;

            var trans = Database.CreateTransaction();

            SetValue(Field, Items);
            SetValue(DataField, ItemDatas);
            FlushAsync(trans);

            trans.Execute(CommandFlags.FireAndForget);
        }

        public bool GetItems()
        {
            for (var i = 0; i < Items.Length; i++)
                if (Items[i] != ushort.MaxValue)
                    return true;
            return false;
        }

        public bool IsFull()
        {
            var count = 0;
            for (var i = 0; i < Items.Length; i++)
                if (Items[i] != ushort.MaxValue)
                    count++;
            return count >= 8;
        }

        public static bool AddItem(DbAccount acc, ushort itemType, string itemData)
        {
            for (var i = 0; i < 6; i++)
            {
                var chest = new DbSpecialVault(acc, i);
                if (chest.IsFull())
                    continue;
                if (chest.IsFull() && i == 5)
                    return false;

                chest.SetItem(itemType, ItemData.CreateData(itemData));
                chest.FlushAsync();
                return true;
            }
            return false;
        }

        public bool SetItem(ushort item, ItemData data)
        {
            if (Field == null || DataField == null)
                return false;

            var trans = Database.CreateTransaction();
            var items = GetValue<ushort[]>(Field);
            var datas = GetValue<ItemData[]>(DataField);
            for (var i = 0; i < items.Length; i++)
            {
                if (items[i] != ushort.MaxValue)
                    continue;
                items[i] = item;
                datas[i] = data;
                break;
            }
            SetValue(Field, items);
            SetValue(DataField, datas);
            FlushAsync(trans);

            trans.Execute(CommandFlags.FireAndForget);
            return true;
        }
    }
}
