using NLog;

namespace WorldServer.utils
{
    public static class StaticLogger
    {
        public static readonly Logger Instance = LogManager.GetCurrentClassLogger();
    }
}
