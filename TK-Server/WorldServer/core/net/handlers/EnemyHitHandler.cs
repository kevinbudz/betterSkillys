using Shared;
using Shared.resources;
using System;
using WorldServer.core.objects;
using WorldServer.networking;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    public class EnemyHitHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.ENEMYHIT;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var bulletId = rdr.ReadInt32();
            var targetId = rdr.ReadInt32();
            var killed = rdr.ReadBoolean();

            var player = client.Player;

            player.EnemyHit(ref tickTime, time, bulletId, targetId, killed);
        }
    }
}
