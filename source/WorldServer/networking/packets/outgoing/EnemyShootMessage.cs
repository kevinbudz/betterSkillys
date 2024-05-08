using Shared;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public class EnemyShootMessage : OutgoingMessage
    {
        public int ObjectType { get; set; } // dont serialize
        public bool Spawned { get; set; } // dont serialize

        public int BulletId { get; set; }
        public int OwnerId { get; set; }
        public byte BulletType { get; set; }
        public Position StartingPos { get; set; }
        public float Angle { get; set; }
        public int Damage { get; set; }
        public byte NumShots { get; set; }
        public float AngleInc { get; set; }

        public override MessageId MessageId => MessageId.ENEMYSHOOT;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(BulletId);
            wtr.Write(OwnerId);
            wtr.Write(BulletType);
            StartingPos.Write(wtr);
            wtr.Write(Angle);
            wtr.Write(Damage);
            wtr.Write(NumShots);
            wtr.Write(AngleInc);
        }
    }
}
