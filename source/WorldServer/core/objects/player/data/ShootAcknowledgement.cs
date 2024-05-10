using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private struct ShootAcknowledgement
        {
            public readonly EnemyShootMessage EnemyShoot;
            public readonly ServerPlayerShoot ServerPlayerShoot;

            public ShootAcknowledgement(EnemyShootMessage enemyShoot)
            {
                EnemyShoot = enemyShoot;
                ServerPlayerShoot = null;
            }

            public ShootAcknowledgement(ServerPlayerShoot serverPlayerShoot)
            {
                EnemyShoot = null;
                ServerPlayerShoot = serverPlayerShoot;
            }
        }

    }
}
