using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class NewAccounts
    {
        public readonly bool ClassesUnlocked;
        public readonly int Credits;
        public readonly int Fame;
        public readonly int MaxCharSlot;
        public readonly bool SkinsUnlocked;
        public readonly int SlotCost;
        public readonly CurrencyType SlotCurrency;
        public readonly int VaultCount;
        public readonly bool TestingRegister;

        public NewAccounts(XElement e)
        {
            MaxCharSlot = e.GetValue("MaxCharSlot", 1);
            VaultCount = e.GetValue("VaultCount", 1);
            Fame = e.GetValue("Fame", 0);
            Credits = e.GetValue("Credits", 0);
            ClassesUnlocked = e.HasElement("ClassesUnlocked");
            SkinsUnlocked = e.HasElement("SkinsUnlocked");
            SlotCost = e.GetValue("SlotCost", 1000);
            SlotCurrency = (CurrencyType)e.GetValue("SlotCurrency", 0);
            TestingRegister = e.HasElement("TestingRegister");

            if (SlotCurrency != CurrencyType.Fame && SlotCurrency != CurrencyType.Gold)
                SlotCurrency = CurrencyType.Gold;
        }
    }
}
