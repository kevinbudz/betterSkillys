using Shared;
using System;
using WorldServer.core.net.datas;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class UseItemHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.USEITEM;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var slotObject = ObjectSlot.Read(rdr);
            var itemUsePos = Position.Read(rdr);
            var useType = rdr.ReadByte();

            var player = client.Player;
            if (player?.World == null)
                return;
            player.UseItem(time, tickTime, slotObject.ObjectId, slotObject.SlotId, itemUsePos, useType);
        }
    }
}
