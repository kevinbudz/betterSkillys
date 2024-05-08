using StackExchange.Redis;
using Shared;
using Shared.database.account;

namespace Shared.database.vault
{
    public class DbVaultSingle : RInventory
    {
        public DbVaultSingle(DbAccount acc, int vaultIndex, bool isAsync = false)
        {
            Field = "vault." + vaultIndex;
            DataField = "vaultData." + vaultIndex;

            InitTwo(acc.Database, "vault." + acc.AccountId, new string[] { Field, DataField }, isAsync);

            var items = GetValue<ushort[]>(Field);

            if (items != null)
                return;

            var trans = Database.CreateTransaction();


            SetValue(Field, Items);
            SetValue(DataField, ItemDatas);
            FlushAsync(trans);

            trans.Execute(CommandFlags.FireAndForget);
        }
    }
}
