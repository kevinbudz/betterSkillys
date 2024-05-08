using System;

namespace Shared.isc
{
    public class InterServerEventArgs<T> : EventArgs
    {
        public InterServerEventArgs(string instId, T val)
        {
            InstanceId = instId;
            Content = val;
        }

        public T Content { get; private set; }
        public string InstanceId { get; private set; }
    }
}
