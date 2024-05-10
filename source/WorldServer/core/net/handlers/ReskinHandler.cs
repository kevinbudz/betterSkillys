using Shared;
using System.Linq;
using WorldServer.networking;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    internal class ReskinHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.RESKIN;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var skinType = (ushort)rdr.ReadInt32();

            if (client.Player == null)
                return;

            var gameData = client.GameServer.Resources.GameData;

            client.Account.Reload("skins"); // get newest skin data

            var ownedSkins = client.Account.Skins;
            var currentClass = client.Player.ObjectType;

            var skinData = gameData.Skins;
            var skinSize = 100;

            if (skinType != 0)
            {
                skinData.TryGetValue(skinType, out var skinDesc);

                if (skinDesc == null)
                {
                    client.Player.SendError("Unknown skin type.");
                    return;
                }

                if (!ownedSkins.Contains(skinType))
                {
                    client.Player.SendError("Skin not owned.");
                    return;
                }

                if (skinDesc.PlayerClassType != currentClass)
                {
                    client.Player.SendError("Skin is for different class.");
                    return;
                }

                skinSize = skinDesc.Size;
            }

            // set skin
            client.Player.Skin = skinType;
            client.Player.Size = skinSize;
        }
    }
}
