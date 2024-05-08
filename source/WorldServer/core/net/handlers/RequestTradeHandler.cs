using Shared;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class RequestTradeHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.REQUESTTRADE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var name = rdr.ReadUTF16();

            if (client.Player == null || client?.Player?.World is TestWorld)
                return;

            client.Player.RequestTrade(name);
        }
    }
}
