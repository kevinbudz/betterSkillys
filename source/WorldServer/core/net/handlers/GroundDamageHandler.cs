using Shared;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class GroundDamageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.GROUNDDAMAGE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var time = rdr.ReadInt32();
            var position = Position.Read(rdr);

            var player = client.Player;
            if (player?.World == null)
                return;

            player.ForceGroundHit(tickTime, position, time);
        }
    }
}
