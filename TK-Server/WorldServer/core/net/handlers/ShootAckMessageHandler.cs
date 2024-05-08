using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public sealed class ShootAckMessageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.SHOOTACK;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            client.Player.ShootAck(time);
        }
    }
}
