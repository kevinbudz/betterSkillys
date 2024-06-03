using System;
using System.Linq;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class RemoveTileObject : Behavior
    {
        private readonly ushort _objType;
        private readonly int _range;

        public RemoveTileObject(ushort objType, int range)
        {
            _objType = objType;
            _range = range;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var objType = _objType;

            var map = host.World.Map;

            var w = map.Width;
            var h = map.Height;

            for (var y = 0; y < h; y++)
                for (var x = 0; x < w; x++)
                {
                    var tile = map[x, y];

                    if (tile.ObjType != objType)
                        continue;

                    var dx = Math.Abs(x - (int)host.X);
                    var dy = Math.Abs(y - (int)host.Y);

                    if (dx > _range || dy > _range)
                        continue;

                    tile.ObjType = 0;
                    tile.UpdateCount++;
                    map[x, y] = tile;
                }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state) { }
    }
}
