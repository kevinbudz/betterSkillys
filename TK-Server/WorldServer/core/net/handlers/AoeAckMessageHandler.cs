using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public sealed class AoeAckMessageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.AOEACK;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var x = rdr.ReadSingle();
            var y = rdr.ReadSingle();

        }
    }
}
