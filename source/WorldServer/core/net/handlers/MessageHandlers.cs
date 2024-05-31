using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Shared;
using WorldServer.core.worlds;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public abstract class IMessageHandler
    {
        public abstract MessageId MessageId { get; }
        public abstract void Handle(Client client, NetworkReader rdr, ref TickTime time);

        public static bool IsAvailable(Client client) => client.GameServer.WorldManager.Nexus.MarketEnabled;

        public static bool IsEnabledOrAdminOnly(Client client)
        {
            var player = client.Player;
            if (player.Client.Account.Admin)
                return true;

            if (player.GameServer.Configuration.serverInfo.adminOnly)
            {
                if (!player.GameServer.IsWhitelisted(player.AccountId) || !player.Client.Account.Admin)
                {
                    player.SendError("This feature (as of right now) is Admin only!");
                    return false;
                }
            }
            return true;
        }
    }

    public static class MessageHandlers
    {
        private static Dictionary<MessageId, IMessageHandler> Handlers;

        static MessageHandlers()
        {
            Handlers = new Dictionary<MessageId, IMessageHandler>();

            try
            {
                foreach (var type in Assembly.GetAssembly(typeof(IMessageHandler)).GetTypes().Where(_ => _.IsClass && !_.IsAbstract && _.IsSubclassOf(typeof(IMessageHandler))))
                {
                    var handler = (IMessageHandler)Activator.CreateInstance(type);
                    Handlers.Add(handler.MessageId, handler);
                }
            }
            catch
            {
                Console.WriteLine();
            }
        }

        public static IMessageHandler GetHandler(MessageId messageId) => Handlers.TryGetValue(messageId, out var ret) ? ret : null;
    }
}
