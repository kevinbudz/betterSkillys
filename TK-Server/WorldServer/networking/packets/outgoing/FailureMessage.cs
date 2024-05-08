using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class FailureMessage : OutgoingMessage
    {
        public const int MessageNoDisconnect = -1;
        public const int MessageWithDisconnect = 0;
        public const int ClientUpdateNeeded = 1;
        public const int ForceCloseGame = 2;
        public const int InvalidTeleportTarget = 3;

        public int ErrorId { get; private set; }
        public string ErrorDescription { get; private set; }

        public override MessageId MessageId => MessageId.FAILURE;

        public FailureMessage(int errorId, string errorDescription)
        {
            ErrorId = errorId;
            ErrorDescription = errorDescription;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(ErrorId);
            wtr.WriteUTF16(ErrorDescription);
        }
    }
}
