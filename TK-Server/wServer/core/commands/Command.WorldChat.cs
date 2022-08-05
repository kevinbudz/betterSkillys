﻿using wServer.core.objects;
using wServer.networking.packets.outgoing;

namespace wServer.core.commands
{
    public abstract partial class Command
    {
        internal class WorldChat : Command
        {
            public WorldChat() : base("wc", permLevel: 30)
            { }

            protected override bool Process(Player player, TickTime time, string args)
            {
                if (args.Length == 0)
                {
                    player.SendHelp("Usage: /wc <saytext>");
                    return false;
                }

                var saytext = string.Join(" ", args);


                var worlds = player.GameServer.WorldManager.GetWorlds();
                foreach (var world in worlds)
                    world.ForeachPlayer(_ => _.Client.SendPacket(new Text
                    {
                        BubbleTime = 10,
                        NumStars = player.Stars,
                        Name = player.Name,
                        Txt = $" {saytext}",
                        NameColor = player.ColorNameChat,
                        TextColor = player.ColorChat
                    }));
                return true;
            }
        }
    }
}
