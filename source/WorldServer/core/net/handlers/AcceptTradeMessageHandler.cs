using System.Collections.Generic;
using System.Linq;
using System.Text;
using Shared;
using Shared.database.character.inventory;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.objects.inventory;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.net.handlers
{
    public sealed class AcceptTradeMessageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.ACCEPTTRADE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var myOffer = new bool[rdr.ReadInt16()];
            for (int i = 0; i < myOffer.Length; i++)
                myOffer[i] = rdr.ReadBoolean();

            var yourOffer = new bool[rdr.ReadInt16()];
            for (int i = 0; i < myOffer.Length; i++)
                yourOffer[i] = rdr.ReadBoolean();

            var player = client.Player;
            if (player == null || client?.Player?.World is TestWorld)
                return;

            if (player.tradeAccepted)
                return;

            var tradeTarget = player.tradeTarget;

            player.trade = myOffer;
            if (tradeTarget.trade.SequenceEqual(yourOffer))
            {
                player.tradeAccepted = true;
                tradeTarget.Client.SendPacket(new TradeAccepted()
                {
                    MyOffer = tradeTarget.trade,
                    YourOffer = player.trade
                });

                if (player.tradeAccepted && tradeTarget.tradeAccepted)
                {
                    if (!(player.IsAdmin && tradeTarget.IsAdmin))
                        if (player.IsAdmin || tradeTarget.IsAdmin)
                        {
                            tradeTarget.CancelTrade();
                            player.CancelTrade();
                            return;
                        }
                    DoTrade(player);
                }
            }
        }

        private void DoTrade(Player player)
        {
            var failedMsg = "Error while trading. Trade unsuccessful.";
            var msg = "Trade Successful!";
            var thisItems = new List<(Item, ItemData)>();
            var targetItems = new List<(Item, ItemData)>();

            var tradeTarget = player.tradeTarget;

            // make sure trade targets are valid
            if (tradeTarget == null || player.World == null || tradeTarget.World == null || player.World != tradeTarget.World)
            {
                TradeDone(player, tradeTarget, failedMsg);
                return;
            }

            if (!player.tradeAccepted || !tradeTarget.tradeAccepted)
                return;

            var pInvTrans = player.Inventory.CreateTransaction();
            var tInvTrans = tradeTarget.Inventory.CreateTransaction();

            var pInvDataTrans = player.Inventory.CreateDataTransaction();
            var tInvDataTrans = player.Inventory.CreateDataTransaction();

            for (int i = 4; i < player.trade.Length; i++)
                if (player.trade[i])
                {
                    thisItems.Add((player.Inventory[i], player.Inventory.Data[i]));
                    pInvTrans[i] = null;
                }

            for (int i = 4; i < tradeTarget.trade.Length; i++)
                if (tradeTarget.trade[i])
                {
                    targetItems.Add((tradeTarget.Inventory[i], tradeTarget.Inventory.Data[i]));
                    tInvTrans[i] = null;
                }

            // move thisItems -> tradeTarget
            for (var i = 0; i < 12; i++)
                for (var j = 0; j < thisItems.Count; j++)
                {
                    if (tradeTarget.SlotTypes[i] == 0 && tInvTrans[i] == null || thisItems[j].Item1 != null && tradeTarget.SlotTypes[i] == thisItems[j].Item1.SlotType && tInvTrans[i] == null)
                    {
                        tInvTrans[i] = thisItems[j].Item1;
                        tInvDataTrans[i] = thisItems[j].Item2;
                        thisItems.Remove(thisItems[j]);
                        break;
                    }
                }

            // move tradeItems -> this
            for (var i = 0; i < 12; i++)
                for (var j = 0; j < targetItems.Count; j++)
                {
                    if (player.SlotTypes[i] == 0 && pInvTrans[i] == null || targetItems[j].Item1 != null && player.SlotTypes[i] == targetItems[j].Item1.SlotType && pInvTrans[i] == null)
                    {
                        pInvTrans[i] = targetItems[j].Item1;
                        pInvDataTrans[i] = targetItems[j].Item2;
                        targetItems.Remove(targetItems[j]);
                        break;
                    }
                }

            LogTrade(player, tradeTarget, thisItems);
            LogTrade(tradeTarget, player, targetItems);

            // save
            if (!Inventory.DatExecute(pInvDataTrans, tInvDataTrans))
            {
                TradeDone(player, tradeTarget, failedMsg);
                return;
            }
            if (!Inventory.Execute(pInvTrans, tInvTrans))
            {
                TradeDone(player, tradeTarget, failedMsg);
                return;
            }

            // check for lingering items
            if (thisItems.Count > 0 || targetItems.Count > 0)
            {
                msg = "An error occured while trading! Some items were lost!";
            }
            
            // trade successful, notify and save
            TradeDone(player, tradeTarget, msg);
        }

        private void LogTrade(Player player, Player tradeTarget, List<(Item, ItemData)> items)
        {
            try
            {
                var sb = new StringBuilder($"[{player.World.IdName}({player.World.Id})] ");
                sb.Append($"<{player.Stars} {player.Name} {player.AccountId}-{player.Client.Character.CharId}> traded ");
                //sb.Append(string.Join(", ", items.Select(_ => _.Item1.DisplayId ?? _.Item1.ObjectId))); // todo fix
                sb.Append($" to <{tradeTarget.Stars} {tradeTarget.Name} {tradeTarget.AccountId}-{tradeTarget.Client.Character.CharId}>");
                StaticLogger.Instance.Info(sb.ToString());
            }
            catch
            {
                System.Console.WriteLine($"<{player.Name} {player.AccountId}-{player.Client.Character.CharId}> Trade Log Error");
            }
        }

        private void TradeDone(Player player, Player tradeTarget, string msg)
        {
            player.Client.SendPacket(new TradeDone
            {
                Code = 1,
                Description = msg
            });

            if (tradeTarget != null)
            {
                tradeTarget.Client.SendPacket(new TradeDone
                {
                    Code = 1,
                    Description = msg
                });
            }

            player.ResetTrade();
        }
    }
}
