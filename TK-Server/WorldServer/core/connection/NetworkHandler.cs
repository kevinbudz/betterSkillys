using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Sockets;
using Shared;
using WorldServer.core.net.handlers;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.connection
{
    public sealed class NetworkSendHandler
    {
        enum SendState
        {
            Awaiting,
            Ready,
            Sending
        }

        private readonly Client Client;
        private readonly SocketAsyncEventArgs SocketAsyncEventArgs;
        private readonly object sendLock;
        private SendState sendState;
        private ConcurrentQueue<OutgoingMessage> Pending;

        public NetworkSendHandler(Client client, SocketAsyncEventArgs e)
        {
            Client = client;

            SocketAsyncEventArgs = e;
            SocketAsyncEventArgs.Completed += OnCompleted;

            sendLock = new object();
            sendState = SendState.Awaiting;
            Pending = new ConcurrentQueue<OutgoingMessage>();
        }

        public void SendMessage(OutgoingMessage message)
        {
            Pending.Enqueue(message);
            Tick();
        }

        public void SetSocket(Socket socket)
        {
            SocketAsyncEventArgs.AcceptSocket = socket;
            StartSend(SocketAsyncEventArgs);
        }

        private void StartSend(SocketAsyncEventArgs e)
        {
            if (Client?.State == ProtocolState.Disconnected)
                return;

            var s = (SendToken)e.UserToken;
            var bytesToSend = s.BytesAvailable > ConnectionListener.BUFFER_SIZE ? ConnectionListener.BUFFER_SIZE : s.BytesAvailable;

            e.SetBuffer(s.BufferOffset, bytesToSend);
            Buffer.BlockCopy(s.Data, s.BytesSent, e.Buffer, s.BufferOffset, bytesToSend);

            sendState = SendState.Sending;

            var willRaiseEvent = e.AcceptSocket.SendAsync(e);
            if (!willRaiseEvent)
                OnCompleted(null, e);
        }

        private void OnCompleted(object sender, SocketAsyncEventArgs e)
        {
            var s = (SendToken)e.UserToken;

            if (Client.State == ProtocolState.Disconnected)
            {
                s.Reset();
                return;
            }

            if (e.SocketError != SocketError.Success)
            {
                Client.Disconnect("Send SocketError = " + e.SocketError);
                return;
            }

            s.BytesSent += e.BytesTransferred;
            s.BytesAvailable -= s.BytesSent;

            if (s.BytesAvailable <= 0)
            {
                s.Reset();
                sendState = SendState.Awaiting;
                Tick();
                return;
            }

            StartSend(e);
        }

        public void Tick()
        {
            if (CanSendPacket(SocketAsyncEventArgs))
                StartSend(SocketAsyncEventArgs);
        }

        private bool CanSendPacket(SocketAsyncEventArgs e)
        {
            lock (sendLock)
            {
                if (sendState != SendState.Awaiting)
                    return false;

                var s = (SendToken)e.UserToken;
                s.Reset();

                while (Pending.TryDequeue(out var packet))
                {
                    var bytesWritten = packet.Write(s.Data, s.BytesAvailable);
                    if (!bytesWritten.HasValue)
                        continue;

                    if (bytesWritten == 0)
                    {
                        Pending.Enqueue(packet);
                        sendState = SendState.Ready;
                        return true;
                    }
                    s.BytesAvailable += bytesWritten.Value;
                }

                if (s.BytesAvailable <= 0)
                    return false;

                sendState = SendState.Ready;
                return true;
            }
        }

        public void Reset()
        {
            ((SendToken)SocketAsyncEventArgs.UserToken).Reset();
            Pending = new ConcurrentQueue<OutgoingMessage>();
            sendState = SendState.Awaiting;
        }
    }

    public sealed class NetworkReceiveHandler
    {
        private readonly Client Client;
        private readonly SocketAsyncEventArgs SocketAsyncEventArgs;

        public NetworkReceiveHandler(Client client, SocketAsyncEventArgs e)
        {
            Client = client;

            SocketAsyncEventArgs = e;
            SocketAsyncEventArgs.Completed += OnCompleted;
        }

        public void SetSocket(Socket socket)
        {
            SocketAsyncEventArgs.AcceptSocket = socket;
            StartReceive(SocketAsyncEventArgs);
        }

        private void StartReceive(SocketAsyncEventArgs e)
        {
            if (Client.State == ProtocolState.Disconnected)
                return;

            e.SetBuffer(e.Offset, ConnectionListener.BUFFER_SIZE);

            bool willRaiseEvent;
            try
            {
                willRaiseEvent = e.AcceptSocket.ReceiveAsync(e);
            }
            catch (Exception exception)
            {
                Client.Disconnect($"[{Client.Account?.Name}:{Client.Account?.AccountId} {Client.IpAddress}] {exception}");
                return;
            }

            if (!willRaiseEvent)
                OnCompleted(null, e);
        }

        private void OnCompleted(object sender, SocketAsyncEventArgs e)
        {
            var r = (ReceiveToken)e.UserToken;

            if (Client.State == ProtocolState.Disconnected)
            {
                r.Reset();
                return;
            }

            if (e.SocketError != SocketError.Success)
            {
                var msg = "";
                if (e.SocketError != SocketError.ConnectionReset)
                    msg = "Receive SocketError = " + e.SocketError;

                Client.Disconnect(msg);
                return;
            }

            var bytesNotRead = e.BytesTransferred;
            if (bytesNotRead == 0)
            {
                Client.Disconnect("bytesNotRead == 0");
                return;
            }

            while (bytesNotRead > 0)
            {
                bytesNotRead = ReadPacketBytes(e, r, bytesNotRead);

                if (r.BytesRead == ReceiveToken.PrefixLength)
                {
                    r.PacketLength = IPAddress.NetworkToHostOrder(BitConverter.ToInt32(r.PacketBytes, 0));

                    if (r.PacketLength == 1014001516)
                    {
                        SendPolicyFile();
                        r.Reset();
                        break;
                    }

                    if (r.PacketLength < ReceiveToken.PrefixLength || r.PacketLength > ConnectionListener.BUFFER_SIZE)
                    {
                        r.Reset();
                        break;
                    }
                }

                if (r.BytesRead == r.PacketLength)
                {
                    if (Client.IsReady())
                    {
                        var id = r.GetPacketId();
                        var payload = r.GetPacketBody();
                        if (Client.Player == null) // read it instantly if there is no player otherwise we will append it to the world instance
                        {
                            if (id != MessageId.HELLO && id != MessageId.LOAD && id != MessageId.CREATE)
                            {
                                Console.WriteLine(id + " Received with null player");
                                Client.Disconnect("Invalid State");
                                continue;
                            }

                            var handler = MessageHandlers.GetHandler(id);
                            if (handler == null)
                            {
                                Client.PacketSpamAmount++;
                                if (Client.PacketSpamAmount > 32)
                                    Client.Disconnect($"Packet Spam: {Client.IpAddress}");
                                StaticLogger.Instance.Error($"Unknown MessageId: {id} - {Client.IpAddress}");
                                continue;
                            }

                            // todo redo
                            try
                            {
                                NetworkReader rdr = null;
                                if (payload.Length != 0)
                                    rdr = new NetworkReader(new MemoryStream(payload));
                                var time = new TickTime();
                                handler.Handle(Client, rdr, ref time);
                                rdr?.Dispose();
                            }
                            catch (Exception exx)
                            {
                                Console.WriteLine($"Error processing packet ({(Client.Account != null ? Client.Account.Name : "")}, {Client.IpAddress})\n{exx}");
                                if (!(exx is EndOfStreamException))
                                    StaticLogger.Instance.Error($"Error processing packet ({(Client.Account != null ? Client.Account.Name : "")}, {Client.IpAddress})\n{exx}");
                                Client.Disconnect($"Read Error for packet: {id}");
                            }
                        }
                        else
                            Client.Player.IncomingMessages.Enqueue(new InboundBuffer(Client, id, payload));
                    }
                    r.Reset();
                }
            }

            StartReceive(e);
        }

        private static int ReadPacketBytes(SocketAsyncEventArgs e, ReceiveToken r, int bytesNotRead)
        {
            var offset = r.BufferOffset + e.BytesTransferred - bytesNotRead;
            var remainingBytes = r.PacketLength - r.BytesRead;

            if (bytesNotRead < remainingBytes)
            {
                Buffer.BlockCopy(e.Buffer, offset, r.PacketBytes, r.BytesRead, bytesNotRead);
                r.BytesRead += bytesNotRead;
                return 0;
            }

            Buffer.BlockCopy(e.Buffer, offset, r.PacketBytes, r.BytesRead, remainingBytes);

            r.BytesRead = r.PacketLength;
            return bytesNotRead - remainingBytes;
        }

        private void SendPolicyFile()
        {
            Console.WriteLine("SendPolicyFile");
            try
            {
                var s = new NetworkStream(Client.Socket);
                var wtr = new NetworkWriter(s);
                wtr.WriteNullTerminatedString(
                    @"<cross-domain-policy>" +
                    @"<allow-access-from domain=""*"" to-ports=""*"" />" +
                    @"</cross-domain-policy>");
                wtr.Write((byte)'\r');
                wtr.Write((byte)'\n');
            }
            catch (Exception e)
            {
                StaticLogger.Instance.Error(e.ToString());
            }
        }

        public void Reset()
        {
            ((ReceiveToken)SocketAsyncEventArgs.UserToken).Reset();
        }
    }

    public sealed class NetworkHandler
    {
        private readonly Client Client;
        private readonly NetworkSendHandler NetworkSendHandler;
        private readonly NetworkReceiveHandler NetworkReceiveHandler;

        public NetworkHandler(Client client, SocketAsyncEventArgs send, SocketAsyncEventArgs receive)
        {
            Client = client;

            NetworkSendHandler = new NetworkSendHandler(client, send);
            NetworkReceiveHandler = new NetworkReceiveHandler(client, receive);
        }

        public void SetSocket(Socket socket)
        {
            Client.State = ProtocolState.Connected;

            NetworkSendHandler.SetSocket(socket);
            NetworkReceiveHandler.SetSocket(socket);
        }

        public void SendPacket(OutgoingMessage pkt) => NetworkSendHandler.SendMessage(pkt);

        public void SendPackets(IEnumerable<OutgoingMessage> pkts)
        {
            foreach (var pkt in pkts)
                SendPacket(pkt);
        }

        public void Reset()
        {
            NetworkSendHandler.Reset();
            NetworkReceiveHandler.Reset();
        }
    }
}
