using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.utils;

namespace WorldServer.logic.transitions
{
    internal class OnParentDeathTransition : Transition
    {
        private bool parentDead;
        private bool init;
        public OnParentDeathTransition(string targetState)
            : base(targetState)
        {
            parentDead = false;
            init = false;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (!init && host is Enemy)
            {
                init = true;
                var enemyHost = host as Enemy;
                if (enemyHost.ParentEntity != null)
                {
                    (host as Enemy).ParentEntity.OnDeath +=
                         (sender, e) => parentDead = true;
                }
            }

            return parentDead;
        }
    }
}
