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

        public override MessageId MessageId => MessageId.IMMINENT_ARENA_WAVE;

        public ImminentArenaWave(int runtime, int wave)
        {
            CurrentRuntime = runtime;
            Wave = wave;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(CurrentRuntime);
            wtr.Write(Wave);
        }
    }
}
