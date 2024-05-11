using System;
using System.Threading.Tasks;
using Shared;
using Shared.resources;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.utils;

namespace WorldServer.core.net.handlers
{
    public sealed class BreakdownSlotMessage : IMessageHandler
    {
        public override MessageId MessageId => MessageId.BreakDownSlot;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var slot = rdr.ReadByte();

            if(slot < 4)
            {
                client.Disconnect("Invalid Breakdown Slot");
                return;
            }

            var player = client.Player;

            var item = player.Inventory[slot];
            if (item == null)
            {
                client.Disconnect("Trying to breakdown empty slot");
                return;
            }

            if(item.BreakDownData == null)
            {
                player.SendError("This item can't be broken down");
                return;
            }

            if (item.BreakDownData.Fame > 0)
            {
                var fameToGive = item.BreakDownData.Fame;

                var db = client.GameServer.Database;
                var acc = player.Client.Account;
                var trans = db.Conn.CreateTransaction();
                var t1 = db.UpdateCurrency(acc, fameToGive, CurrencyType.Fame, trans);
                var t2 = trans.ExecuteAsync();

                _ = Task.WhenAll(t1, t2).ContinueWith(t =>
                {
                    if (t.IsCanceled)
                    {
                        player.SendError("Unable to sell item");
                        return;
                    }

                    player.CurrentFame = acc.Fame;

                    acc.Reload();

                    player.Inventory[slot] = null;

                    player.SendInfo($"{item.DisplayName} was broken down into {fameToGive} fame");
                }).ContinueWith(e => StaticLogger.Instance.Error(e.Exception.InnerException.ToString()), TaskContinuationOptions.OnlyOnFaulted);

                return;
            }

            if (item.BreakDownData.ItemName != null)
            {
                if (!client.GameServer.Resources.GameData.IdToObjectType.TryGetValue(item.BreakDownData.ItemName, out var itemType))
                {
                    player.SendError("Unable to breakdown item");
                    return;
                }

                if (!client.GameServer.Resources.GameData.Items.TryGetValue(itemType, out var newItem))
                {
                    player.SendError("Unable to breakdown item");
                    return;
                }

                player.Inventory[slot] = newItem;
                player.ForceUpdate(slot);

                player.SendInfo($"{item.DisplayName} was broken down into {newItem.DisplayName}");
            }
        }
    }
}
