using System;
using System.Collections.Generic;
using System.Net.Sockets;

namespace WorldServer.core.connection
{
    public sealed class SocketAsyncEventArgsPool
    {
        private Stack<SocketAsyncEventArgs> Pool;

        public SocketAsyncEventArgsPool(int capacity) => Pool = new Stack<SocketAsyncEventArgs>(capacity);

        public int Count => Pool.Count;

        public SocketAsyncEventArgs Pop()
        {
            using (TimedLock.Lock(Pool))
                return Pool.Pop();
        }

        public void Push(SocketAsyncEventArgs item)
        {
            if (item == null)
                throw new ArgumentNullException("Items added to a SocketAsyncEventArgsPool cannot be null");

            using (TimedLock.Lock(Pool))
                if (!Pool.Contains(item))
                    Pool.Push(item);
        }
    }
}
