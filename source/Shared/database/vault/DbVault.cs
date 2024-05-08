using System.Linq;
using Shared.database.account;

namespace Shared.database.vault
{
    public class DbVault : RedisObject
    {
        public DbVault(DbAccount acc, bool isAsync = false)
        {
            Account = acc;

            Init(acc.Database, "vault." + acc.AccountId, null, isAsync);
        }

        public DbAccount Account { get; private set; }

        public ushort[] this[int index] { get => GetValue<ushort[]>("vault." + index) ?? Enumerable.Repeat((ushort)0xffff, 8).ToArray(); set => SetValue("vault." + index, value); }
    }
}
