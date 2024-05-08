namespace WorldServer.core.objects.player
{
    public class TimeCop
    {
        private readonly int _capacity;
        private int[] _clientDeltaLog;
        private int _clientElapsed;
        private int _count;
        private int _index;
        private int _lastClientTime;
        private int _lastServerTime;
        private int[] _serverDeltaLog;
        private int _serverElapsed;

        public TimeCop(int capacity = 20)
        {
            _capacity = capacity;
            _clientDeltaLog = new int[_capacity];
            _serverDeltaLog = new int[_capacity];
        }

        public int LastClientTime() => _lastClientTime;

        public int LastServerTime() => _lastServerTime;

        public void Push(int clientTime, int serverTime)
        {
            var dtClient = 0;
            var dtServer = 0;
            if (_count != 0)
            {
                dtClient = clientTime - _lastClientTime;
                dtServer = serverTime - _lastServerTime;
            }
            _count++;
            _index = (_index + 1) % _capacity;
            _clientElapsed += dtClient - _clientDeltaLog[_index];
            _serverElapsed += dtServer - _serverDeltaLog[_index];
            _clientDeltaLog[_index] = dtClient;
            _serverDeltaLog[_index] = dtServer;
            _lastClientTime = clientTime;
            _lastServerTime = serverTime;
        }

        /*
            a return value of 1 means client time is in sync with server time
            less than 1 means client time is slower than server time
            greater than 1 means client time is faster than server
        */

        public float TimeDiff()
        {
            if (_count < _capacity)
                return 1;
            return (float)_clientElapsed / _serverElapsed;
        }
    }
}
