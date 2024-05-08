using System;
using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class PlayerHitHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.PLAYERHIT;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var bulletId = rdr.ReadInt32();
            var objectId = rdr.ReadInt32();

            client.Player.PlayerHit(bulletId, objectId);
        }
    }
}
