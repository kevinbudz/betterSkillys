using Shared;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public class GotoMessage : OutgoingMessage
    {
        private readonly int ObjectId;
        private readonly Position Position;

        public override MessageId MessageId => MessageId.GOTO;

        public GotoMessage(int objectId, Position position)
        {
            ObjectId = objectId;
            Position = position;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(ObjectId);
            Position.Write(wtr);
        }
    }
}
