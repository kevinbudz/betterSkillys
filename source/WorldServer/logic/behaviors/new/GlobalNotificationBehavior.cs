using System;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.logic.behaviors
{
    public class GlobalNotificationBehavior : Behavior
    {
        private readonly string _message;

        public GlobalNotificationBehavior(string message)
        {
            _message = message;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            foreach (var player in host.World.Players.Values)
            {
                player.Client.SendPacket(new GlobalNotificationMessage(0, _message));
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
