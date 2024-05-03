using TKR.Shared.resources;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using TKR.WorldServer.core.objects;
using TKR.WorldServer.utils;
using TKR.WorldServer.core.structures;

namespace TKR.WorldServer.core.worlds
{
    public class KingdomPortalMonitor
    {
        public const int MAX_PER_REALM = 85;

        private readonly GameServer GameServer;
        private readonly Dictionary<int, Portal> Portals = new Dictionary<int, Portal>();
        private readonly World World;

        private readonly object Access = new object();
        private Random Random = new Random();

        private static readonly List<string> Names = new List<string>()
        {
            "Lich", "Goblin", "Ghost",
            "Giant", "Gorgon","Blob",
            "Leviathan", "Unicorn", "Minotaur",
            "Cube", "Pirate", "Spider",
            "Snake", "Deathmage", "Gargoyle",
            "Scorpion", "Djinn", "Phoenix",
            "Satyr", "Drake", "Orc",
            "Flayer", "Cyclops", "Sprite",
            "Chimera", "Kraken", "Hydra",
            "Slime", "Ogre", "Hobbit",
            "Titan", "Medusa", "Golem",
            "Demon", "Skeleton", "Mummy",
            "Imp", "Bat", "Wyrm",
            "Spectre", "Reaper", "Beholder",
            "Dragon", "Harpy"
        };

        private static readonly List<string> Actives = new List<string>();

        public KingdomPortalMonitor(GameServer manager, World world)
        {
            GameServer = manager;
            World = world;
        }

        public void CreateNewRealm()
        {
            lock (Access)
            {
                var name = Names[Random.Next(Names.Count)];
                Actives.Add(name);
                GameServer.WorldManager.CreateNewRealmAsync(name);
            }
        }

        public void AddPortal(World world)
        {
            lock (Access)
            {
                if (Portals.ContainsKey(world.Id))
                    return;

                var pos = GetRandPosition();

                var portal = (Portal)World.CreateNewEntity("Nexus Portal", pos.X + 0.5f, pos.Y + 0.5f);
                portal.WorldInstance = world;
                portal.Name = world.GetDisplayName() + $" (0/{MAX_PER_REALM})";
                portal.SetDefaultSize(80);

                Portals.Add(world.Id, portal);
            }
        }

        public bool PortalIsOpen(int worldId)
        {
            lock (Access)
            {
                if (!Portals.ContainsKey(worldId))
                    return false;
                return Portals[worldId].Usable && !Portals[worldId].Locked;
            }
        }

        public void OpenPortal(int worldId)
        {
            lock (Access)
            {
                if (!Portals.ContainsKey(worldId))
                    return;

                var portal = Portals[worldId];
                if (!portal.Usable)
                    Portals[worldId].Usable = true;
            }
        }

        public void ClosePortal(int worldId)
        {
            lock (Access)
            {
                if (!Portals.ContainsKey(worldId))
                    return;

                var portal = Portals[worldId];
                if (portal.Usable)
                    portal.Usable = false;
            }
        }

        public void Update(ref TickTime time)
        {
            lock (Access)
            {
                CreateRealmIfExists();

                foreach (var p in Portals.Values)
                {
                    var count = 0;
                    p.WorldInstance.GetPlayerCount(ref count);

                    var updatedCount = $"{p.WorldInstance.GetDisplayName()} ({Math.Min(count, p.WorldInstance.MaxPlayers)}/{p.WorldInstance.MaxPlayers})";

                    if (p.Name.Equals(updatedCount))
                        continue;
                    p.Name = updatedCount;
                }
            }
        }

        private void CreateRealmIfExists()
        {
            if (Names.Count == 0 || Actives.Count >= GameServer.Configuration.serverSettings.maxRealms)
                return;

            var totalPlayers = World.GameServer.ConnectionManager.GetPlayerCount();
            var realmsNeeded = 1 + totalPlayers / (MAX_PER_REALM + 15);
            if (Actives.Count < realmsNeeded)
                CreateNewRealm();
        }

        public void RemovePortal(int worldId)
        {
            lock (Access)
            {
                if (!Portals.TryGetValue(worldId, out var portal))
                    return;

                var name = portal.WorldInstance.DisplayName;
                Actives.Remove(name);
                Names.Add(name);

                World.LeaveWorld(portal);
                Portals.Remove(worldId);
            }
        }

        private Position GetRandPosition()
        {
            var x = 0;
            var y = 0;
            var realmPortalRegions = World.Map.Regions.Where(t => t.Value == TileRegion.Realm_Portals).ToArray();

            if (realmPortalRegions.Length > Portals.Count)
            {
                KeyValuePair<IntPoint, TileRegion> sRegion;
                do
                {
                    sRegion = realmPortalRegions.ElementAt(Random.Next(0, realmPortalRegions.Length));
                }
                while (Portals.Values.Any(p => p.X == sRegion.Key.X + 0.5f && p.Y == sRegion.Key.Y + 0.5f));

                x = sRegion.Key.X;
                y = sRegion.Key.Y;
            }
            return new Position(x, y);
        }
    }
}
