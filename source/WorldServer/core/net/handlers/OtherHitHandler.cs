using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class OtherHitHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.OTHERHIT;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var bulletId = rdr.ReadInt32();
            var objectId = rdr.ReadInt32();
            var targetId = rdr.ReadInt32();

            client.Player.OtherHit(ref tickTime, time, bulletId, objectId, targetId);
        }
    }
}
