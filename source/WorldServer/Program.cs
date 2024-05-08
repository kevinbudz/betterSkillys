using WorldServer.core;

namespace WorldServer
{
    public sealed class Program
    {
        private static void Main(string[] args)
        {
            new GameServer(args).Run();
        }
    }
}
