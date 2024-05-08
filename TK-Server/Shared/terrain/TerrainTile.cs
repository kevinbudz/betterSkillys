using System;
using Shared.resources;

namespace Shared.terrain
{
    public struct TerrainTile : IEquatable<TerrainTile>
    {
        public string Biome;
        public byte Elevation;
        public float Moisture;
        public string Name;
        public int PolygonId;
        public TileRegion Region;
        public TerrainType Terrain;
        public ushort TileId;
        public string TileObj;

        public bool Equals(TerrainTile other) => TileId == other.TileId && TileObj == other.TileObj && Name == other.Name && Terrain == other.Terrain && Region == other.Region;
    }
}
