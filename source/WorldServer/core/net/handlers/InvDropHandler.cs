using Shared;
using System;
using System.Linq;
using WorldServer.core.miscfile;
using WorldServer.core.objects.containers;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.utils;
using WorldServer.core.objects;
using WorldServer.networking.packets.outgoing;
using static WorldServer.core.objects.Player;
using WorldServer.core.worlds;
using WorldServer.core.net.datas;

namespace WorldServer.core.net.handlers
{
    public class InvDropHandler : IMessageHandler
    {
        private const ushort normBag = 0x0500;
        private const ushort soulBag = 0x0503;

        public override MessageId MessageId => MessageId.INVDROP;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var slot = ObjectSlot.Read(rdr);

            var player = client.Player;
            if (player == null || player.World == null || player.TradeTarget != null || player.Client == null)
                return;

            //if (player.Stars < 2 && player.Rank < 10)
            //{
            //    if (!(player.World is VaultWorld))
            //    {
            //        player.SendHelp("To use this feature you need 2 stars or D-1 rank.");
            //        player.Client.SendPacket(new InvResult() { Result = 1 });
            //        return;
            //    }
            //}

            if (player.IsInMarket && player.World is NexusWorld)
            {
                player.ForceUpdate(slot.SlotId);
                player.SendInfo("You cannot drop items inside the marketplace");
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            IContainer con;

            // container isn't always the player's inventory, it's given by the SlotObject's ObjectId
            if (slot.ObjectId != player.Id)
            {
                if (player.World.GetEntity(slot.ObjectId) is Player)
                {
                    player.Client.SendPacket(new InvResult() { Result = 1 });
                    return;
                }

                con = player.World.GetEntity(slot.ObjectId) as IContainer;
            }
            else
                con = player;

            if (slot.ObjectId == player.Id && player.PotionStacks.Any(stack => stack.Slot == slot.SlotId))
            {
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return; // don't allow dropping of stacked items
            }

            if (con?.Inventory[slot.SlotId] == null)
            {
                //give proper error
                player.Client.SendPacket(new InvResult() { Result = 1 });
                return;
            }

            var item = con.Inventory[slot.SlotId];
            var data = con.Inventory.Data[slot.SlotId];

            if (con is GiftChest)
            {
                var trans = player.GameServer.Database.Conn.CreateTransaction();

                player.GameServer.Database.RemoveGift(player.Client.Account, item.ObjectType, trans);

                if (!trans.Execute())
                {
                    player.Client.SendPacket(new InvResult() { Result = 1 });
                    return;
                }
            }

            var isSoulbound = player.IsAdmin || item.Soulbound;
            var container = new Container(player.GameServer, isSoulbound ? soulBag : normBag, 60000, true);

            if (isSoulbound) //TODOS LOS ITEMS SE DROPEAN EN SOULBOUND BAG
                container.BagOwners = new int[] { player.AccountId };

            // init container
            container.Inventory[0] = item;
            container.Inventory.Data[0] = data;
            container.Move(player.X + (float)((Random.Shared.NextDouble() * 2 - 1) * 0.5), player.Y + (float)((Random.Shared.NextDouble() * 2 - 1) * 0.5));
            container.SetDefaultSize(75);

            player.World.EnterWorld(container);

            // send success
            con.Inventory[slot.SlotId] = null;
            con.Inventory.Data[slot.SlotId] = null;

            player.Client.SendPacket(new InvResult() { Result = 0 });
        }
    }
}
