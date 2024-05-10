using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.structures;

namespace WorldServer.core.worlds
{
    public sealed class RealmPortalMonitor
    {
        public const int MAX_PER_REALM = 85;

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


        private readonly object _access = new object();
        private readonly GameServer _gameServer;
        private readonly World _world;

        private readonly Dictionary<int, Portal> _portals = new Dictionary<int, Portal>();
        private readonly List<string> _actives = new List<string>();

        public RealmPortalMonitor(GameServer manager, World world)
        {
            _gameServer = manager;
            _world = world;
        }

        public void CreateNewRealm()
        {
            lock (_access)
            {
                var name = Names[Random.Shared.Next(Names.Count)];
                _actives.Add(name);
                _gameServer.WorldManager.CreateNewRealmAsync(name);
            }
        }

        public void AddPortal(World world)
        {
            lock (_access)
            {
                if (_portals.ContainsKey(world.Id))
                    return;

                var pos = GetRandPosition();

                var portal = (Portal)_world.CreateNewEntity("Nexus Portal", pos.X + 0.5f, pos.Y + 0.5f);
                portal.WorldInstance = world;
                portal.Name = $"{world.GetDisplayName()}(0/{MAX_PER_REALM})";
                portal.Size = 80;

                _portals.Add(world.Id, portal);
            }
        }

        public bool PortalIsOpen(int worldId)
        {
            lock (_access)
            {
                if (!_portals.ContainsKey(worldId))
                    return false;
                return _portals[worldId].Usable && !_portals[worldId].Locked;
            }
        }

        public void OpenPortal(int worldId)
        {
            lock (_access)
            {
                if (!_portals.ContainsKey(worldId))
                    return;

                var portal = _portals[worldId];
                if (!portal.Usable)
                    _portals[worldId].Usable = true;
            }
        }

        public void ClosePortal(int worldId)
        {
            lock (_access)
            {
                if (!_portals.ContainsKey(worldId))
                    return;

                var portal = _portals[worldId];
                if (portal.Usable)
                    portal.Usable = false;
            }
        }

        public void Update(ref TickTime time)
        {
            lock (_access)
            {
                CreateRealmIfExists();

                foreach (var p in _portals.Values)
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
            if (Names.Count == 0 || _actives.Count >= _gameServer.Configuration.serverSettings.maxRealms)
                return;

            var totalPlayers = _world.GameServer.ConnectionManager.GetPlayerCount();
            var realmsNeeded = 1 + totalPlayers / (MAX_PER_REALM + 15);
            if (_actives.Count < realmsNeeded)
                CreateNewRealm();
        }

        public void RemovePortal(int worldId)
        {
            lock (_access)
            {
                if (!_portals.TryGetValue(worldId, out var portal))
                    return;

                var name = portal.WorldInstance.DisplayName;
                _actives.Remove(name);
                Names.Add(name);

                _world.LeaveWorld(portal);
                _portals.Remove(worldId);
            }
        }

        private Position GetRandPosition()
        {
            var x = 0;
            var y = 0;
            var realmPortalRegions = _world.Map.Regions.Where(t => t.Value == TileRegion.Realm_Portals).ToArray();

            if (realmPortalRegions.Length > _portals.Count)
            {
                KeyValuePair<IntPoint, TileRegion> sRegion;
                do
                {
                    sRegion = realmPortalRegions.ElementAt(Random.Shared.Next(0, realmPortalRegions.Length));
                }
                while (_portals.Values.Any(p => p.X == sRegion.Key.X + 0.5f && p.Y == sRegion.Key.Y + 0.5f));

                x = sRegion.Key.X;
                y = sRegion.Key.Y;
            }
            return new Position(x, y);
        }
    }
}
