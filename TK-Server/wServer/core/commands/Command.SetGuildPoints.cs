﻿using wServer.core.objects;

namespace wServer.core.commands
{
    public abstract partial class Command
    {
        internal class SetGuildPoints : Command
        {
            public SetGuildPoints() : base("uac", permLevel: 120)
            {
            }

            protected override bool Process(Player player, TickTime time, string args)
            {
                var db = player.GameServer.Database;
                db.UpdateAllCurrency();
                player.SendInfo("Success!");
                return true;
            }
        }
    }
}
