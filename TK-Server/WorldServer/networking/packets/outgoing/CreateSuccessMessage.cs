using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class CreateSuccessMessage : OutgoingMessage
    {
        private readonly int ObjectId;
        private readonly int CharId;

        public override MessageId MessageId => MessageId.CREATE_SUCCESS;

        public CreateSuccessMessage(int objectId, int charId)
        {
            ObjectId = objectId;
            CharId = charId;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(ObjectId);
            wtr.Write(CharId);
        }
    }
}
