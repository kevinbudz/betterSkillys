using Shared;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.networking.packets.outgoing.market
{
    public class MarketRemoveResult : OutgoingMessage
    {
        public override MessageId MessageId => MessageId.MARKET_REMOVE_RESULT;

        public const int NOT_YOUR_ITEM = 0;
        public const int ITEM_DOESNT_EXIST = 1;

        public int Code;
        public string Description;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Code);
            wtr.WriteUTF16(Description);
        }
    }
}
