using Microsoft.AspNetCore.Hosting;
using NLog;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Timers;
using System.Xml.Linq;
using Shared;
using Shared.database;
using Shared.isc;
using Shared.resources;

namespace App
{
    public sealed class CoreService 
    {
        public readonly Logger Logger;
        public readonly Resources Resources;
        public readonly Database Database;
        public readonly ISManager ISManager;
        public readonly ServerConfig Config;
        private readonly Timer LegendSweeper = new Timer(60000);

        public readonly List<ushort> PlayerClasses;
        public readonly Dictionary<ushort, string> _classes;
        public readonly Dictionary<string, string> _classAvailability;
        public readonly XElement ItemCostsXml;

        public CoreService()
        {
            Logger = LogManager.GetCurrentClassLogger();
			
            var isDocker = Environment.GetEnvironmentVariable("IS_DOCKER") != null;
            if(isDocker)
				Config = ServerConfig.ReadFile("/data/server.json");
			else
				Config = ServerConfig.ReadFile("server.json");
            
			Config.serverInfo.instanceId = Guid.NewGuid().ToString();

            LogManager.Configuration.Variables["logDirectory"] = $"{Config.serverSettings.logFolder}/app";
            LogManager.Configuration.Variables["buildConfig"] = Utils.GetBuildConfiguration();

            if (Debugger.IsAttached) // hacky fix to get right path when debugging
                Resources = new Resources($"{Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)}/resources", false);
            else
                Resources = new Resources(Config.serverSettings.resourceFolder, false);

            Database = new Database(Resources, Config);

            ISManager = new ISManager(Database.Subscriber, Config, true);
            ISManager.OnTick += () => UpdateServersUsage();
            ISManager.Initialize();

            LegendSweeper.Elapsed += (sender, e) => Database.CleanLegends();
            LegendSweeper.Start();

            PlayerClasses = Resources.GameData.ObjectDescs.Values.Where(objDesc => objDesc.Player).Select(objDesc => objDesc.ObjectType).ToList();
            _classes = Resources.GameData.ObjectDescs.Values.Where(objDesc => objDesc.Player).ToDictionary(objDesc => objDesc.ObjectType, objDesc => objDesc.IdName);
            _classAvailability = _classes.ToDictionary(@class => @class.Value, @class => "available");

            var elem = new XElement("ItemCosts");
            foreach (var skin in Resources.GameData.Skins.Values)
            {
                var ca = new XElement("ItemCost", skin.Cost);
                ca.Add(new XAttribute("type", skin.Type));
                elem.Add(ca);
            }

            ItemCostsXml = elem;
        }

        public bool IsProduction()
        {
#if DEBUG
            return false;
#else
            return true;
#endif
        }

        public void UpdateServersUsage()
        {
            var servers = ISManager
                .GetServerList()
                .Where(server => server.instanceId != Config.serverInfo.instanceId)
                .ToArray();

            if (servers.Length == 0)
            {
                Config.serverInfo.players = 0;
                Config.serverInfo.maxPlayers = 0;
                return;
            }

            var players = 0;
            var maxPlayers = 0;
            for (var i = 0; i < servers.Length; i++)
            {
                var server = servers[i];

                players += server.players;
                maxPlayers += server.maxPlayers;
            }

            Config.serverInfo.players = players;
            Config.serverInfo.maxPlayers = maxPlayers;
        }

        public List<ServerItem> GetServerList()
        {
            var ret = new List<ServerItem>();
            foreach (var server in ISManager.GetServerList().ToList())
            {
                if (server.type != ServerType.World)
                    continue;

                ret.Add(new ServerItem()
                {
                    Name = server.name,
                    Lat = server.latitude,
                    Long = server.longitude,
                    Port = server.port,
                    DNS = server.address,
                    Usage = server.players / (double)server.maxPlayers,
                    AdminOnly = server.adminOnly,
                    UsageText = server.IsJustStarted() ? "- NEW!" : $"{server.players}/{server.maxPlayers}"
                });
            }
            ret = ret.OrderBy(_ => _.Port).ToList();
            return ret;
        }
    }
}