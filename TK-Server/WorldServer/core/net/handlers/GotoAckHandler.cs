using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class GotoAckHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.GOTOACK;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            client.Player.GotoAckReceived();
        }
    }
}
