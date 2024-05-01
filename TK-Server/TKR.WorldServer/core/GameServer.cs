using NLog;
using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using TKR.Shared;
using TKR.Shared.database;
using TKR.Shared.isc;
using TKR.Shared.resources;
using TKR.WorldServer.core.commands;
using TKR.WorldServer.core.connection;
using TKR.WorldServer.core.miscfile;
using TKR.WorldServer.core.objects.inventory;
using TKR.WorldServer.core.objects.vendors;
using TKR.WorldServer.core.worlds;
using TKR.WorldServer.logic;
using TKR.WorldServer.logic.loot;
using TKR.WorldServer.utils;

namespace TKR.WorldServer.core
{
    public sealed class GameServer
    {
        public string InstanceId { get; private set; }
        public ServerConfig Configuration { get; private set; }
        public Resources Resources { get; private set; }
        public Database Database { get; private set; }
        public MarketSweeper MarketSweeper { get; private set; }
        public ConnectionManager ConnectionManager { get; private set; }
        public ConnectionListener ConnectionListener { get; private set; }
        public ChatManager ChatManager { get; private set; }
        public BehaviorDb BehaviorDb { get; private set; }
        public CommandManager CommandManager { get; private set; }
        public DbEvents DbEvents { get; private set; }
        public ISManager InterServerManager { get; private set; }
        public WorldManager WorldManager { get; private set; }
        public SignalListener SignalListener { get; private set; }

        private bool Running { get; set; } = true;

        public DateTime RestartCloseTime { get; private set; }

        public GameServer(string[] appArgs)
        {	
			var configPath = appArgs.Length == 0 ? "wServer.json" : appArgs[0];
			Configuration = ServerConfig.ReadFile(configPath);
			
            LogManager.Configuration.Variables["logDirectory"] = $"{Configuration.serverSettings.logFolder}/wServer";
            LogManager.Configuration.Variables["buildConfig"] = Utils.GetBuildConfiguration();

            AppDomain.CurrentDomain.UnhandledException += (sender, args) =>
            {
                StaticLogger.Instance.Fatal(((Exception)args.ExceptionObject).StackTrace.ToString());
            };

            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
            Thread.CurrentThread.Name = "Entry";

            ThreadPool.GetMinThreads(out int workerThreads, out int completionPortThreads);
            ThreadPool.SetMinThreads(250, completionPortThreads);

            Resources = new Resources(Configuration.serverSettings.resourceFolder, true, false);
            Database = new Database(Resources, Configuration);
            MarketSweeper = new MarketSweeper(Database);
            ConnectionManager = new ConnectionManager(this);
            ConnectionListener = new ConnectionListener(this);
            ChatManager = new ChatManager(this);
            BehaviorDb = new BehaviorDb(this);
            CommandManager = new CommandManager();
            DbEvents = new DbEvents(this);

            InstanceId = Configuration.serverInfo.instanceId = Guid.NewGuid().ToString();
            Console.WriteLine($"[Set] InstanceId [{InstanceId}]");

            InterServerManager = new ISManager(Database.Subscriber, Configuration);
            WorldManager = new WorldManager(this);
            
            var isDocker = Environment.GetEnvironmentVariable("IS_DOCKER") != null;
			SignalListener = isDocker ? new SignalListenerLinux(this) : new SignalListenerWindows(this);
        }

        public bool IsWhitelisted(int accountId) => Configuration.serverSettings.whitelist.Contains(accountId);

#if DEBUG
        private static bool ExportXMLS = true;
#else
        private static bool ExportXMLS = false;
#endif

        public void Run()
        {
            CommandManager.Initialize(this);
            Loot.Initialize(this);
            MobDrops.Initialize(this);
            BehaviorDb.Initialize();
            MerchantLists.Initialize(this);
            WorldManager.Initialize();
            InterServerManager.Initialize();
            ChatManager.Initialize();
            ConnectionListener.Initialize();
            MarketSweeper.Start();
            ConnectionListener.Start();
            InterServerManager.JoinNetwork();

            var timeout = TimeSpan.FromHours(Configuration.serverSettings.restartTime);

            var utcNow = DateTime.UtcNow;
            var startedAt = utcNow;
            RestartCloseTime = utcNow.Add(timeout);
            var restartsIn = utcNow.Add(TimeSpan.FromMinutes(5));

            var restart = false;

            var watch = Stopwatch.StartNew();
            while (Running)
            {
                // server close event
                if (!restart && DateTime.UtcNow >= RestartCloseTime)
                {
                    ChatManager.ServerAnnounce("Server **Restart** in 5 minutes, prepare to leave");

                    Console.WriteLine("[Restart] Procdure Commensing");
                    ConnectionListener.Disable();
                    restart = true;
                }

                if (restart && DateTime.UtcNow >= restartsIn)
                    break;

                var current = watch.ElapsedMilliseconds;

                ConnectionManager.Tick(current);

                var logicTime = (int)(watch.ElapsedMilliseconds - current);
                var sleepTime = Math.Max(0, 200 - logicTime);

                Thread.Sleep(sleepTime);
            }

            if (restart)
                Console.WriteLine("[Restart] Triggered");
            else
                Console.WriteLine("[Shutdown] Triggered");

            Dispose();

            if (restart)
            {
                // need to test linux builds
                _ = Process.Start($"{AppDomain.CurrentDomain.FriendlyName}.exe");
            }

            Console.WriteLine("[Program] Terminated");
            Thread.Sleep(10000);
        }

        public void Stop()
        {
            if (!Running)
                return;
            Running = false;
        }

        public void Dispose()
        {
            Console.WriteLine("[Dispose] ConnectionListener");
            ConnectionListener.Shutdown();

            Console.WriteLine("[Dispose] InterServerManager");
            InterServerManager.Shutdown();

            Console.WriteLine("[Dispose] Resources");
            Resources.Dispose();

            Console.WriteLine("[Dispose] Database");
            Database.Dispose();

            Console.WriteLine("[Dispose] MarketSweeper");
            MarketSweeper.Stop();

            Console.WriteLine("[Dispose] ChatManager");
            ChatManager.Dispose();

            Console.WriteLine("[Dispose] WorldManager");
            WorldManager.Dispose();

            Console.WriteLine("[Dispose] Configuration");
            Configuration = null;
        }
    }
}
