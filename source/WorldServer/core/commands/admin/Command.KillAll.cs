using System;
using System.Linq;
using Shared;
using Shared.utils;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class KillAll : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "killall";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (!(player.World is VaultWorld) && !player.Client.Account.Admin)
                {
                    player.SendError("Only in your Vault.");
                    return false;
                }

                var total = 0;
                foreach(var entity in player.World.Enemies.Values)
                {
                    if(entity.Dead || entity.ObjectDesc == null || entity.ObjectDesc.IdName == null || !entity.ObjectDesc.Enemy || !entity.ObjectDesc.IdName.ContainsIgnoreCase(args))
                        continue;

                    entity.Death(ref time);
                    total++;
                }
                player.SendInfo($"{total} enem{(total > 1 ? "ies" : "y")} killed!");
                return true;
            }
        }
    }
}
