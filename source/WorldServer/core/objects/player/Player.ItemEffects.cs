using Shared;
using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.net.datas;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private readonly int[] _slotEffectCooldowns = new int[4];

        private void TryApplySpecialEffects(ref TickTime time)
        {
            for (var slot = 0; slot < 4; slot++)
            {
                //if (!CanApplySlotEffect(slot))
                //    continue;

                //var item = Inventory[slot];
            }
        }

        private void TryAddOnEnemyHitEffect(ref TickTime tickTime, Enemy entity, ProjectileDesc projectileDesc)
        {
            for (var slot = 0; slot < 4; slot++)
            {
                //if (!CanApplySlotEffect(slot))
                //    continue;

                //var item = Inventory[slot];
            }
        }

        private void TryAddOnPlayerShootEffect()
        {
            for (var slot = 0; slot < 4; slot++)
            {
                //if (!CanApplySlotEffect(slot))
                //    continue;

                var item = Inventory[slot];
                if (item == null)
                    continue;

                foreach (ActivateEffect eff in item.OnPlayerShootActivateEffects)
                {
                    if (eff.Proc != 0)
                    {
                        var rand = new Random();
                        if (eff.Proc > rand.NextDouble())
                            OnOtherActivate("shoot", item, Position);
                    }
                    else
                        OnOtherActivate("shoot", item, Position);
                }
            }
        }

        private void TryAddOnPlayerHitEffect()
        {
            for (var slot = 0; slot < 4; slot++)
            {
                //if (!CanApplySlotEffect(slot))
                //    continue;

                var item = Inventory[slot];
                if (item == null)
                    continue;

                foreach (ActivateEffect eff in item.OnPlayerHitActivateEffects)
                {
                    if (eff.Proc != 0)
                    {
                        var rand = new Random();
                        if (eff.Proc > rand.NextDouble())
                            OnOtherActivate("hit", item, Position);
                    }
                    else
                        OnOtherActivate("hit", item, Position);
                }
            }
        }
    }
}
