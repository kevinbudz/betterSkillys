using System;
using Shared;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.worlds;
using WorldServer.logic.loot;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class IncrementStat : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "incrementStat";

            public string[] StatNames = ["Life", "Mana", "Attack", "Defense", "Speed", "Dexterity", "Vitality", "Wisdom"];

            protected override bool Process(Player player, TickTime time, string args)
            {
                int space = args.IndexOf(" ");
                int statIndex = int.Parse(args.Substring(0, space));
                int increasedValue = int.Parse(args.Substring(space + 1));

                if (statIndex < 0 || statIndex > 7)
                {
                    player.SendError("You are referencing an incorrect stat.");
                    return false;
                }

                if (increasedValue == 0)
                {
                    player.SendError("You aren't incrementing any stat!");
                    return false;
                }

                player.Stats.Base[statIndex] += increasedValue;
                player.Stats.ReCalculateValues();
                player.SendInfo($"You have incremented your {StatNames[statIndex]} by {increasedValue}");
                return true;
            }
        }
    }
}
