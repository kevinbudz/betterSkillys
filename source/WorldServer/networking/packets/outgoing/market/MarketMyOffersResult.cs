using Shared;
using WorldServer.core.net.datas;

namespace WorldServer.networking.packets.outgoing.market
{
    public class MarketMyOffersResult : OutgoingMessage
    {
        public override MessageId MessageId => MessageId.MARKET_MY_OFFERS_RESULT;

        public MarketData[] Results;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write((short)Results.Length);
            for (int i = 0; i < Results.Length; i++)
            {
                Results[i].Write(wtr);
            }
        }
    }
}
