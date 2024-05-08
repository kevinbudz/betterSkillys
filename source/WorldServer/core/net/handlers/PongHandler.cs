using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class PongHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.PONG;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var serial = rdr.ReadInt32();
            var time = rdr.ReadInt32();

            client?.Player?.Pong(tickTime, time, serial);
        }
    }
}
