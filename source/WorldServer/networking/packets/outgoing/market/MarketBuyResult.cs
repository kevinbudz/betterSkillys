using Shared;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.networking.packets.outgoing.market
{
    public class MarketBuyResult : OutgoingMessage
    {
        public override MessageId MessageId => MessageId.MARKET_BUY_RESULT;

        public const int BOUGHT = -1;
        public const int ERROR = 1;

        public int Code;
        public string Description;
        public int OfferId;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Code);
            wtr.WriteUTF16(Description);
            wtr.Write(OfferId);
        }
    }
}
