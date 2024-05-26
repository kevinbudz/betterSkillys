using System;
using System.Collections.Generic;
using Shared;
using Shared.database.character.inventory;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public partial class Command
    {
        internal class Sell : Command
        {
            public override string CommandName => "sell";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var index = args.IndexOf(" "); //here we search for the space which divides the price and the inventory slot

                //check if the command it's correctly writted
                if(string.IsNullOrEmpty(args) || index == -1)
                {
                    player.SendInfo("/Sell <Inventory Slot> <Price>.");
                    return false;
                }

                //if there's an item that can't be sold, just cancel
                if(!CanSellItem(player))
                {
                    player.SendError("You're not allowed to use this command.");
                    return false;
                }

                var inventorySlotPosition = Convert.ToInt32(args.Substring(0, index)) + 3; //start from not equipped items.

                if(inventorySlotPosition > player.Inventory.Length)
                {
                    player.SendError($"Inventory Slot [{inventorySlotPosition}] doesn't exist.");
                    return false;
                }

                var price = Convert.ToInt32(args.Substring(index + 1));

                var inventorySlot = player.Inventory[inventorySlotPosition];
                var inventoryData = player.Inventory.Data[inventorySlotPosition];

                //Here we will check some things
                if(inventorySlot == null)
                {
                    player.SendError($"Empty Inventory Slot [{inventorySlotPosition}].");
                    return false;
                }

                if(inventorySlot.Soulbound || !CanSellItem(inventorySlot))
                {
                    player.SendError("You cannot sell this item.");
                    return false;
                }

                if(price <= 0)
                {
                    player.SendError("Price need to be more than 0.");
                    return false;
                }

                //we save the name (when we send the message that the item is added to the market, the item will be null, that's why i save it)
                var itemName = inventorySlot.ObjectId;

                //we create the transactions
                var inventoryTransaction = player.Inventory.CreateTransaction();
                var inventoryDataTransaction = player.Inventory.CreateDataTransaction();

                //remove item and data
                inventoryTransaction[inventorySlotPosition] = null;
                inventoryDataTransaction[inventorySlotPosition] = null;

                //update player inventory
                player = OverrideInventory(inventoryTransaction.ChangedItems, inventoryDataTransaction.ChangedItems, player);

                var client = player.Client;
                //this is something from market, but what we're doing here it's adding to the list the Item Type and the Item Data (if it has a Data)
                var itemList = new List<(ushort, string)>
                {
                    (inventorySlot.ObjectType, inventoryData?.GetData() ?? null)
                };

                var db = client.GameServer.Database;

                //we create a Task for add it
                var task = db.AddMarketEntrySafety(
                    client.Account,
                    itemList,
                    client.Player.AccountId,
                    client.Player.Name,
                    price,
                    DateTime.UtcNow.AddHours(24).ToUnixTimestamp(),
                    CurrencyType.Fame
                );

                //if something wrong happens, we will give the items back to the player
                if (task.IsCanceled)
                {
                    client.Player = OverrideInventory(inventoryTransaction.OriginalItems, inventoryDataTransaction.OriginalItems, client.Player);
                    client.Player.SendError("D'oh! Something went wrong, try again later...");
                    return false;
                }

                
                player.SendInfo($"Successfully added [{itemName}] to the Market for [{price}] Fame!");

                return true;
            }
        }

        #region Utilities

        private bool CanSellItem(Player player)
        {
            var config = player.GameServer.Configuration;

            if (player.Client.Account.Admin)
                return true;

            if (config.serverInfo.adminOnly)
            {
                if (!player.GameServer.IsWhitelisted(player.AccountId) || !player.Client.Account.Admin)
                {
                    player.SendError("Admin Only, you need to be Whitelisted to use this.");
                    return false;
                }
            }
            else
            {
                player.SendError("You can't use this Feature.");
                return false;
            }
            return true;
        }

        private bool CanSellItem(Item item)
        {
            if (item.Tier == null)
                return true;

            if (IsArmor(item.SlotType) && item.Tier < 11)
                return false;
            if (IsWeapon(item.SlotType) && item.Tier < 11)
                return false;
            if (IsRingOrAbility(item.SlotType) && item.Tier < 4)
                return false;

            return true;
        }

        //This expression "=>" it's the same thing as return but we save lines of codes because we don't need to write "{" "}" and "return"

        /* Example:
         * 
         *  private bool IsArmor(int type)
         *  {
         *      return type == 6 || type == 14 || type == 7;
         *  }
         *  
         *  this is the same thing as below
         */

        private bool IsArmor(int type) => type == 6 || type == 14 || type == 7;

        private bool IsWeapon(int type) => type == 1 || type == 2 || type == 3 || type == 8 || type == 17 || type == 24;

        private bool IsRingOrAbility(int type) => !IsWeapon(type) && !IsArmor(type); //if the type isn't a weapon or armor, it's a ring or an ability

        private Player OverrideInventory(Item[] items, ItemData[] datas, Player player)
        {
            player.Inventory.SetItems(items);
            player.Inventory.Data.SetDatas(datas);
            player.SaveToCharacter();

            return player;
        }

        #endregion
    }
}
