using Shared;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.networking.packets.outgoing.market
{
    public class MarketAddResult : OutgoingMessage
    {
        public override MessageId MessageId => MessageId.MARKET_ADD_RESULT;

        public const int INVALID_UPTIME = 0;
        public const int SLOT_IS_NULL = 1;
        public const int ITEM_IS_SOULBOUND = 2;
        public const int INVALID_PRICE = 3;
        public const int INVALID_CURRENCY = 4;

        public int Code;
        public string Description;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Code);
            wtr.WriteUTF16(Description);
        }
    }
}
