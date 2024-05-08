using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.setpieces;
using WorldServer.networking;

namespace WorldServer.core.worlds.impl
{
    public class RealmWorld : World
    {
        public bool Closed { get; private set; }
        public RealmManager KingdomManager { get; private set; }

        public RealmWorld(GameServer gameServer, int id, WorldResource resource) : base(gameServer, id, resource)
        {
            KingdomManager = new RealmManager(this);
            IsRealm = true;
        }

        public void SetMaxPlayers(int capacity) => MaxPlayers = capacity;

        public override void Init()
        {
            base.Init();
            KingdomManager.Init();
            SetPieces.ApplySetPieces(this);
        }

        public override bool AllowedAccess(Client client) => !Closed || client.Rank.IsAdmin;

        protected override void UpdateLogic(ref TickTime time)
        {
            if (IsPlayersMax())
                GameServer.WorldManager.Nexus.PortalMonitor.ClosePortal(Id);
            else if (!GameServer.WorldManager.Nexus.PortalMonitor.PortalIsOpen(Id))
                GameServer.WorldManager.Nexus.PortalMonitor.OpenPortal(Id);

            KingdomManager.Update(ref time);
            base.UpdateLogic(ref time);
        }

        public void EnemyKilled(Enemy enemy, Player killer)
        {
            if (!enemy.Spawned)
                KingdomManager.OnEnemyKilled(enemy, killer);
        }


        public bool CloseRealm()
        {
            if (Closed)
                return false;
            Closed = true;
            KingdomManager.DisableSpawning = true;
            KingdomManager.CurrentState = RealmState.Emptying;
            GameServer.WorldManager.Nexus.PortalMonitor.RemovePortal(Id);
            FlagForClose();
            return true;
        }
    }
}
