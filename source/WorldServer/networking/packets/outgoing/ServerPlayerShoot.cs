using Shared;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public class ServerPlayerShoot : OutgoingMessage
    {
        public int BulletType { get; set; } // dont serialize
        public int ObjectType { get; set; } // dont serialize

        public int BulletId { get; set; }
        public int OwnerId { get; set; }
        public int ContainerType { get; set; }
        public Position StartingPos { get; set; }
        public float Angle { get; set; }
        public int Damage { get; set; }

        public override MessageId MessageId => MessageId.SERVERPLAYERSHOOT;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(BulletId);
            wtr.Write(OwnerId);
            wtr.Write(ContainerType);
            StartingPos.Write(wtr);
            wtr.Write(Angle);
            wtr.Write(Damage);
        }
    }
}
