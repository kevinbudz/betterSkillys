using System;
using System.Linq;
using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.net.handlers
{
    public class LoadHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.LOAD;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var charId = rdr.ReadInt32();

            if (client.State != ProtocolState.Handshaked)
                return;

            var target = client.GameServer.WorldManager.GetWorld(client.TargetWorld);

            if (target == null)
            {
                client.SendFailure($"Unable to find world: {client.TargetWorld}", FailureMessage.MessageWithDisconnect);
                return;
            }

            client.Character = client.GameServer.Database.LoadCharacter(client.Account, charId);

            if (client.Character == null)
                client.SendFailure("Failed to load character", FailureMessage.MessageWithDisconnect);
            else if (client.Character.Dead)
                client.SendFailure("Character is dead", FailureMessage.MessageWithDisconnect);
            else
            {
                var x = 0;
                var y = 0;

                var spawnRegions = target.GetSpawnPoints();
                if (spawnRegions.Length > 0)
                {
                    var sRegion = Random.Shared.NextLength(spawnRegions);
                    x = sRegion.Key.X;
                    y = sRegion.Key.Y;
                }

                var player = client.Player = target.CreateNewPlayer(client, x, y);

                client.SendPacket(new CreateSuccessMessage(player.Id, client.Character.CharId));

                if(target is RealmWorld realm)
                    realm.RealmManager.OnPlayerEntered(player);

                client.State = ProtocolState.Ready;
                client.GameServer.ConnectionManager.ClientConnected(client);
            }
        }
    }
}
