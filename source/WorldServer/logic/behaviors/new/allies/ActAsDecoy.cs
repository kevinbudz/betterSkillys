using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    public class ActAsDecoy : Behavior
    {
        public Entity decoy;
        public ActAsDecoy() { }
        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            if (host == null)
                return;
            if (host.GetNearestEntity(20, null, true) is Player pw)
            {
                decoy = new Decoy(pw, 999999, 0, true, 0x4972);
                decoy.Move(host.X, host.Y);
                host.World.EnterWorld(decoy);
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
            if (decoy == null)
                return;    
            host.World.LeaveWorld(decoy);
        }
    }
}
