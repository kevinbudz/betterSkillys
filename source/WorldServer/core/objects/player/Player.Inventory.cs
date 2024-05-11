using Shared;
using Shared.database.character;
using Shared.database.character.inventory;
using Shared.resources;
using System.Linq;
using WorldServer.core.objects.inventory;

namespace WorldServer.core.objects
{
    partial class Player
    {
        public RInventory DbLink { get; private set; }
        public Inventory Inventory { get; private set; }

        public void InitializeInventory(XmlData gameData, DbChar character)
        {
            character.Datas ??= new ItemData[28];
            Inventory = new Inventory(this, Utils.ResizeArray(character.Items.Select(_ => (_ == 0xffff || !gameData.Items.ContainsKey(_)) ? null : gameData.Items[_]).ToArray(), 28), Utils.ResizeArray(Client.Character.Datas, 28));
            Inventory.InventoryChanged += (sender, e) => Stats.ReCalculateValues();
            SlotTypes = Utils.ResizeArray(gameData.Classes[ObjectType].SlotTypes, 28);
        }
    }
}
