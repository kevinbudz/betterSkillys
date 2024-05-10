using Shared;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Max : Command
        {
            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "max";

            protected override bool Process(Player player, TickTime time, string args)
            {
                var pd = player.GameServer.Resources.GameData.Classes[player.ObjectType];

                player.Stats.Base[0] = pd.Stats[0].MaxValue;
                player.Stats.Base[1] = pd.Stats[1].MaxValue;
                player.Stats.Base[2] = pd.Stats[2].MaxValue;
                player.Stats.Base[3] = pd.Stats[3].MaxValue;
                player.Stats.Base[4] = pd.Stats[4].MaxValue;
                player.Stats.Base[5] = pd.Stats[5].MaxValue;
                player.Stats.Base[6] = pd.Stats[6].MaxValue;
                player.Stats.Base[7] = pd.Stats[7].MaxValue;

                player.Level = 20;
                player.Experience = Player.GetLevelExp(20);

                player.SendInfo("Your stats have been maxed.");
                return true;
            }
        }
    }
}
