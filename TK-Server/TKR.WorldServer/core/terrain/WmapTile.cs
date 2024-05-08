using System;
using System.Collections.Generic;
using TKR.Shared;
using TKR.Shared.resources;
using TKR.WorldServer.core.net.datas;
using TKR.WorldServer.core.net.stats;
using TKR.WorldServer.core.objects.connection;

namespace TKR.WorldServer.core.terrain
{
    public class WmapTile
    {
        private readonly WmapDesc _originalDesc;

        public short X;
        public short Y;

        public ushort TileId;
        public TileDesc TileDesc;

        // static entity stuff
        public int ObjId;
        public ushort ObjType;
        public string ObjCfg;
        public ObjectDesc ObjDesc;

        public TileRegion Region;
        public TerrainType Terrain;
        public ObjectDef? ToDefine;
        public byte Elevation;
        public byte UpdateCount = 1;
        public bool Spawned;

        public WmapTile(WmapDesc desc)
        {
            _originalDesc = desc;
            Reset();
        }

        public WmapTile Clone()
        {
            return new WmapTile(_originalDesc)
            {
                UpdateCount = (byte)(UpdateCount + 1),
                TileId = _originalDesc.TileId,
                ObjType = _originalDesc.ObjType,
                ObjDesc = ObjDesc,
                ObjCfg = _originalDesc.ObjCfg,
                Terrain = _originalDesc.Terrain,
                Region = _originalDesc.Region,
            };
        }

        public void Reset(Wmap map = null, int x = 0, int y = 0)
        {
            TileId = _originalDesc.TileId;
            TileDesc = _originalDesc.TileDesc;

            ObjType = _originalDesc.ObjType;
            ObjDesc = _originalDesc.ObjDesc;
            ObjCfg = _originalDesc.ObjCfg;

            Terrain = _originalDesc.Terrain;
            Region = _originalDesc.Region;
            Elevation = _originalDesc.Elevation;

            if (map != null)
                InitConnection(map, x, y);

            UpdateCount++;
        }

        public void InitConnection(Wmap map, int x, int y)
        {
            if (ObjDesc == null || !ObjDesc.Connects || ObjCfg.Contains("conn:"))
                return;

            var connStr = ConnectionComputer.GetConnString((dx, dy) => map.Contains(x + dx, y + dy) && map[x + dx, y + dy].ObjType == ObjType);
            ObjCfg = $"{ObjCfg};{connStr};";
        }

        public void CopyTo(WmapTile tile)
        {
            tile.TileId = TileId;
            tile.TileDesc = TileDesc;
            tile.ObjType = ObjType;
            tile.ObjDesc = ObjDesc;
            tile.ObjCfg = ObjCfg;
            tile.Terrain = Terrain;
            tile.Region = Region;
            tile.Elevation = Elevation;
        }

        public ObjectDef ToObjectDef(int x, int y)
        {
            if (ToDefine != null)
                return ToDefine.Value;

            var stats = new List<KeyValuePair<StatDataType, object>>();

            if (!string.IsNullOrEmpty(ObjCfg))
                foreach (var item in ObjCfg.Split(';'))
                {
                    var kv = item.Split(':');

                    switch (kv[0])
                    {
                        case "hp":
                            var hp = Utils.GetInt(kv[1]);
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.Health, hp));
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MaximumHealth, hp));
                            break;

                        case "name":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.Name, kv[1]));
                            break;

                        case "size":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.Size, Math.Min(500, Utils.GetInt(kv[1]))));
                            break;

                        case "eff":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.ConditionBatch1, Utils.GetInt(kv[1])));
                            break;

                        case "conn":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.ObjectConnection, Utils.GetInt(kv[1])));
                            break;

                        case "mtype":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseType, Utils.GetInt(kv[1])));
                            break;

                        case "mcost":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandisePrice, Math.Max(0, Utils.GetInt(kv[1]))));
                            break;

                        case "mcur":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseCurrency, Utils.GetInt(kv[1])));
                            break;

                        case "mamnt":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseCount, Utils.GetInt(kv[1])));
                            break;

                        case "mtime":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseMinsLeft, Utils.GetInt(kv[1])));
                            break;

                        case "mdisc":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseDiscount, Utils.GetInt(kv[1])));
                            break;

                        case "mrank":
                        case "stars":
                            stats.Add(new KeyValuePair<StatDataType, object>(StatDataType.MerchandiseRankReq, Utils.GetInt(kv[1])));
                            break;
                    }
                }

            ToDefine = new ObjectDef()
            {
                ObjectType = ObjType,
                Stats = new ObjectStats()
                {
                    Id = ObjId,
                    X = x + 0.5f,
                    Y = y + 0.5f,
                    Stats = stats.ToArray()
                }
            };

            return ToDefine.Value;
        }
    }
}
