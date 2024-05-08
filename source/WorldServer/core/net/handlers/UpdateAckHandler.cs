using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class UpdateAckHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.UPDATEACK;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
        }
    }
}
