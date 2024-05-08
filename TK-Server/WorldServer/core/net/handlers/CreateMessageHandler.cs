using Shared;
using Shared.database;
using WorldServer.core.objects;
using WorldServer.core.worlds.impl;
using WorldServer.networking.packets;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using Shared.database.character;
using System;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    public sealed class CreateMessageHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.CREATE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var classType = rdr.ReadUInt16();
            var skinType = rdr.ReadUInt16();

            if (client.State != ProtocolState.Handshaked)
                return;

            var status = client.GameServer.Database.CreateCharacter(client.Account, classType, skinType, out DbChar character);

            if (status == DbCreateStatus.ReachCharLimit)
            {
                client.SendFailure("Too many characters", FailureMessage.MessageWithDisconnect);
                return;
            }

            if (status == DbCreateStatus.SkinUnavailable)
            {
                client.SendFailure("Skin unavailable", FailureMessage.MessageWithDisconnect);
                return;
            }

            if (status == DbCreateStatus.Locked)
            {
                client.SendFailure("Class locked", FailureMessage.MessageWithDisconnect);
                return;
            }

            client.Character = character;

            var target = client.GameServer.WorldManager.GetWorld(client.TargetWorld);
            if (target == null)
                target = client.GameServer.WorldManager.GetWorld(-2); // return to nexus


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

            if (target is RealmWorld realm)
                realm.KingdomManager.OnPlayerEntered(player);

            client.State = ProtocolState.Ready;
            client.GameServer.ConnectionManager.ClientConnected(client);

            //client.Player?.PlayerUpdate.SendUpdate();
        }
    }
}
