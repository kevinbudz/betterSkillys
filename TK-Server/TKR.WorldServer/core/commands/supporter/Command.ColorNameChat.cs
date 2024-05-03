using TKR.Shared;
using System;
using TKR.WorldServer.core.objects;
using TKR.WorldServer.core.worlds;

namespace TKR.WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class ColorNameChat : Command
        {
            public override RankingType RankRequirement => RankingType.Supporter1;
            public override string CommandName => "namecolor";

            protected override bool Process(Player player, TickTime time, string color)
            {
                if (string.IsNullOrWhiteSpace(color))
                {
                    player.SendInfo("Usage: /namecolor <color> \n (use hexcode format: 0xFFFFFF)");
                    return true;
                }

                player.ColorNameChat = Utils.FromString(color);

                var acc = player.Client.Account;
                acc.ColorNameChat = player.ColorNameChat;
                acc.FlushAsync();

                return true;
            }
        }
    }
}
