using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.transitions
{
    public class DamageTakenTransition : Transition
    {
        //State storage: none

        private readonly int damage;
        private readonly bool wipeProgress;

        public DamageTakenTransition(int damage, string targetState, bool wipeProgress = false)
            : base(targetState)
        {
            this.damage = damage;
            this.wipeProgress = wipeProgress;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            int damageSoFar = 0;

            if (wipeProgress == true)
            {
                damageSoFar = 0;
            }

            foreach (var i in (host as Enemy).DamageCounter.GetPlayerData())
                damageSoFar += i.Item2;

            if (damageSoFar >= damage)
                return true;
            return false;
        }
    }
}
