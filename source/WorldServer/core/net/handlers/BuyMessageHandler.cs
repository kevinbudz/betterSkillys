using Shared;
using WorldServer.core.objects.vendors;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.net.handlers
{
    public sealed class BuyMessageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.BUY;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var objectId = rdr.ReadInt32();

            var player = client.Player;
            if (player?.World == null)
                return;

            var obj = player.World.GetEntity(objectId) as SellableObject;
            obj?.Buy(player);

            if (obj == null)
                player.Client.SendPacket(new BuyResultMessage
                {
                    Result = 1,
                    ResultString = $"Purchase Error: {BuyResult.TransactionFailed.GetDescription()}"
                });
        }
    }
}
