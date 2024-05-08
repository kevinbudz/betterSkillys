using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class DropPortalOnDeath : Behavior
    {
        private readonly float _probability;
        private readonly ushort _target;
        private readonly int? _timeout;
        private readonly float xAdjustment;
        private readonly float yAdjustment;

        public DropPortalOnDeath(string target, double probability = 1, int? timeout = null)
        {
            _target = GetObjType(target);
            _probability = (float)probability;
            _timeout = timeout; // a value of 0 means never timeout,
            // null means use xml timeout,
            // a value means override xml timeout with that value (in seconds)
        }

        public DropPortalOnDeath(string target, int probability = 1, int dropDelaySec = 0, float XAdjustment = 0, float YAdjustment = 0, int? timeout = null)
        {
            _target = GetObjType(target);
            _probability = probability;

            xAdjustment = XAdjustment;
            yAdjustment = YAdjustment;

            _timeout = timeout;
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
            var owner = host.World;

            if (owner.IdName.Contains("Arena") || host.Spawned)
                return;

            if (Random.NextDouble() < _probability)
            {
                var manager = host.GameServer;
                var gameData = manager.Resources.GameData;
                var timeoutTime = _timeout == null ? gameData.Portals[_target].Timeout : _timeout.Value;
                var entity = Entity.Resolve(manager, _target);
                entity.Move(host.X, host.Y);
                entity.Move(host.X + xAdjustment, host.Y + yAdjustment);
                owner.EnterWorld(entity);

                if (timeoutTime != 0)
                    owner.StartNewTimer(timeoutTime * 1000, (world, t) => //default portal close time * 1000
                    {
                        try { world.LeaveWorld(entity); }
                        //couldn't remove portal, Owner became null. Should be fixed with RealmManager implementation
                        catch { Console.WriteLine("Couldn't despawn portal."); }
                    });
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
