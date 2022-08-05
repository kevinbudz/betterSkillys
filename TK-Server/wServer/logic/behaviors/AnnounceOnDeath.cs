﻿using System.Linq;
using System.Text;
using wServer.core;
using wServer.core.objects;
using wServer.core.worlds.logic;

namespace wServer.logic.behaviors
{
    internal class AnnounceOnDeath : Behavior
    {
        public static readonly string PLAYER_COUNT = "{COUNT}";
        public static readonly string PLAYER_LIST = "{PL_LIST}";
        private readonly string _message;

        public AnnounceOnDeath(string msg) => _message = msg;

        public override void OnDeath(Entity host, ref TickTime time)
        {
            if (host.Spawned || host.World is TestWorld)
                return;

            var owner = host.World;
            var sb = new StringBuilder();
            var players = owner.Players.Values.Where(_ => _.Client != null).ToArray();
            for (var i = 0; i < players.Length; i++)
            {
                if (i != 0)
                    sb.Append(", ");
                 _ = sb.Append(players[i].Name);
            }

            var playerList = sb.ToString();
            var playerCount = owner.Players.Count(p => p.Value.Client != null).ToString();
            var announcement = _message.Replace(PLAYER_COUNT, playerCount).Replace(PLAYER_LIST, playerList);
            host.GameServer.ChatManager.Announce(announcement);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
