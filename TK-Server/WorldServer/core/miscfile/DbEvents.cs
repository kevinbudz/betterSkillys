using System;
using System.Text;

namespace WorldServer.core.miscfile
{
    public sealed class DbEventArgs : EventArgs
    {
        public string Message { get; private set; }
        public DbEventArgs(string message) => Message = message;
    }

    public sealed class DbEvents
    {
        public event EventHandler<DbEventArgs> Expired;

        public DbEvents(GameServer manager)
        {
            var db = manager.Database;

            // setup event for expiring keys
            db.Subscriber.Subscribe($"__keyevent@{db.DatabaseIndex}__:expired", (s, buff) =>
            {
                Expired?.Invoke(this, new DbEventArgs(Encoding.UTF8.GetString(buff)));
            });
        }
    }
}
