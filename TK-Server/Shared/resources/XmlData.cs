using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Xml.Linq;
using Shared;
using Shared.terrain;

namespace Shared.resources
{
    public class XmlData
    {
        public Dictionary<ushort, PlayerDesc> Classes = new Dictionary<ushort, PlayerDesc>();
        public Dictionary<string, ushort> DisplayIdToObjectType = new Dictionary<string, ushort>();
        public Dictionary<string, ushort> IdToObjectType = new Dictionary<string, ushort>(StringComparer.InvariantCultureIgnoreCase);
        public Dictionary<string, ushort> IdToTileType = new Dictionary<string, ushort>();
        public Dictionary<ushort, Item> Items = new Dictionary<ushort, Item>();
        public Dictionary<ushort, ObjectDesc> ObjectDescs = new Dictionary<ushort, ObjectDesc>();
        public Dictionary<ushort, string> ObjectTypeToId = new Dictionary<ushort, string>();
        public Dictionary<ushort, PortalDesc> Portals = new Dictionary<ushort, PortalDesc>();
        public Dictionary<ushort, SkinDesc> Skins = new Dictionary<ushort, SkinDesc>();
        public Dictionary<int, ItemType> SlotTypeToItemType = new Dictionary<int, ItemType>();
        public Dictionary<ushort, TileDesc> Tiles = new Dictionary<ushort, TileDesc>();
        public Dictionary<ushort, string> TileTypeToId = new Dictionary<ushort, string>();

        private readonly Dictionary<string, WorldResource> Worlds = new Dictionary<string, WorldResource>();
        private readonly Dictionary<string, byte[]> WorldDataCache = new Dictionary<string, byte[]>();
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        public XElement ObjectCombinedXML;
        public XElement CombinedXMLPlayers;
        public XElement GroundCombinedXML;
        public XElement SkinsCombinedXML;

        public void Initialize(bool exportXmls)
        {
            if (exportXmls)
            {
                ObjectCombinedXML = new XElement("Objects");
                CombinedXMLPlayers = new XElement("Objects");
                GroundCombinedXML = new XElement("Grounds");
                SkinsCombinedXML = new XElement("Objects");
            }
        }

        private void AddGrounds(XElement root, bool exportXmls = false) => root.Elements("Ground").Select(e =>
        {
            if (exportXmls)
                GroundCombinedXML.Add(e);

            var id = e.GetAttribute<string>("id");
            var type = e.GetAttribute<ushort>("type");

            if (TileTypeToId.ContainsKey(type))
                Log.Warn("'{0}' and '{1}' have the same type of '0x{2:x4}'", id, TileTypeToId[type], type);

            if (IdToTileType.ContainsKey(id))
                Log.Warn("'0x{0:x4}' and '0x{1:x4}' have the same id of '{2}'", type, IdToTileType[id], id);

            TileTypeToId[type] = id;
            IdToTileType[id] = type;

            Tiles[type] = new TileDesc(type, e);

            return e;
        }).ToArray();

        private void AddObjects(XElement root, bool exportXmls = false)
        {
            foreach (var e in root.Elements("Object"))
            {
                if (exportXmls)
                {
                    if (e.Element("Player") != null)
                        CombinedXMLPlayers.Add(e);
                    else if (e.Element("Skin") != null)
                        SkinsCombinedXML.Add(e);
                    else
                        ObjectCombinedXML.Add(e);
                }

                var cls = e.GetValue<string>("Class");
                if (string.IsNullOrWhiteSpace(cls))
                    continue;

                ushort type = 0;
                try
                {
                    type = e.GetAttribute<ushort>("type");
                }
                catch
                {
                    Log.Error("XML Error: " + e);
                }

                var id = e.GetAttribute<string>("id");
                var displayId = e.GetValue<string>("DisplayId");
                var displayName = string.IsNullOrWhiteSpace(displayId) ? id : displayId;

                if (ObjectTypeToId.ContainsKey(type))
                    Log.Warn("'{0}' and '{1}' have the same type of '0x{2:x4}'", id, ObjectTypeToId[type], type);

                if (IdToObjectType.ContainsKey(id))
                    Log.Warn("'0x{0:x4}' and '0x{1:x4}' have the same id of '{2}'", type, IdToObjectType[id], id);

                ObjectTypeToId[type] = id;
                IdToObjectType[id] = type;
                DisplayIdToObjectType[displayName] = type;

                switch (cls)
                {
                    case "Equipment":
                    case "Dye":
                        Items[type] = new Item(type, e);
                        break;

                    case "Player":
                        var pDesc = Classes[type] = new PlayerDesc(type, e);
                        ObjectDescs[type] = Classes[type];
                        SlotTypeToItemType[pDesc.SlotTypes[0]] = ItemType.Weapon;
                        SlotTypeToItemType[pDesc.SlotTypes[1]] = ItemType.Ability;
                        SlotTypeToItemType[pDesc.SlotTypes[2]] = ItemType.Armor;
                        SlotTypeToItemType[pDesc.SlotTypes[3]] = ItemType.Ring;
                        break;

                    case "GuildHallPortal":
                    case "Portal":
                        Portals[type] = new PortalDesc(type, e);
                        ObjectDescs[type] = Portals[type];
                        break;

                    case "Skin":
                        Skins[type] = new SkinDesc(type, e);
                        break;

                    default:
                        ObjectDescs[type] = new ObjectDesc(type, e);
                        break;
                }
            }
        }

        public void LoadMaps(string basePath)
        {
			var isDocker = Environment.GetEnvironmentVariable("IS_DOCKER") != null;
			
            var directories = Directory.GetDirectories(basePath, "*", SearchOption.AllDirectories).ToList();
            directories.Add(basePath);
            foreach (var directory in directories)
            {
                var directoryName = directory.Replace($@"{basePath}", "").Replace("\\", "");

                var jms = Directory.GetFiles(directory, "*.jm");
                foreach (var jm in jms)
                {
                    var id = $"{(directoryName == "" ? "" : $"{directoryName}/")}{Path.GetFileName(jm)}";
					
					if(isDocker){
						if(id[0] == '/'){
							id = id.Substring(1, id.Length - 1);
						}
					}
		
                    if (id == "realm.jm")
                        WorldDataCache.Add(id, File.ReadAllBytes(jm));
                    else
                    {
                        var mapJson = Encoding.UTF8.GetString(File.ReadAllBytes(jm));

                        try
                        {
                            var data = Json2Wmap.Convert(this, mapJson);
                            WorldDataCache.Add(id, data);
                        }
                        catch (Exception e)
                        {
                            Log.Error($"Exception: {e}");
                            Log.Error($"JM Path Error: {jm}");
                        }
                    }
                }
            }
        }

        public void LoadXmls(string basePath, string ext, bool exportXmls = false)
        {
            var xmls = Directory.GetFiles(basePath, ext, SearchOption.AllDirectories);
            for (var i = 0; i < xmls.Length; i++)
            {
                var xml = File.ReadAllText(xmls[i]);

                try
                {
                    ProcessXml(XElement.Parse(xml), exportXmls);
                }
                catch (Exception e)
                {
                    Log.Error("Exception: " + e.Message + "\n" + e.StackTrace);
                    Log.Error("XML Path Error: " + xmls[i]);
                }
            }
        }

        public WorldResource GetWorld(string dungeonName)
        {
            if (Worlds.TryGetValue(dungeonName, out var ret))
                return ret;
            return null;
        }

        public byte[] GetWorldData(string name)
        {
            if (WorldDataCache.TryGetValue(name, out var ret))
                return ret;
            return null;
        }

        public void AddWorlds(XElement root)
        {
            foreach (var e in root.Elements("World"))
            {
                var world = new WorldResource(e);
                if (Worlds.ContainsKey(world.IdName))
                    throw new Exception($"Error Loading: Duplicate IdName: {world.IdName}");
                Worlds[world.IdName] = world;
            }
        }

        private void ProcessXml(XElement root, bool exportXmls = false)
        { 
            AddWorlds(root);
            AddObjects(root, exportXmls);
            AddGrounds(root, exportXmls);
        }
    }
}
