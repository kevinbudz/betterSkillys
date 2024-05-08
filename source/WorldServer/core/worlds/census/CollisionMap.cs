using System;
using System.Collections.Generic;
using WorldServer.core.structures;

namespace WorldServer.core.worlds.census
{
    //TODO: thread-safe?
    public class CollisionMap<T> where T : ICollidable<T>
    {
        public const int CHUNK_SIZE = 16;

        private const int ACTIVE_RADIUS = 3;

        private readonly int cH;
        private readonly int cW;
        private readonly byte type;

        private CollisionNode<T>[,] chunks;
        private int h;
        private int w;

        public CollisionMap(byte type, int w, int h)
        {
            this.type = type;
            this.w = w;
            this.h = h;

            chunks = new CollisionNode<T>[
                cW = (w + CHUNK_SIZE - 1) / CHUNK_SIZE,
                cH = (h + CHUNK_SIZE - 1) / CHUNK_SIZE];
        }

        public IEnumerable<T> GetActiveChunks(CollisionMap<T> from)
        {
            if (from.w != w || from.h != h)
                throw new ArgumentException("from");

            var ret = new HashSet<T>();

            for (var y = 0; y < cH; y++)
                for (var x = 0; x < cW; x++)
                    if (from.chunks[x, y] != null)
                    {
                        for (var i = -ACTIVE_RADIUS; i <= ACTIVE_RADIUS; i++)
                            for (var j = -ACTIVE_RADIUS; j <= ACTIVE_RADIUS; j++)
                            {
                                if (x + j < 0 || x + j >= cW || y + i < 0 || y + i >= cH)
                                    continue;

                                var node = chunks[x + j, y + i];
                                while (node != null)
                                {
                                    ret.Add((T)node.Parent);
                                    node = node.Next;
                                }
                            }
                    }

            return ret;
        }

        public IEnumerable<T> HitTest(Position pos, double radius) => HitTest(pos.X, pos.Y, radius);

        public IEnumerable<T> HitTest(double _x, double _y, double radius)
        {
            int xl = Math.Max(0, (int)(_x - radius) / CHUNK_SIZE);
            int xh = Math.Min(cW - 1, (int)(_x + radius) / CHUNK_SIZE);
            int yl = Math.Max(0, (int)(_y - radius) / CHUNK_SIZE);
            int yh = Math.Min(cH - 1, (int)(_y + radius) / CHUNK_SIZE);
            for (var y = yl; y <= yh; y++)
                for (var x = xl; x <= xh; x++)
                {
                    var node = chunks[x, y];

                    while (node != null)
                    {
                        yield return (T)node.Parent;
                        node = node.Next;
                    }
                }
        }

        public IEnumerable<T> HitTest(double _x, double _y)
        {
            if (_x < 0 || _x >= w || _y <= 0 || _y >= h)
                yield break;

            var x = (int)_x / CHUNK_SIZE;
            var y = (int)_y / CHUNK_SIZE;
            var node = chunks[x, y];

            while (node != null)
            {
                yield return (T)node.Parent;
                node = node.Next;
            }
        }

        public void Insert(T obj, float newX, float newY)
        {
            if (obj.CollisionNode != null)
                return;

            var x = (int)(newX / CHUNK_SIZE);
            var y = (int)(newY / CHUNK_SIZE);

            obj.CollisionNode = new CollisionNode<T>()
            {
                Data = GetData(x, y),
                Parent = obj
            };
            obj.Parent = this;

            if (chunks[x, y] == null)
                chunks[x, y] = obj.CollisionNode;
            else
                chunks[x, y].InsertAfter(obj.CollisionNode);
        }

        public void Move(T obj, float newX, float newY)
        {
            if (obj.CollisionNode == null)
            {
                Insert(obj, newX, newY);
                return;
            }

            if (obj.Parent != this)
                return;

            var x = (int)(newX / CHUNK_SIZE);
            var y = (int)(newY / CHUNK_SIZE);
            var newDat = GetData(x, y);

            if (obj.CollisionNode.Data != newDat)
            {
                var oldX = (int)(obj.X / CHUNK_SIZE);
                var oldY = (int)(obj.Y / CHUNK_SIZE);

                if (chunks[oldX, oldY] == obj.CollisionNode)
                    chunks[oldX, oldY] = obj.CollisionNode.Remove();
                else
                    obj.CollisionNode.Remove();

                if (chunks[x, y] == null)
                    chunks[x, y] = obj.CollisionNode;
                else
                    chunks[x, y].InsertAfter(obj.CollisionNode);

                obj.CollisionNode.Data = newDat;
            }
        }

        public void Remove(T obj)
        {
            if (obj.CollisionNode == null)
                return;

            if (obj.Parent != this)
                return;

            var x = (int)(obj.X / CHUNK_SIZE);
            var y = (int)(obj.Y / CHUNK_SIZE);

            if (chunks[x, y] == obj.CollisionNode)
                chunks[x, y] = obj.CollisionNode.Remove();
            else
                obj.CollisionNode.Remove();
        }

        private int GetData(int chunkX, int chunkY) => chunkX | chunkY << 8 | type << 16;
    }
}
