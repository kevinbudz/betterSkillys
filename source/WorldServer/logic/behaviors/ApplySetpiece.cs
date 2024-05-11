using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    public class PlaceMap : Behavior
    {
        private readonly string jmMap;
        private readonly bool UseSpawnPoint;

        public PlaceMap(string filePath, bool useSpawnPoint)
        {
            jmMap = filePath;
            UseSpawnPoint = useSpawnPoint;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var pos = UseSpawnPoint ? new IntPoint((int)host.SpawnPoint.Value.X, (int)host.SpawnPoint.Value.Y) : new IntPoint((int)host.X, (int)host.Y);

            var data = host.GameServer.Resources.GameData.GetWorldData(jmMap);
            if (data == null)
            {
                Console.WriteLine($"[{GetType().Name}] Invalid RenderSetPiece {jmMap}");
                return;
            }
            SetPieces.RenderFromData(host.World, pos, data);

            foreach (var player in host.World.Players.Values)
                player.UpdateTiles();
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
