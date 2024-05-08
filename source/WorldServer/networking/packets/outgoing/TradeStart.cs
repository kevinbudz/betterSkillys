using Shared;
using WorldServer.core.net.datas;

namespace WorldServer.networking.packets.outgoing
{
    public class TradeStart : OutgoingMessage
    {
        public TradeItem[] MyItems { get; set; }
        public string YourName { get; set; }
        public TradeItem[] YourItems { get; set; }

        public override MessageId MessageId => MessageId.TRADESTART;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write((short)MyItems.Length);
            foreach (var i in MyItems)
                i.Write(wtr);

            wtr.WriteUTF16(YourName);
            wtr.Write((short)YourItems.Length);
            foreach (var i in YourItems)
                i.Write(wtr);
        }
    }
}
