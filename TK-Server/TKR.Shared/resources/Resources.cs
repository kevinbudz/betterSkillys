using NLog;
using System;
using System.Collections.Generic;
using System.IO;

namespace TKR.Shared.resources
{
    public class Resources : IDisposable
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        public XmlData GameData { get; private set; } = new XmlData();
        public string ResourcePath { get; private set; }
        public AppSettings Settings { get; private set; } = new AppSettings();
        public Dictionary<string, byte[]> WebFiles { get; private set; } = new Dictionary<string, byte[]>();

        public Resources(string resourcePath, bool wServer, bool exportXmls = true)
        {
            Log.Info("Loading resources...");
            ResourcePath = Path.GetFullPath(resourcePath);

            Log.Info("Loading XmlData...");
            var xmlPath = $"{resourcePath}/xml";

            GameData.Initialize(exportXmls);
            GameData.LoadXmls(xmlPath, "*.xml", exportXmls);
            GameData.LoadXmls(xmlPath, "*.dat", exportXmls);

            Log.Info("Loading Settings...");
            var settingsPath = $"{resourcePath}/data/init.xml";
            Settings.LoadSettings(settingsPath);

            if (!wServer)
                LoadWebFiles(resourcePath + "/web");
            else
                GameData.LoadMaps($"{resourcePath}/worlds");
        }

        private void LoadWebFiles(string dir)
        {
            Log.Info("Loading web data...");

            var files = Directory.GetFiles(dir, "*", SearchOption.AllDirectories);
            foreach (var file in files)
            {
                var webPath = file.Substring(dir.Length, file.Length - dir.Length).Replace("\\", "/");
                WebFiles[webPath] = File.ReadAllBytes(file);
            }
        }

        public void Dispose()
        {
            ResourcePath = null;
            GameData = null;
            WebFiles = null;
            Settings = null;

            GC.SuppressFinalize(this);
        }
    }
}
