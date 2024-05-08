using System.Collections.Generic;
using System.Net.Sockets;

namespace WorldServer.core.connection
{
    public sealed class BufferManager
    {
        public BufferManager(int totalBytes, int totalBufferBytesInEachSaeaObject)
        {
            TotalBytesInBufferBlock = totalBytes;
            CurrentIndex = 0;
            BufferBytesAllocatedForEachSaea = totalBufferBytesInEachSaeaObject;
            FreeIndexPool = new Stack<int>();
        }

        private byte[] BufferBlock { get; set; }
        private int BufferBytesAllocatedForEachSaea { get; set; }
        private int CurrentIndex { get; set; }
        private Stack<int> FreeIndexPool { get; set; }
        private int TotalBytesInBufferBlock { get; set; }

        public void FreeBuffer(SocketAsyncEventArgs args)
        {
            FreeIndexPool.Push(args.Offset);
            args.SetBuffer(null, 0, 0);
        }

        public void InitBuffer() => BufferBlock = new byte[TotalBytesInBufferBlock];

        public bool SetBuffer(SocketAsyncEventArgs args)
        {
            if (FreeIndexPool.Count > 0)
                args.SetBuffer(BufferBlock, FreeIndexPool.Pop(), BufferBytesAllocatedForEachSaea);
            else
            {
                if (TotalBytesInBufferBlock - BufferBytesAllocatedForEachSaea < CurrentIndex)
                    return false;

                args.SetBuffer(BufferBlock, CurrentIndex, BufferBytesAllocatedForEachSaea);

                CurrentIndex += BufferBytesAllocatedForEachSaea;
            }
            return true;
        }
    }
}
