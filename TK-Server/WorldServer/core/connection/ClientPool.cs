using System;
using System.Collections.Generic;
using WorldServer.networking;

namespace WorldServer.core.connection
{
    public sealed class ClientPool
    {
        private Queue<Client> Pool;

        public ClientPool(int capacity) => Pool = new Queue<Client>(capacity);

        public int Count => Pool.Count;

        public Client Pop()
        {
            using (TimedLock.Lock(Pool))
                return Pool.Dequeue();
        }

        public void Push(Client client)
        {
            if (client == null)
                throw new ArgumentNullException("Clients added to a ClientPool cannot be null");

            using (TimedLock.Lock(Pool))
                if (!Pool.Contains(client))
                    Pool.Enqueue(client);
        }
    }
}
