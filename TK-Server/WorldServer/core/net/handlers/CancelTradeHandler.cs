using Shared;
using Shared.database;
using Shared.resources;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.objects.vendors;
using WorldServer.networking.packets;
using WorldServer.networking.packets.outgoing;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    public sealed class CancelTradeHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.CANCELTRADE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var player = client.Player;
            if (player == null || client?.Player?.World is TestWorld)
                return;
            player.CancelTrade();
        }
    }
}
