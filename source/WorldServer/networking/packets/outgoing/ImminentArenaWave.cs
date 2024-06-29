using Shared;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class ImminentArenaWave : OutgoingMessage
    {
        private readonly int CurrentRuntime;
        private readonly int Wave;
        private readonly int CurrentState;
        public override MessageId MessageId => MessageId.IMMINENT_ARENA_WAVE;

        public ImminentArenaWave(int runtime, int wave, int currentState)
        {
            CurrentRuntime = runtime;
            Wave = wave;
            CurrentState = currentState;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(CurrentRuntime);
            wtr.Write(Wave);
            wtr.Write(CurrentState);
        }
    }
}
