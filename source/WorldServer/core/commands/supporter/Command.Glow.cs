using Shared;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Glow : Command
        {
            public override RankingType RankRequirement => RankingType.Donator;
            public override string CommandName => "glow";

            protected override bool Process(Player player, TickTime time, string color)
            {
                if (string.IsNullOrWhiteSpace(color))
                {
                    player.SendInfo("Usage: /glow <color> \n Number of the color needs to be a HexCode (0xFFFFFF = White, use 0x instahead #), search in google HexCode + Color.");
                    return true;
                }

                player.Glow = Utils.FromString(color);

                var acc = player.Client.Account;
                acc.GlowColor = player.Glow;
                acc.FlushAsync();

                return true;
            }
        }
    }
}
