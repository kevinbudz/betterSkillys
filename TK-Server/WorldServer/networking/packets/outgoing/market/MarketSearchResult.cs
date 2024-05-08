using Shared;
using WorldServer.core.net.datas;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.networking.packets.outgoing.market
{
    public class MarketSearchResult : OutgoingMessage
    {
        public override MessageId MessageId => MessageId.MARKET_SEARCH_RESULT;

        public MarketData[] Results;
        public string Description;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write((short)Results.Length);
            for (int i = 0; i < Results.Length; i++)
            {
                Results[i].Write(wtr);
            }
            wtr.WriteUTF16(Description);
        }
    }
}
