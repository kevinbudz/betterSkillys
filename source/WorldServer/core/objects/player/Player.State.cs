using Shared;
using System;
using System.IO;
using WorldServer.core.net.handlers;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        public void HandleIO(ref TickTime time)
        {
            while (IncomingMessages.TryDequeue(out var incomingMessage))
            {
                if (incomingMessage.Client.State == ProtocolState.Disconnected)
                    break;

                var handler = MessageHandlers.GetHandler(incomingMessage.MessageId);
                if (handler == null)
                {
                    incomingMessage.Client.PacketSpamAmount++;
                    if (incomingMessage.Client.PacketSpamAmount > 32)
                        incomingMessage.Client.Disconnect($"Packet Spam: {incomingMessage.Client.IpAddress}");
                    StaticLogger.Instance.Error($"Unknown MessageId: {incomingMessage.MessageId} - {Client.IpAddress}");
                    continue;
                }

                try
                {
                    NetworkReader rdr = null;
                    if (incomingMessage.Payload.Length != 0)
                        rdr = new NetworkReader(new MemoryStream(incomingMessage.Payload));
                    handler.Handle(incomingMessage.Client, rdr, ref time);
                    rdr?.Dispose();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error processing packet ({((incomingMessage.Client.Account != null) ? incomingMessage.Client.Account.Name : "")}, {incomingMessage.Client.IpAddress})\n{ex}");
                    if (ex is not EndOfStreamException)
                        StaticLogger.Instance.Error($"Error processing packet ({((incomingMessage.Client.Account != null) ? incomingMessage.Client.Account.Name : "")}, {incomingMessage.Client.IpAddress})\n{ex}");
                    incomingMessage.Client.SendFailure("An error occurred while processing data from your client.", FailureMessage.MessageWithDisconnect);
                }
            }
        }
    }
}
