using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace Shared.resources
{
    public enum WorldResourceInstanceType
    {
        Nexus,
        Vault,
        Guild,
        Dungeon
    }

    public sealed class WorldResource
    {
        public readonly string IdName;
        public readonly string DisplayName;
        public readonly int Width;
        public readonly int Height;
        public readonly int Capacity;
        public readonly WorldResourceInstanceType Instance;
        public readonly bool Persists;
        public readonly byte Difficulty;
        public readonly byte Background;
        public readonly byte VisibilityType;
        public readonly List<string> MapJM;
        public readonly List<string> Music;
        public readonly bool AllowTeleport;
        public readonly bool ShowDisplays;
        public readonly bool DisableShooting;
        public readonly bool DisableAbilities;
        public readonly bool CreateInstance;

        public WorldResource(XElement elem)
        {
            IdName = elem.GetAttribute<string>("id");
            DisplayName = elem.GetValue("DisplayName", IdName);
            Width = elem.GetValue<int>("Width");
            Height = elem.GetValue<int>("Height");
            Capacity = elem.GetValue("Capacity", 65);
            Instance = elem.Element("Instance") == null ? WorldResourceInstanceType.Dungeon : (WorldResourceInstanceType)Enum.Parse(typeof(WorldResourceInstanceType), elem.Element("Instance").GetAttribute("enum", "dungeon"), true);
            Persists = elem.HasElement("Persists");
            Difficulty = elem.GetValue<byte>("Difficulty");
            Background = elem.GetValue<byte>("Background");
            VisibilityType = (byte)elem.GetValue<int>("VisibilityType");
            AllowTeleport = !elem.HasElement("DisableTeleport");
            ShowDisplays = elem.HasElement("ShowDisplays");
            DisableShooting = elem.HasElement("DisableShooting");
            DisableAbilities = elem.HasElement("DisableAbilities");
            CreateInstance = elem.HasElement("CreateInstance");

            MapJM = new List<string>();
            foreach (var map in elem.Elements("MapJM"))
                MapJM.Add(map.Value);

            Music = new List<string>();
            var musicElem = elem.Element("Music");
            if (musicElem != null)
                foreach (var music in musicElem.Elements("Track"))
                    Music.Add(music.Value);
        }

        public override string ToString()
        {
            var ret = $"IdName: {IdName}\n";
            ret += $"Width: {Width}\n";
            ret += $"Height: {Height}\n";
            ret += $"Capacity: {Capacity}\n";
            ret += $"Instance: {Instance}\n";
            ret += $"Persists: {Persists}\n";
            ret += $"MapJM: {MapJM}";
            return ret;
        }
    }
}
