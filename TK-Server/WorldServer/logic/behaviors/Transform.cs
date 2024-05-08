using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.logic;

namespace WorldServer.logic.behaviors
{
    internal class Transform : Behavior
    {
        private readonly ushort target;

        public Transform(string target) => this.target = GetObjType(target);

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var entity = Entity.Resolve(host.GameServer, target);

            if (entity is Portal && host.World.IdName.Contains("Arena"))
                return;

            entity.Move(host.X, host.Y);

            if (host is Enemy && entity is Enemy && (host as Enemy).Spawned)
            {
                (entity as Enemy).Spawned = true;
                (entity as Enemy).ApplyPermanentConditionEffect(ConditionEffectIndex.Invisible);
            }

            host.World.EnterWorld(entity);
            host.World.LeaveWorld(host);
        }
    }
}
