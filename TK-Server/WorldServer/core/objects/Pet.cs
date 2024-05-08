namespace WorldServer.core.objects
{
    public class Pet : Entity, IPlayer
    {
        public Pet(GameServer manager, Player player, ushort objType) : base(manager, objType) => PlayerOwner = player;

        public Player PlayerOwner { get; set; }

        public void Damage(int dmg, Entity src) { }

        public bool IsVisibleToEnemy() => false;
    }
}
