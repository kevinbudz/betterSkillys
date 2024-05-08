using Shared;
using WorldServer.networking;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.net.handlers
{
    public class PlayerMessage
    {
        public Player Player { get; private set; }
        public string Message { get; private set; }
        public long Time { get; private set; }

        public PlayerMessage(Player player, TickTime time, string msg)
        {
            Player = player;
            Message = msg;
            Time = time.TotalElapsedMs;
        }
    }

    public class PlayerTextHandler : IMessageHandler
    {
        public override MessageId MessageId => MessageId.PLAYERTEXT;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime tickTime)
        {
            var text = rdr.ReadUTF16();

            var player = client.Player;
            if (player?.World == null || text.Length > 512)
                return;

            var manager = player.GameServer;

            // check for commands before other checks
            if (text[0] == '/')
            {
                manager.CommandManager.Execute(player, tickTime, text);
            }
            else
            {
                if (!player.NameChosen)
                {
                    player.SendError("Please choose a name before chatting.");
                    return;
                }

                if (player.Muted)
                {
                    player.SendError("Muted. You can not talk at this time.");
                    return;
                }

                if (player.CompareAndCheckSpam(text, tickTime.TotalElapsedMs))
                {
                    return;
                }

                if (!player.IsAdmin)
                    if (!player.GameServer.Configuration.serverInfo.testing && player.Stars < 2)
                    {
                        player.SendHelp("To use this feature you need 2 stars");
                        return;
                    }

                // save message for mob behaviors
                player.World.ChatReceived(player, text);

                manager.ChatManager.Say(player, text);
            }
        }
    }
}
