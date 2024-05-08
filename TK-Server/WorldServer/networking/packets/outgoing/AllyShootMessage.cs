using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class AllyShootMessage : OutgoingMessage
    {
        private readonly int BulletId;
        private readonly int OwnerId;
        private readonly int ContainerType;
        private readonly float Angle;

        public override MessageId MessageId => MessageId.ALLYSHOOT;

        public AllyShootMessage(int bulletId, int ownerId, int containerType, float angle)
        {
            BulletId = bulletId;
            OwnerId = ownerId;
            ContainerType = containerType;
            Angle = angle;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(BulletId);
            wtr.Write(OwnerId);
            wtr.Write(ContainerType);
            wtr.Write(Angle);
        }
    }
}
