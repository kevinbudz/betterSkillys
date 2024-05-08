using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class SquareHitHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.SQUAREHIT;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var bulletId = rdr.ReadInt32();
            var objectId = rdr.ReadInt32();

            client.Player.SquareHit(ref tickTime, time, bulletId, objectId);
        }
    }
}
