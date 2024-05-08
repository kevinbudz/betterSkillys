using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class TradeAccepted : OutgoingMessage
    {
        public bool[] MyOffer { get; set; }
        public bool[] YourOffer { get; set; }

        public override MessageId MessageId => MessageId.TRADEACCEPTED;


        public override void Write(NetworkWriter wtr)
        {
            wtr.Write((short)MyOffer.Length);
            foreach (var i in MyOffer)
                wtr.Write(i);
            wtr.Write((short)YourOffer.Length);
            foreach (var i in YourOffer)
                wtr.Write(i);
        }
    }
}
