using Shared;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class MemoryCommand : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "memory";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var currentProcess = System.Diagnostics.Process.GetCurrentProcess();
                currentProcess.Refresh();

                var bytes = currentProcess.PrivateMemorySize64;
                player.SendInfo($"Server is using: {SizeSuffix(bytes)}");
                return true;
            }


            private static readonly string[] SizeSuffixes = { "b", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };
            private static string SizeSuffix(long value, int decimalPlaces = 2)
            {
                if (decimalPlaces < 0)
                    throw new ArgumentOutOfRangeException("decimalPlaces");

                if (value < 0)
                    return "-" + SizeSuffix(-value, decimalPlaces);

                if (value == 0)
                    return string.Format("{0:n" + decimalPlaces + "} bytes", 0);

                var mag = (int)Math.Log(value, 1024);
                var adjustedSize = (decimal)value / (1L << (mag * 10));

                if (Math.Round(adjustedSize, decimalPlaces) >= 1000)
                {
                    mag += 1;
                    adjustedSize /= 1024;
                }
                return string.Format("{0:n" + decimalPlaces + "} {1}", adjustedSize, SizeSuffixes[mag]);
            }
        }
    }
}
