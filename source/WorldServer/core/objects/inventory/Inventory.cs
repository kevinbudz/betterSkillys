using System;
using System.Collections.Generic;
using System.Linq;
using Shared.database.character.inventory;
using Shared.resources;
using WorldServer.core.objects.containers;

namespace WorldServer.core.objects.inventory
{
    public static class InventoryConstants
    {
        public const int NO_ITEM = -1;
        public const int ALL_SLOT_TYPE = 0;
        public const int SWORD_SLOT_TYPE = 1;
        public const int DAGGER_SLOT_TYPE = 2;
        public const int BOW_SLOT_TYPE = 3;
        public const int TOME_SLOT_TYPE = 4;
        public const int SHIELD_SLOT_TYPE = 5;
        public const int LEATHER_SLOT_TYPE = 6;
        public const int PLATE_SLOT_TYPE = 7;
        public const int WAND_SLOT_TYPE = 8;
        public const int RING_SLOT_TYPE = 9;
        public const int POTION_SLOT_TYPE = 10;
        public const int SPELL_SLOT_TYPE = 11;
        public const int SEAL_SLOT_TYPE = 12;
        public const int CLOAK_SLOT_TYPE = 13;
        public const int ROBE_SLOT_TYPE = 14;
        public const int QUIVER_SLOT_TYPE = 15;
        public const int HELM_SLOT_TYPE = 16;
        public const int STAFF_SLOT_TYPE = 17;
        public const int POISON_SLOT_TYPE = 18;
        public const int SKULL_SLOT_TYPE = 19;
        public const int TRAP_SLOT_TYPE = 20;
        public const int ORB_SLOT_TYPE = 21;
        public const int PRISM_SLOT_TYPE = 22;
        public const int SCEPTER_SLOT_TYPE = 23;
        public const int KATANA_SLOT_TYPE = 24;
        public const int SHURIKEN_SLOT_TYPE = 25;

        public const int MAXIMUM_INTERACTION_DISTANCE = 1;
        public const int NUM_EQUIPMENT_SLOTS = 4;
        public const int NUM_INVENTORY_SLOTS = 8;
        public const int NUM_BACKPACK_SLOTS = 8;
    }

    public sealed class Inventory : IEnumerable<Item>
    {

        public InventoryItems _items;

        public InventoryDatas Data;

        private static readonly object TrySaveLock = new object();

        private object _invLock = new object();

        public Inventory(IContainer parent) : this(parent, new Item[28], new ItemData[28])
        { }

        public Inventory(IContainer parent, Item[] items, ItemData[] datas)
        {
            Parent = parent;

            _items = new InventoryItems(parent, items);

            Data = new InventoryDatas(parent, datas);
        }

        public event EventHandler<InventoryChangedEventArgs> InventoryChanged;

        public int Length => _items.Length;
        public IContainer Parent { get; }

        public Item this[int index]
        {
            get
            {
                using (TimedLock.Lock(_invLock))
                    return _items[index];
            }
            set
            {
                using (TimedLock.Lock(_invLock))
                    if (_items[index] != value)
                    {
                        var oItems = _items.GetItems();

                        _items[index] = value;

                        InventoryChanged?.Invoke(this, new InventoryChangedEventArgs(oItems, _items.GetItems()));
                    }
            }
        }

        public static bool Execute(params InventoryTransaction[] transactions)
        {
            using (TimedLock.Lock(TrySaveLock))
            {
                if (transactions.Any(tranaction => !tranaction.Validate()))
                    return false;

                foreach (var transcation in transactions)
                    transcation.Execute();

                return true;
            }
        }

        public static bool Revert(params InventoryTransaction[] transactions)
        {
            using (TimedLock.Lock(TrySaveLock))
            {
                if (transactions.Any(tranaction => !tranaction.Validate(true)))
                    return false;

                foreach (var transcation in transactions)
                    transcation.Revert();
                return true;
            }
        }

        public static bool DatExecute(params InventoryDataTransaction[] transactions)
        {
            using (TimedLock.Lock(TrySaveLock))
            {
                if (transactions.Any(transaction => !transaction.Validate()))
                    return false;

                foreach (var transaction in transactions)
                    transaction.Execute();
                return true;
            }
        }

        public static bool DatRevert(params InventoryDataTransaction[] transactions)
        {
            using (TimedLock.Lock(TrySaveLock))
            {
                if (transactions.Any(transaction => !transaction.Validate(true)))
                    return false;

                foreach (var trans in transactions)
                    trans.Revert();

                return true;
            }
        }

        public InventoryTransaction CreateTransaction() => new InventoryTransaction(Parent);

        public InventoryDataTransaction CreateDataTransaction() => new InventoryDataTransaction(Parent);

        public int GetAvailableInventorySlot(Item item)
        {
            using (TimedLock.Lock(_invLock))
            {
                if (Parent is Player plr)
                {
                    var playerDesc = plr.GameServer.Resources.GameData.Classes[plr.ObjectDesc.ObjectType];
                    for (var i = 0; i < InventoryConstants.NUM_EQUIPMENT_SLOTS; i++)
                        if (_items[i] == null && playerDesc.SlotTypes[i] == item.SlotType)
                            return i;

                    for (var i = InventoryConstants.NUM_EQUIPMENT_SLOTS; i < InventoryConstants.NUM_EQUIPMENT_SLOTS + InventoryConstants.NUM_INVENTORY_SLOTS || plr.HasBackpack && i < plr.Inventory.Length; i++)
                        if (_items[i] == null)
                            return i;
                }
                else
                {
                    for (var i = 0; i < InventoryConstants.NUM_INVENTORY_SLOTS; i++)
                        if (_items[i] == null)
                            return i;
                }

                return -1;
            }
        }

        public IEnumerator<Item> GetEnumerator() => ((IEnumerable<Item>)_items.GetItems()).GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => _items.GetItems().GetEnumerator();

        public Item[] GetItems()
        {
            using (TimedLock.Lock(TrySaveLock))
            using (TimedLock.Lock(_invLock))
                return _items.GetItems();
        }

        public ushort[] GetItemTypes()
        {
            using (TimedLock.Lock(_invLock))
                return _items.GetItems().Select(_ => _?.ObjectType ?? 0xffff).ToArray();
        }

        public void SetItems(Item[] items)
        {
            using (TimedLock.Lock(_invLock))
            {
                var oItems = _items.GetItems();

                _items.SetItems(items);

                InventoryChanged?.Invoke(this, new InventoryChangedEventArgs(oItems, _items.GetItems()));
            }
        }

        public void SetDataItems(ItemData[] datas)
        {
            using (TimedLock.Lock(_invLock))
            {
                Data.SetDatas(datas);
            }
        }

        public Item[] ConvertTypeToItemArray(IEnumerable<ushort> a)
        {
            var gameData = (Parent as Entity).GameServer.Resources.GameData;
            return a.Select(_ => _ == 0xffff || !gameData.Items.ContainsKey(_) ? null : gameData.Items[_]).ToArray();
        }

        public static string NameFromSlotType(int type)
        {
            return type switch
            {
                InventoryConstants.ALL_SLOT_TYPE => "Any",
                InventoryConstants.SWORD_SLOT_TYPE => "Sword",
                InventoryConstants.DAGGER_SLOT_TYPE => "Dagger",
                InventoryConstants.BOW_SLOT_TYPE => "Bow",
                InventoryConstants.TOME_SLOT_TYPE => "Tome",
                InventoryConstants.SHIELD_SLOT_TYPE => "Shield",
                InventoryConstants.LEATHER_SLOT_TYPE => "Leather Armor",
                InventoryConstants.PLATE_SLOT_TYPE => "Armor",
                InventoryConstants.WAND_SLOT_TYPE => "Wand",
                InventoryConstants.RING_SLOT_TYPE => "Accessory",
                InventoryConstants.POTION_SLOT_TYPE => "Potion",
                InventoryConstants.SPELL_SLOT_TYPE => "Spell",
                InventoryConstants.SEAL_SLOT_TYPE => "Holy Seal",
                InventoryConstants.CLOAK_SLOT_TYPE => "Cloak",
                InventoryConstants.ROBE_SLOT_TYPE => "Robe",
                InventoryConstants.QUIVER_SLOT_TYPE => "Quiver",
                InventoryConstants.HELM_SLOT_TYPE => "Helm",
                InventoryConstants.STAFF_SLOT_TYPE => "Staff",
                InventoryConstants.POISON_SLOT_TYPE => "Poison",
                InventoryConstants.SKULL_SLOT_TYPE => "Skull",
                InventoryConstants.TRAP_SLOT_TYPE => "Trap",
                InventoryConstants.ORB_SLOT_TYPE => "Orb",
                InventoryConstants.PRISM_SLOT_TYPE => "Prism",
                InventoryConstants.SCEPTER_SLOT_TYPE => "Scepter",
                InventoryConstants.KATANA_SLOT_TYPE => "Katana",
                InventoryConstants.SHURIKEN_SLOT_TYPE => "Shuriken",
                _ => "Invalid Type!",
            };
        }
    }
}
