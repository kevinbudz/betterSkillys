using System;
using System.Collections.Generic;

namespace WorldServer.core.worlds
{
    public sealed class WorldBranch
    {
        private readonly World World;
        private readonly Dictionary<int, World> SubWorlds = new Dictionary<int, World>();

        public WorldBranch(World world)
        {
            World = world;
        }

        public void AddBranch(World world) => SubWorlds.Add(world.Id, world);

        public void GetPlayerCount(ref int count)
        {
            count += World.Players.Values.Count;
            foreach (var branch in SubWorlds.Values)
                branch.GetPlayerCount(ref count);
        }

        public bool HasBranches() => SubWorlds.Count > 0;

        public void HandleIO(ref TickTime time)
        {
            foreach (var world in SubWorlds.Values)
                world.ProcessPlayerIO(ref time);
        }

        public void Update(ref TickTime time)
        {
            var toRemove = new List<World>();
            foreach (var world in SubWorlds.Values)
                if (world.Update(ref time))
                    toRemove.Add(world);

            foreach (var world in toRemove)
            {
                world.ParentWorld = null;
                World.GameServer.WorldManager.RemoveWorld(world);
                _ = SubWorlds.Remove(world.Id);
            }
            toRemove.Clear();
        }
    }

}
