using NLog;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using Shared.isc.data;

namespace Shared.isc
{
    public class ISManager : InterServerChannel, IDisposable
    {
        public EventHandler NewServer;
        public EventHandler ServerPing;
        public EventHandler ServerQuit;

        private const int PingPeriod = 2000;
        private const int ServerTimeout = 30000;

        private static readonly string AppEngineTitleFormat = string.Format("[App] Servers: {0} | Connections: {1} of {2}",
            ISTextKeys.SERVER_AMOUNT,
            ISTextKeys.CONNECTIONS,
            ISTextKeys.TOTAL_CONNECTIONS
        );

        private static readonly string GameServerTitleFormat = string.Format("[WorldServer] Name: {0} | Connections: {1} of {2} | Access: {3}",
            ISTextKeys.SERVER_NAME,
            ISTextKeys.CONNECTIONS,
            ISTextKeys.TOTAL_CONNECTIONS,
            ISTextKeys.GAME_ACCESS
        );

        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private readonly bool _isApp;

        private string _accessType;
        private string _consoleTitlePattern;
        private object _dicLock = new object();
        private long _lastPing;
        private Dictionary<string, int> _lastUpdateTime = new Dictionary<string, int>();
        private Dictionary<string, ServerInfo> _servers = new Dictionary<string, ServerInfo>();
        private ServerConfig _settings;
        private System.Timers.Timer _tmr = new System.Timers.Timer(PingPeriod);
        public Action OnTick;

        public ISManager(ISubscriber subscriber, ServerConfig settings, bool isApp = false) : base(subscriber, settings.serverInfo.instanceId)
        {
            _settings = settings;
            _isApp = isApp;

            if (isApp)
            {
                _consoleTitlePattern = AppEngineTitleFormat;
                _accessType = "any";
            }
            else
            {
                _consoleTitlePattern = GameServerTitleFormat;
                _accessType = _settings.serverInfo.adminOnly ? "Admin" : _settings.serverSettings.supporterOnly ? "Supporter" : "Public";
            }

            // listen to "network" communications
            AddHandler<NetworkMsg>(Channel.Network, HandleNetwork);

            if (isApp)
                JoinNetwork();
        }

        public void JoinNetwork()
        {
            // tell other servers listening that we've join the network
            Publish(Channel.Network, new NetworkMsg()
            {
                Code = NetworkCode.Join,
                Info = _settings.serverInfo
            });
        }

        public string AnnounceInstance(string user, string message)
        {
            lock(_dicLock)
            {
                var serverInfos = _servers.Values.Where(server => server.type == ServerType.World).ToArray();

                if (serverInfos.Length == 0)
                    return "There is no connected server to AppEngine to publish announcement.";

                for (var i = 0; i < serverInfos.Length; i++)
                    Publish(Channel.Announce, new AnnounceMsg() { User = user, Message = message }, serverInfos[i].instanceId);

                return $"Announcement published to **{serverInfos.Length}** connected server{(serverInfos.Length > 1 ? "s" : "")}.";
            }
        }

        public void Dispose() => Shutdown();

        public string GetAppEngineInstance()
        {
            lock (_dicLock)
                return _servers.Values.SingleOrDefault(_ => _.type == ServerType.Account)?.instanceId;
        }

        public string[] GetServerGuids()
        {
            lock (_dicLock)
                return _servers.Keys.ToArray();
        }

        public ServerInfo GetServerInfo(string instanceId)
        {
            lock (_dicLock)
                return _servers.ContainsKey(instanceId) ? _servers[instanceId] : null;
        }

        public ServerInfo[] GetServerList()
        {
            lock (_dicLock)
                return _servers.Values.OrderBy(_ => _.port).ToArray();
        }

        public void Initialize()
        {
            _tmr.Elapsed += (sender, e) => Tick(PingPeriod);
            _tmr.Start();
        }

        public void Shutdown()
        {
            _tmr.Stop();

            Publish(Channel.Network, new NetworkMsg()
            {
                Code = NetworkCode.Quit,
                Info = _settings.serverInfo
            });
        }

        public void Tick(int elapsedMs)
        {
            try
            {
                OnTick?.Invoke();
                lock(_dicLock)
                {
                    Console.Title = GetFormattedTitle();

                    // update running time
                    _lastPing += elapsedMs;

                    foreach (var s in _lastUpdateTime.Keys.ToArray())
                        _lastUpdateTime[s] += elapsedMs;

                    if (_lastPing < PingPeriod)
                        return;

                    _lastPing = 0;

                    // notify other servers we're still alive. Update info in the process.
                    Publish(Channel.Network, new NetworkMsg()
                    {
                        Code = NetworkCode.Ping,
                        Info = _settings.serverInfo
                    });

                    // check for server timeouts
                    foreach (var s in _lastUpdateTime.Where(s => s.Value > ServerTimeout).ToArray())
                    {
                        var sInfo = _servers[s.Key];

                        RemoveServer(s.Key);

                        // invoke server quit event
                        var networkMsg = new NetworkMsg()
                        {
                            Code = NetworkCode.Timeout,
                            Info = sInfo
                        };

                        ServerQuit?.Invoke(this, new InterServerEventArgs<NetworkMsg>(s.Key, networkMsg));
                    }
                }
            }
            catch (Exception e)
            {
                Log.Info(e);
            }
        }

        private bool AddServer(string instanceId, ServerInfo info)
        {
            if (_servers.ContainsKey(instanceId))
                return false;

            UpdateServer(instanceId, info);

            return true;
        }

        private string GetFormattedTitle() => _isApp
            ? _consoleTitlePattern
                .Replace(ISTextKeys.SERVER_AMOUNT, (_servers.Count - 1).ToString())
                .Replace(ISTextKeys.CONNECTIONS, _settings.serverInfo.players.ToString())
                .Replace(ISTextKeys.TOTAL_CONNECTIONS, _settings.serverInfo.maxPlayers.ToString())
            : _consoleTitlePattern
                .Replace(ISTextKeys.SERVER_NAME, _settings.serverInfo.name)
                .Replace(ISTextKeys.CONNECTIONS, _settings.serverInfo.players.ToString())
                .Replace(ISTextKeys.TOTAL_CONNECTIONS, _settings.serverInfo.maxPlayers.ToString())
                .Replace(ISTextKeys.GAME_ACCESS, _accessType);

        private void HandleNetwork(object sender, InterServerEventArgs<NetworkMsg> e)
        {
            lock(_dicLock)
            {
                switch (e.Content.Code)
                {
                    case NetworkCode.Join:
                        if (AddServer(e.InstanceId, e.Content.Info))
                        {
                            // make new server aware of this server
                            Publish(Channel.Network, new NetworkMsg()
                            {
                                Code = NetworkCode.Join,
                                Info = _settings.serverInfo
                            });

                            NewServer?.Invoke(this, e);
                        }
                        else
                            UpdateServer(e.InstanceId, e.Content.Info);

                        break;

                    case NetworkCode.Ping:
                        if (!_servers.ContainsKey(e.InstanceId))
                            Log.Info("{0} ({1}) re-joined the network.", e.Content.Info.name, e.InstanceId);
                        UpdateServer(e.InstanceId, e.Content.Info);
                        ServerPing?.Invoke(this, e);
                        break;

                    case NetworkCode.Quit:
                        Log.Info("{0} ({1}) left the network.", e.Content.Info.name, e.InstanceId);
                        RemoveServer(e.InstanceId);
                        ServerQuit?.Invoke(this, e);
                        break;
                }
            }
        }

        private void UpdateServer(string instanceId, ServerInfo info)
        {
            _servers[instanceId] = info;
            _lastUpdateTime[instanceId] = 0;
        }

        private void RemoveServer(string instanceId)
        {
            _servers.Remove(instanceId);
            _lastUpdateTime.Remove(instanceId);
        }

        private struct ISTextKeys
        {
            public const string CONNECTIONS = "{CONNECTIONS}";
            public const string GAME_ACCESS = "{ACCESS_LEVEL}";
            public const string SERVER_AMOUNT = "{SERVER}";
            public const string SERVER_NAME = "{NAME}";
            public const string TOTAL_CONNECTIONS = "{TOTAL_CONNECTIONS}";
        }
    }
}
