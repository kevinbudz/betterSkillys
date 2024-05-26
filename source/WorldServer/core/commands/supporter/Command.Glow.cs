using Shared;
using System;
using WorldServer.core.net.datas;
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

        internal class Size : Command
        {
            public override RankingType RankRequirement => RankingType.Donator;
            public override string CommandName => "size";

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (string.IsNullOrEmpty(args))
                {
                    player.SendError("Usage: /size <positive integer>. Using 0 will restore the default size for the sprite.");
                    return false;
                }

                var size = Utils.FromString(args);
                var min = 20;
                var max = 0;
                var acc = player.Client.Account;

                switch (acc.Rank)
                {
                    case 1: max = 120; break;
                    case 2: max = 150; break;
                    case 3: max = 200; break;
                    case 4:
                    case 5:
                    case 6: max = 250; break;
                }

                if (size < min && size != 0 || size > max)
                {
                    player.SendError($"Invalid size. Size needs to be within the range: {min}-{max}. Use 0 to reset size to default.");
                    return false;
                }

                acc.Size = size;
                acc.FlushAsync();

                if (size == 0)
                    player.Size = 100;
                else
                    player.Size = size;

                return true;
            }
        }
    }
}
