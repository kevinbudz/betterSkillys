using Shared.resources;
using System;
using WorldServer.core.worlds;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private int _newbiePeriod;

        public bool IsVisibleToEnemy()
        {
            if (_newbiePeriod > 0)
                return false;

            if (HasConditionEffect(ConditionEffectIndex.Paused))
                return false;

            if (HasConditionEffect(ConditionEffectIndex.Invisible))
                return false;

            if (IsHidden)
                return false;
            return true;
        }

        internal void ResetNewbiePeriod() => _newbiePeriod = 3000;

        private bool CanRegenerateHealth() => !(HasConditionEffect(ConditionEffectIndex.Bleeding) || HasConditionEffect(ConditionEffectIndex.Sick));
        private bool CanRegenerateMana() => !(HasConditionEffect(ConditionEffectIndex.Quiet) || HasConditionEffect(ConditionEffectIndex.NinjaSpeedy));

        private void HandleEffects(ref TickTime time)
        {
            if (Client == null || Client.Account == null)
                return;
            
            if (HasConditionEffect(ConditionEffectIndex.Quiet) && Mana > 0)
                Mana = 0;

            if (HasConditionEffect(ConditionEffectIndex.Bleeding) && Health > 1)
            {
                Health -= (int)(20 * time.DeltaTime); // 20 per second
                if (Health < 1)
                    Health = 1;
            }

            if (HasConditionEffect(ConditionEffectIndex.NinjaSpeedy))
            {
                Mana -= (int)(10 * time.DeltaTime);
                if (Mana == 0)
                    RemoveCondition(ConditionEffectIndex.NinjaSpeedy);
            }

            if (HasConditionEffect(ConditionEffectIndex.ManaDeplete))
            {
                var abil = Inventory[1];
                if (abil != null)
                    Mana -= (int)(abil.ManaCostPerSecond * time.DeltaTime);
                if (Mana < abil.ManaCostPerSecond)
                    RemoveCondition(ConditionEffectIndex.ManaDeplete);
            }

            if (HasConditionEffect(ConditionEffectIndex.Inspired))
            {
                var weap = Inventory[0];
                if (weap == null)
                    return;
                weap.Projectiles[0].Speed = weap.Projectiles[0].NewSpeed;
            } else
            {
                var weap = Inventory[0];
                if (weap == null)
                    return;
                weap.Projectiles[0].Speed = weap.Projectiles[0].OrigSpeed;
            }

            if (_newbiePeriod > 0)
            {
                _newbiePeriod -= time.ElapsedMsDelta;
                if (_newbiePeriod < 0)
                    _newbiePeriod = 0;
            }

            if (_canTpCooldownTime > 0)
            {
                _canTpCooldownTime -= time.ElapsedMsDelta;
                if (_canTpCooldownTime <= 0)
                    _canTpCooldownTime = 0;
            }
        }
    }
}
