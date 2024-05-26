using Shared.resources;
using WorldServer.core.objects;
using WorldServer.networking;

namespace WorldServer.core.worlds.impl
{
    public sealed class RealmWorld : World
    {
        public bool Closed { get; private set; }
        public RealmManager RealmManager { get; private set; }

        public RealmWorld(GameServer gameServer, int id, WorldResource resource) : base(gameServer, id, resource)
        {
            RealmManager = new RealmManager(this);
            IsRealm = true;
        }

        public void SetMaxPlayers(int capacity) => MaxPlayers = capacity;

        public override void Init()
        {
            base.Init();
            RealmManager.Init();
            SetPieces.ApplySetPieces(this);
        }

        public override bool AllowedAccess(Client client) => !Closed || client.Account.Admin;

        protected override void UpdateLogic(ref TickTime time)
        {
            if (IsPlayersMax())
                GameServer.WorldManager.Nexus.PortalMonitor.ClosePortal(Id);
            else if (!GameServer.WorldManager.Nexus.PortalMonitor.PortalIsOpen(Id))
                GameServer.WorldManager.Nexus.PortalMonitor.OpenPortal(Id);

            RealmManager.Update(ref time);
            base.UpdateLogic(ref time);
        }

        public void EnemyKilled(Enemy enemy, Player killer)
        {
            if (!enemy.Spawned)
                RealmManager.OnEnemyKilled(enemy, killer);
        }

        public bool CloseRealm()
        {
            if (Closed)
                return false;
            Closed = true;
            RealmManager.DisableSpawning = true;
            RealmManager.CurrentState = RealmState.Emptying;
            GameServer.WorldManager.Nexus.PortalMonitor.RemovePortal(Id);
            FlagForClose();
            return true;
        }
    }
}
