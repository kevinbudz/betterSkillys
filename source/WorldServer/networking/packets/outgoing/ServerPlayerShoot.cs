using Shared;
using Shared.resources;
using WorldServer.core.structures;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class ServerPlayerShoot : OutgoingMessage
    {
        // Client Related Info
        public int BulletId { get; set; }
        public int OwnerId { get; set; }
        public int ContainerType { get; set; }
        public Position StartingPos { get; set; }
        public float Angle { get; set; }
        public int Damage { get; set; }

        // Used for Validation
        public int ObjectType { get; set; }
        public ProjectileDesc ProjectileDesc { get; set; }

        public override MessageId MessageId => MessageId.SERVERPLAYERSHOOT;

        public ServerPlayerShoot(int bulletId, int ownerId, int containerType, Position startPosition, float angle, int damage, int objectType, ProjectileDesc projectileDesc)
        {
            BulletId = bulletId;
            OwnerId = ownerId;
            ContainerType = containerType;
            StartingPos = startPosition;
            Angle = angle;
            Damage = damage;

            ObjectType = objectType;
            ProjectileDesc = projectileDesc;
        }

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
