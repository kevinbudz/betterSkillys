using Shared.database;
using System.Timers;
using Shared.database.market;

namespace WorldServer.core
{
    public sealed class MarketSweeper
    {
        private Database Database { get; set; }
        private Timer Timer { get; set; }

        public MarketSweeper(Database database)
        {
            Database = database;
            Timer = new Timer(60000);
            Timer.Elapsed += Timer_Elapsed;
        }

        public void Start() => Timer.Start();
        public void Stop() => Timer.Stop();

        private void Timer_Elapsed(object sender, ElapsedEventArgs e) => DbMarketData.CleanMarket(Database);
    }
}
