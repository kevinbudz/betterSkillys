using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;

namespace Shared.isc.data
{
    public class PlayerList : IEnumerable<PlayerInfo>
    {
        private ConcurrentDictionary<PlayerInfo, int> PlayerInfo;

        public PlayerList(IEnumerable<PlayerInfo> playerList = null)
        {
            PlayerInfo = new ConcurrentDictionary<PlayerInfo, int>();

            if (playerList == null)
                return;

            foreach (var plr in playerList)
                Add(plr);
        }

        public void Add(PlayerInfo playerInfo) => PlayerInfo.TryAdd(playerInfo, 0);

        IEnumerator<PlayerInfo> IEnumerable<PlayerInfo>.GetEnumerator() => PlayerInfo.Keys.GetEnumerator();

        public IEnumerator GetEnumerator() => PlayerInfo.Keys.GetEnumerator();

        public void Remove(PlayerInfo playerInfo)
        {
            if (playerInfo == null)
                return;

            PlayerInfo.TryRemove(playerInfo, out _);
        }
    }
}
