using Shared;
using Shared.resources;
using System;
using WorldServer.core.structures;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private readonly int[] _slotEffectCooldowns = new int[4];
        private void PlayerShootEffects(float angle)
        {
            for (var i = 0; i < 4; i++)
            {
                if (CantApplySlotEffect(i))
                    continue;

                var item = Inventory[i];
                if (item == null)
                    continue;

                ActivateEffect[] effs = item.OnPlayerShootActivateEffects;
                for (int l = 0; l < effs.Length; l++)
                {
                    if (!CheckParams(effs[l]))
                        continue;
                    var position = PointAt(angle, effs[l].TargetMouseRange);
                    OnOtherActivate(effs, item, position);
                    SetSlotEffectCooldown(effs[l].Cooldown, i);
                }
            }
        }
        private void PlayerHitEffects(int damage)
        {
            for (var i = 0; i < 4; i++)
            {
                if (CantApplySlotEffect(i))
                    continue;

                var item = Inventory[i];
                if (item == null)
                    continue;

                ActivateEffect[] effs = item.OnPlayerShootActivateEffects;
                for (int l = 0; l < effs.Length; l++)
                {
                    if (!CheckParams(effs[l], damage))
                        continue;
                    OnOtherActivate(effs, item, Position);
                    SetSlotEffectCooldown(effs[l].Cooldown, i);
                }
            }
        }
        private void EnemyHitEffects()
        {
            for (var i = 0; i < 4; i++)
            {
                if (CantApplySlotEffect(i))
                    continue;

                var item = Inventory[i];
                if (item == null)
                    continue;

                ActivateEffect[] effs = item.OnEnemyHitActivateEffects;
                for (int l = 0; l < effs.Length; l++)
                {
                    if (!CheckParams(effs[l]))
                        continue;
                    OnOtherActivate(effs, item, Position);
                    SetSlotEffectCooldown(effs[l].Cooldown, i);
                }
            }
        }
        private void AbilityUseEffects(Position pos)
        {
            for (var i = 0; i < 4; i++)
            {
                if (CantApplySlotEffect(i))
                    continue;

                var item = Inventory[i];
                if (item == null)
                    continue;

                ActivateEffect[] effs = item.OnPlayerAbilityActivateEffects;
                for (int l = 0; l < effs.Length; l++)
                {
                    if (!CheckParams(effs[l]))
                        continue;
                    OnOtherActivate(effs, item, pos);
                    SetSlotEffectCooldown(effs[l].Cooldown, i);
                }
            }
        }
        private void PassiveEffects()
        {
            for (var i = 0; i < 4; i++)
            {
                if (CantApplySlotEffect(i))
                    continue;

                var item = Inventory[i];
                if (item == null)
                    continue;

                ActivateEffect[] effs = item.OnPlayerPassiveActivateEffects;
                for (int l = 0; l < effs.Length; l++)
                {
                    if (!CheckParams(effs[l]))
                        continue;
                    OnOtherActivate(effs, item, Position);
                    SetSlotEffectCooldown(effs[l].Cooldown, i);
                }
            }
        }
        private bool CheckParams(ActivateEffect eff, int damage = 0)
        {
            if (eff.Proc != 0)
            {
                var rand = new Random();
                var doub = rand.NextDouble();
                if (eff.Proc < doub)
                    return false;
            }
            if (eff.RequiredConditions != null)
                if (!HasConditionEffect(Utils.GetEffect(eff.RequiredConditions)))
                    return false;
            if (eff.DamageThreshold != 0)
                if (damage < eff.DamageThreshold)
                    return false;
            if (eff.HealthThreshold != 0)
                if (Health > eff.HealthThreshold)
                    return false;
            if (eff.HealthRequired != 0)
                if (Health < eff.HealthRequired)
                    return false;
            if (eff.HealthRequiredRelative != 0)
                if (Health / MaxHealth < eff.HealthRequiredRelative)
                    return false;
            if (eff.ManaCost != 0)
                if (Mana < eff.ManaCost)
                    return false;
            if (eff.ManaRequired != 0)
                if (Mana < eff.ManaRequired)
                    return false;
            return true;
        }
    }
}
