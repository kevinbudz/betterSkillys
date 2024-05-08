using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using WorldServer.networking;
using WorldServer.utils;

namespace WorldServer.core.connection
{
    #region Tokens

    public sealed class SendToken
    {
        public readonly int BufferOffset;

        public int BytesAvailable;
        public int BytesSent;
        public byte[] Data;

        public SendToken(int offset)
        {
            BufferOffset = offset;
            Data = new byte[0x100000];
        }

        public void Reset()
        {
            BytesAvailable = 0;
            BytesSent = 0;
        }
    }

    public sealed class ReceiveToken
    {
        public const int PrefixLength = 5;

        public readonly int BufferOffset;

        public int BytesRead;
        public byte[] PacketBytes;
        public int PacketLength;

        public ReceiveToken(int offset)
        {
            BufferOffset = offset;
            PacketBytes = new byte[ConnectionListener.BUFFER_SIZE];
            PacketLength = PrefixLength;
        }

        public byte[] GetPacketBody()
        {
            if (BytesRead < PrefixLength)
                throw new Exception("Packet prefix not read yet.");

            var packetBody = new byte[PacketLength - PrefixLength];
            Array.Copy(PacketBytes, PrefixLength, packetBody, 0, packetBody.Length);
            return packetBody;
        }

        public MessageId GetPacketId()
        {
            if (BytesRead < PrefixLength)
                throw new Exception("Packet id not read yet.");
            return (MessageId)PacketBytes[4];
        }

        public void Reset()
        {
            PacketLength = PrefixLength;
            BytesRead = 0;
        }
    }

    public enum SendState
    {
        Awaiting,
        Ready,
        Sending
    }

    #endregion Tokens

    public sealed class ConnectionListener
    {
        public const int BUFFER_SIZE = ushort.MaxValue * 3;
        private const int BACKLOG = 100;
        private const int MAX_SIMULTANEOUS_ACCEPT_OPS = 10;
        private const int OPS_TO_PRE_ALLOCATE = 2;

        private GameServer GameServer;
        private BufferManager BuffManager;
        private ClientPool ClientPool;
        private SocketAsyncEventArgsPool EventArgsPoolAccept;
        private Semaphore MaxConnectionsEnforcer;

        public ConnectionListener(GameServer gameServer)
        {
            GameServer = gameServer;

            Port = GameServer.Configuration.serverInfo.port;
            MaxConnections = GameServer.Configuration.serverSettings.maxConnections;

            BuffManager = new BufferManager((MaxConnections + 1) * BUFFER_SIZE * OPS_TO_PRE_ALLOCATE, BUFFER_SIZE);
            EventArgsPoolAccept = new SocketAsyncEventArgsPool(MAX_SIMULTANEOUS_ACCEPT_OPS);
            ClientPool = new ClientPool(MaxConnections + 1);
            MaxConnectionsEnforcer = new Semaphore(MaxConnections, MaxConnections);
        }

        private Socket ListenSocket { get; set; }
        private int MaxConnections { get; }
        private int Port { get; }

        public void Initialize()
        {
            BuffManager.InitBuffer();

            for (var i = 0; i < MAX_SIMULTANEOUS_ACCEPT_OPS; i++)
                EventArgsPoolAccept.Push(CreateNewAcceptEventArgs());

            for (var i = 0; i < MaxConnections + 1; i++)
            {
                var send = CreateNewSendEventArgs();
                var receive = CreateNewReceiveEventArgs();
                ClientPool.Push(new Client(this, GameServer, send, receive));
            }
        }

        public void Start()
        {
            var localEndPoint = new IPEndPoint(IPAddress.Any, Port);
            ListenSocket = new Socket(localEndPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            ListenSocket.Bind(localEndPoint);
            ListenSocket.Listen(BACKLOG);

            StartAccept();
        }

        private void AcceptEventArg_Completed(object sender, SocketAsyncEventArgs e) => ProcessAccept(e);

        private SocketAsyncEventArgs CreateNewAcceptEventArgs()
        {
            var acceptEventArg = new SocketAsyncEventArgs();
            acceptEventArg.Completed += AcceptEventArg_Completed;
            return acceptEventArg;
        }

        private SocketAsyncEventArgs CreateNewReceiveEventArgs()
        {
            var eventArgs = new SocketAsyncEventArgs();
            BuffManager.SetBuffer(eventArgs);
            eventArgs.UserToken = new ReceiveToken(eventArgs.Offset);
            return eventArgs;
        }

        private SocketAsyncEventArgs CreateNewSendEventArgs()
        {
            var eventArgs = new SocketAsyncEventArgs();
            BuffManager.SetBuffer(eventArgs);
            eventArgs.UserToken = new SendToken(eventArgs.Offset);
            return eventArgs;
        }

        private void HandleBadAccept(SocketAsyncEventArgs acceptEventArgs)
        {
            acceptEventArgs.AcceptSocket.Close();
            EventArgsPoolAccept.Push(acceptEventArgs);
        }

        public void Disable()
        {
            Console.WriteLine("[ConnectionListener] Disabled");
            try
            {
                ListenSocket.Shutdown(SocketShutdown.Both);
            }
            catch (Exception e)
            {
                if (!(e is SocketException se) || se.SocketErrorCode != SocketError.NotConnected)
                    StaticLogger.Instance.Error(e);
            }
            ListenSocket.Close();
        }

        private void ProcessAccept(SocketAsyncEventArgs acceptEventArgs)
        {
            if (acceptEventArgs.SocketError != SocketError.Success)
            {
                StartAccept();
                HandleBadAccept(acceptEventArgs);
                return;
            }

            acceptEventArgs.AcceptSocket.NoDelay = true;
            ClientPool.Pop().SetSocket(acceptEventArgs.AcceptSocket);

            acceptEventArgs.AcceptSocket = null;
            EventArgsPoolAccept.Push(acceptEventArgs);

            StartAccept();
        }

        private void StartAccept()
        {
            SocketAsyncEventArgs acceptEventArg;

            if (EventArgsPoolAccept.Count > 1)
                try
                {
                    acceptEventArg = EventArgsPoolAccept.Pop();
                }
                catch
                {
                    acceptEventArg = CreateNewAcceptEventArgs();
                }
            else
                acceptEventArg = CreateNewAcceptEventArgs();

            _ = MaxConnectionsEnforcer.WaitOne();

            try
            {
                var willRaiseEvent = ListenSocket.AcceptAsync(acceptEventArg);
                if (!willRaiseEvent)
                    ProcessAccept(acceptEventArg);
            }
            catch
            {
            }
        }

        #region Disconnect - Shutdown

        public void Disconnect(Client client)
        {
            try
            {
                client.Socket.Shutdown(SocketShutdown.Both);
            }
            catch (Exception e)
            {
                var se = e as SocketException;
                if (se == null || se.SocketErrorCode != SocketError.NotConnected)
                    StaticLogger.Instance.Error($"{se.Message} {se.StackTrace}");
            }

            client.Socket.Close();
            client.Reset();

            ClientPool.Push(client);

            try
            {
                MaxConnectionsEnforcer.Release();
            }
            catch (SemaphoreFullException e)
            {
                // This should happen only on server restart
                // If it doesn't need to handle the problem somwhere else
                StaticLogger.Instance.Error($"MaxConnectionsEnforcer.Release(): {e.StackTrace}");
            }
        }

        public void Shutdown()
        {
            foreach (var client in GameServer.ConnectionManager.Clients)
                client.Key.Disconnect("Shutdown Server");

            while (EventArgsPoolAccept.Count > 0)
            {
                var eventArgs = EventArgsPoolAccept.Pop();
                eventArgs.Dispose();
            }

            while (ClientPool.Count > 0)
            {
                var client = ClientPool.Pop();
                client.Disconnect("Shutdown Server");
            }
        }

        #endregion Disconnect - Shutdown
    }
}
