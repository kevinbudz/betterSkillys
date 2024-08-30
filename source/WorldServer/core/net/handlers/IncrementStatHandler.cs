using Shared;
using System.Numerics;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.behaviors;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public sealed class IncrementStatHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.INCREMENT_STAT;

        public static string[] StatNames = ["Life", "Mana", "Attack", "Defense", "Speed", "Dexterity", "Vitality", "Wisdom"];

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var statIndex = rdr.ReadInt32();
            var increase = rdr.ReadInt32();

            Player player = client.Player;
            if (player == null)
                return;

            if (statIndex < 0 || statIndex > 7)
            {
                player.SendError("You are referencing an incorrect stat.");
                return;
            }

            if (increase == 0)
            {
                player.SendError("You aren't incrementing any stat!");
                return;
            }

            var statInfo = player.GameServer.Resources.GameData.Classes[player.ObjectType].Stats;
            var maxStatValue = statInfo[statIndex].MaxValue;

            if (player.Client.Account.Fame > 250)
                player.GameServer.Database.UpdateFame(player.Client.Account, -250);
            else
            {
                player.SendError("You don't have enough fame to upgrade this stat!");
                return;
            }

            if (player.Stats.Base[statIndex] >= maxStatValue + 10)
            {
                player.Stats.Base[statIndex] = maxStatValue + 10;
                player.SendError("You have maxed out this stat!");
                return;
            }
            else
                player.Stats.Base[statIndex] += increase;

            player.Stats.ReCalculateValues();
            player.SendInfo($"You have incremented your {StatNames[statIndex]} by {increase}");
        }
    }
}
