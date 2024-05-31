using Shared;
using System;
using System.Collections.Generic;
using WorldServer.networking;
using WorldServer.utils;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.net.datas;
using System.Runtime.CompilerServices;

namespace WorldServer.core.net.handlers
{
    public class MoveHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.MOVE;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var tickId = rdr.ReadInt32();
            var time = rdr.ReadInt32();
            var newX = rdr.ReadSingle();
            var newY = rdr.ReadSingle();

            var len = rdr.ReadInt16();
            if(len < 0 || len >= 16)
            {
                client.Disconnect("Invalid Records");
                return;
            }

            var moveRecords = new TimedPosition[len];
            for (var i = 0; i < moveRecords.Length; i++)
                moveRecords[i] = TimedPosition.Read(rdr);

            var player = client.Player;

            player.HandleProjectileDetection(time, newX, newY, ref moveRecords);

            if (newX != -1 && newX != player.X || newY != -1 && newY != player.Y)
            {
                if (!player.World.Map.Contains(newX, newY))
                {
                    player.Client.Disconnect("Out of map bounds");
                    return;
                }

                if (!player.World.IsPassable(newX, newY))
                {
                    StaticLogger.Instance.Info($"{player.Name} is walking on an occupied tile. {newX}, {newY}");
                    player.Client.Disconnect("NoClipping");
                    return;
                }

                if(!player.Client.Account.Admin)
                    if (player.Stars <= 2 && player.Quest != null && player.DistTo(newX, newY) > 50 && player.Quest.DistTo(newX, newY) < 0.25)
                    {
                        StaticLogger.Instance.Warn($"{player.Name} was caught teleporting directly to a quest, uh oh");
                        player.Client.Disconnect("Unexpected Error Occured");
                        return;
                    }

                // s = d / t

                // calculate the distance

                // d = s * t;

                // time between this move and last move
                //var dt = time - player.LastClientTime;

                //// time in seconds
                //var moveTime = dt / 1000.0;

                //// distance
                //var distance = player.DistTo(newX, newY);

                //var multiplier = player.World.GameServer.Resources.GameData.Tiles[player.World.Map[(int)newX, (int)newY].TileId].Speed;

                //// speed
                //var clientSpeed = distance / moveTime;
                //var serverSpeed = player.Stats.GetSpeed() * multiplier;

                //// only check if canTp
                //if (clientSpeed > serverSpeed)
                //{
                //    var delta = clientSpeed - serverSpeed;
                //    if (delta > 0.5 * clientSpeed && delta < 30.0 * clientSpeed) // tollerance
                //    {
                //        if(delta < 50)
                //            foreach (var other in player.World.Players.Values)
                //                if (other.IsAdmin || other.IsModerator)
                //                {
                //                    if (delta > 1.0)
                //                        other.SendInfo($"Warning: [{player.Name}] {player.AccountId}-{player.Client.Character.CharId} is moving exceptionally faster than expected! ({delta} | tolerance: 0.5)");
                //                    else
                //                        other.SendInfo($"Warning: [{player.Name}] {player.AccountId}-{player.Client.Character.CharId} is faster than expected! ({delta} | tolerance: 0.5)");
                //                }

                //        StaticLogger.Instance.Warn($"[{player.Name}] {player.AccountId}-{player.Client.Character.CharId} is moving faster than expected! {delta} ({delta} | tolerance: 0.5)");
                //    }
                //}

                player.Move(newX, newY);
                player.UpdateTiles();
            }

            player.MoveReceived(tickTime, time, tickId);
        }
    }
}
