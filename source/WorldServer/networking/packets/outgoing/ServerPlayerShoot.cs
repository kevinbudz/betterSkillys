using Shared;
using Shared.resources;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class ServerPlayerShoot : OutgoingMessage
    {
        // Client Related Info
        public int ObjectId { get; set; }
        public int BulletId { get; set; }
        public int ContainerType { get; set; }
        public Position StartingPos { get; set; }
        public float Angle { get; set; }
        public int Damage { get; set; }

        // Used for Validation
        public ProjectileDesc ProjectileDesc { get; set; }

        public override MessageId MessageId => MessageId.SERVERPLAYERSHOOT;

        public ServerPlayerShoot(int objectId, int bulletId, int containerType, Position startPosition, float angle, int damage, ProjectileDesc projectileDesc)
        {
            ObjectId = objectId;
            BulletId = bulletId;
            ContainerType = containerType;
            StartingPos = startPosition;
            Angle = angle;
            Damage = damage;

            ProjectileDesc = projectileDesc;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(BulletId);
            wtr.Write(ObjectId);
            wtr.Write(ContainerType);
            StartingPos.Write(wtr);
            wtr.Write(Angle);
            wtr.Write(Damage);
        }
    }
}
