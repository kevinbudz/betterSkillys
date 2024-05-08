using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class AppSettings
    {
        public string MenuMusic { get; set; }
        public string DeadMusic { get; set; }
        public int VaultChestPrice { get; set; }
        public int MaxStackablePotions { get; set; }
        public int UseExternalPayments { get; set; }

        public NewAccounts NewAccounts { get; set; }
        public NewCharacters NewCharacters { get; set; }

        public void LoadSettings(string dir)
        {
            var e = XElement.Parse(Utils.Read(dir));
            MenuMusic = e.GetValue<string>("MenuMusic");
            DeadMusic = e.GetValue<string>("DeadMusic");
            VaultChestPrice = e.GetValue<int>("VaultChestPrice");
            UseExternalPayments = e.GetValue<int>("UseExternalPayments");
            MaxStackablePotions = e.GetValue<int>("MaxStackablePotions");

            var newAccounts = e.Element("NewAccounts");
            NewAccounts = new NewAccounts(e.Element("NewAccounts"));
            newAccounts.Remove();

            var newCharacters = e.Element("NewCharacters");
            NewCharacters = new NewCharacters(e.Element("NewCharacters"));
            newCharacters.Remove();
        }
    }
}
