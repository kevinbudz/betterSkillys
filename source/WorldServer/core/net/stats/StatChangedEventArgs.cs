using System;

namespace WorldServer.core.net.stats
{
    public sealed class StatChangedEventArgs : EventArgs
    {
        public StatDataType Stat { get; private set; }
        public bool UpdateSelfOnly { get; private set; }
        public object Value { get; private set; }

        public StatChangedEventArgs(StatDataType stat, object value, bool updateSelfOnly = false)
        {
            Stat = stat;
            Value = value;
            UpdateSelfOnly = updateSelfOnly;
        }
    }
}
