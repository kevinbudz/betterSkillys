using Shared;
using WorldServer.core.structures;

namespace WorldServer.core.net.datas
{
    public struct TimedPosition
    {
        public Position Position;
        public int Time;

        public static TimedPosition Read(NetworkReader rdr) => new TimedPosition
        {
            Time = rdr.ReadInt32(),
            Position = Position.Read(rdr)
        };

        public override string ToString() => string.Format("{{Time: {0}, Position: {1}}}", Time, Position);
    }
}
