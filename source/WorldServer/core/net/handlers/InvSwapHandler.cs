using System;
using System.Collections.Generic;
using System.Linq;
using Shared;
using Shared.database.character.inventory;
using Shared.logger;
using Shared.resources;
using WorldServer.core.miscfile;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.objects.inventory;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;
using static WorldServer.core.commands.Command;
using System.Reflection.Metadata;
using WorldServer.core.worlds;
using WorldServer.core.net.stats;
using WorldServer.core.structures;
using WorldServer.core.net.datas;
using WorldServer.logic;

namespace WorldServer.core.net.handlers
{
    public class InvSwapHandler : IMessageHandler
    {
        private const ushort SOULBOUND_LOOT_BAG_TYPE = 0x0503;
        private static readonly string[] StackableItems = new string[] { "Magic Dust", "Glowing Shard", "Frozen Coin" }; //stackable items

        public override MessageId MessageId => MessageId.INVSWAP;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var position = Position.Read(rdr);
            var slotObj1 = ObjectSlot.Read(rdr);
            var slotObj2 = ObjectSlot.Read(rdr);

            Handle(client.Player, client.Player.World.GetEntity(slotObj1.ObjectId), client.Player.World.GetEntity(slotObj2.ObjectId), slotObj1.SlotId, slotObj2.SlotId);
        }

        private void Handle(Player player, Entity from, Entity to, int slotFrom, int slotTo)
        {
            if (player == null || player.Client == null || player.World == null)
                return;

            if (player.World is DailyQuestWorld)
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.SendInfo("You cannot swap inventory items inside the Marketplace!");
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            if (!ValidateEntities(player, from, to) || player.TradeTarget != null)
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            var conFrom = (IContainer)from;
            var conTo = (IContainer)to;

            // check if stacking operation
            if (to == player)
            {
                foreach (var stack in player.PotionStacks)
                    if (stack.Slot == slotTo)
                    {
                        var stackTrans = conFrom.Inventory.CreateTransaction();
                        var item = stack.Push(stackTrans[slotFrom]);

                        if (item == null) // success
                        {
                            if (from is GiftChest && stackTrans[slotFrom] != null)
                            {
                                var trans = player.GameServer.Database.Conn.CreateTransaction();
                                player.GameServer.Database.RemoveGift(player.Client.Account, stackTrans[slotFrom].ObjectType, trans);
                                trans.Execute();
                            }
                            stackTrans[slotFrom] = null;
                            Inventory.Execute(stackTrans);
                            player.Client.SendPacket(new InvResult() { Result = 0 });
                            return;
                        }
                    }
            }

            // not stacking operation, continue on with normal swap

            // validate slot types
            if (!ValidateSlotSwap(conFrom, conTo, slotFrom, slotTo))
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            if (player.Client.Account.Admin && (from as Container ?? to as Container) != null && Array.IndexOf((from as Container ?? to as Container).BagOwners, player.AccountId) == -1)
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            // setup swap
            var queue = new Queue<Action>();
            var conFromTrans = conFrom.Inventory.CreateTransaction();
            var conToTrans = conTo.Inventory.CreateTransaction();
            var itemFrom = conFromTrans[slotFrom];
            var itemTo = conToTrans[slotTo];
            conToTrans[slotTo] = itemFrom;
            conFromTrans[slotFrom] = itemTo;

            if (!ValidateItemSwap(player, conFrom, itemTo, slotTo))
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            if (!ValidateItemSwap(player, conTo, itemFrom, slotFrom))
            {
                from.ForceUpdate(slotFrom);
                to.ForceUpdate(slotTo);
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            var conDataFromTrans = conFrom.Inventory.CreateDataTransaction();
            var conDataToTrans = conTo.Inventory.CreateDataTransaction();
            var dataFrom = conDataFromTrans[slotFrom];
            var dataTo = conDataToTrans[slotTo];

            conDataToTrans[slotTo] = dataFrom;
            conDataFromTrans[slotFrom] = dataTo;

            if (ValidateStackable(dataTo, dataFrom, slotTo, slotFrom))
            {
                if (IsSameKindOfItem(itemTo, itemFrom, StackableItems))
                {
                    var rest = dataTo.Stack + dataFrom.Stack;
                    if (rest > dataTo.MaxStack)
                    {
                        dataTo.Stack = dataTo.MaxStack;

                        conDataToTrans[slotTo] = dataTo;
                        conToTrans[slotTo] = itemTo;

                        dataFrom.Stack = rest - dataFrom.MaxStack;
                        conDataFromTrans[slotFrom] = dataFrom;
                        conFromTrans[slotFrom] = itemFrom;
                    }
                    else
                    {
                        dataTo.Stack += dataFrom.Stack;
                        conDataToTrans[slotTo] = dataTo;
                        conToTrans[slotTo] = itemTo;

                        dataFrom = null;
                        itemFrom = null;
                        conDataFromTrans[slotFrom] = null;
                        conFromTrans[slotFrom] = null;
                    }
                    to?.InvokeStatChange((StatDataType)((int)StatDataType.InventoryData0 + slotTo), dataTo?.GetData() ?? "{}");
                    from?.InvokeStatChange((StatDataType)((int)StatDataType.InventoryData0 + slotFrom), dataFrom?.GetData() ?? "{}");
                }
            }

            if (!Inventory.DatExecute(conDataFromTrans, conDataToTrans))
            {
                if (!Inventory.DatRevert(conDataFromTrans, conDataToTrans))
                    Log.Warn($"Failed to Revert Data Changes. {player.Name} has an extra data [ {dataFrom.GetData()} or {dataTo.GetData()} ]");
            }

            if (Inventory.Execute(conFromTrans, conToTrans))
            {
                var db = player.GameServer.Database;
                var trans = db.Conn.CreateTransaction();

                if (from is GiftChest && itemFrom != null) db.RemoveGift(player.Client.Account, itemFrom.ObjectType, trans);
                if (to is GiftChest && itemTo != null) db.RemoveGift(player.Client.Account, itemTo.ObjectType, trans);

                if (trans.Execute())
                {
                    while (queue.Count > 0)
                        queue.Dequeue()();

                    player.Client.SendPacket(new InvResult() { Result = 0 });
                    return;
                }

                // if execute failed, undo inventory changes
                if (!Inventory.Revert(conFromTrans, conToTrans))
                    Log.Warn($"Failed to revert changes. {player.Name} has an extra {itemFrom?.ObjectId} or {itemTo?.ObjectId}");
            }

            from.ForceUpdate(slotFrom);
            to.ForceUpdate(slotTo);

            player.Client.SendPacket(new InvResult() { Result = 1 });
        }


        private bool ValidateStackable(ItemData itemA, ItemData itemB, int slotA, int slotB) =>
            itemA != null && itemB != null
            && slotA != slotB
            && itemA.Stack > 0 && itemA.MaxStack > 0
            && itemA.Stack < itemA.MaxStack
            && itemB.Stack > 0 && itemB.MaxStack > 0
            && itemB.Stack < itemB.MaxStack;

        private bool IsSameKindOfItem(Item itemA, Item itemB, string[] objsId)
        {
            if (itemA == null || itemB == null)
                return false;

            var itemAObjId = itemA.ObjectId;
            var itemBObjId = itemB.ObjectId;
            foreach (var obj in objsId)
            {
                if (itemAObjId.Contains(obj) && itemBObjId.Contains(obj))
                    return true;
            }
            return false;
        }

        private bool ValidateItemSwap(Player player, IContainer container, Item item, int slot)
        {
            if(container == player)
            {
                if(slot > 20)
                    if(item != null)
                    {
                        var count = -1;
                        for (var i = 20; i < 28; i++)
                            if (player.Inventory[i] != null && player.Inventory[i].ObjectType == item.ObjectType)
                                count++;
                        if (count > 1)
                            return false;
                        //for (var i = 20; i < 28; i++)
                        //    if (player.Inventory[i] != null && player.Inventory[i].ObjectType == item.ObjectType && item.TalismanItemDesc.OnlyOne)
                        //        return false;
                    }
            }
            return container == player || item == null || !item.Soulbound && !player.Client.Account.Admin || IsSoleContainerOwner(player, container);
        }

        private bool IsSoleContainerOwner(Player player, IContainer con)
        {
            int[] owners = null;
            var container = con as Container;
            if (container != null)
                owners = container.BagOwners;
            return owners != null && owners.Length == 1 && owners.Contains(player.AccountId);
        }

        private bool ValidateEntities(Player player, Entity from, Entity to)
        {
            // returns false if bad input
            if (from == null || to == null) 
                return false;

            if (from as IContainer == null || to as IContainer == null)
                return false;

            if (from is Player && from != player || to is Player && to != player)
                return false;

            if (from is Container && (from as Container).BagOwners.Length > 0 && !(from as Container).BagOwners.Contains(player.AccountId))
                return false;

            if (to is Container && (to as Container).BagOwners.Length > 0 && !(to as Container).BagOwners.Contains(player.AccountId))
                return false;

            if (from is GiftChest && to != player || to is GiftChest && from != player)
                return false;

            if (from is SpecialChest && to != player || to is SpecialChest && from != player)
                return false;

            var aPos = new Vector2(from.X, from.Y);
            var bPos = new Vector2(to.X, to.Y);
            if (Vector2.DistanceSquared(aPos, bPos) > 1) 
                return false;
            return true;
        }

        // todo add in talisman count checks
        private bool ValidateSlotSwap(IContainer conA, IContainer conB, int slotA, int slotB)
            => slotA < 20 && slotB < 20 &&
                conB.AuditItem(conA.Inventory[slotA], slotB) && conA.AuditItem(conB.Inventory[slotB], slotA);

        public static void HandleUnavailableInventoryAction(Player player, Item item, int slotId, Random random, IContainer container)
        {
            var bag = new Container(player.GameServer, SOULBOUND_LOOT_BAG_TYPE, 60000, true)
            {
                BagOwners = new[] { player.AccountId }
            };
            bag.Inventory[0] = container.Inventory[slotId];
            bag.Inventory.Data[0] = container.Inventory.Data[slotId];
            bag.Move(player.X + (float)((random.NextDouble() * 2 - 1) * 0.5), player.Y + (float)((random.NextDouble() * 2 - 1) * 0.5));
            bag.Size = 75;
            player.World.EnterWorld(bag);
        }
    }
}
