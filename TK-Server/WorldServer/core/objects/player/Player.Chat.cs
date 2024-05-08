using System;
using System.Text.RegularExpressions;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    partial class Player
    {
        private static Regex nonAlphaNum = new Regex("[^a-zA-Z0-9 ]", RegexOptions.CultureInvariant);
        private static Regex repetition = new Regex("(.)(?<=\\1\\1)", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled);

        private string LastMessage = "";
        private int LastMessageDeviation = int.MaxValue;
        private long LastMessageTime = 0;
        private bool Spam = false;

        public static int LengthThreshold(int length) => length > 4 ? 3 : 0;

        public static int LevenshteinDistance(string s, string t)
        {
            var n = s.Length;
            var m = t.Length;
            var d = new int[n + 1, m + 1];

            if (n == 0)
                return m;

            if (m == 0)
                return n;

            for (var i = 0; i <= n; d[i, 0] = i++) ;
            for (var j = 0; j <= m; d[0, j] = j++) ;

            for (var i = 1; i <= n; i++)
                for (var j = 1; j <= m; j++)
                    d[i, j] = Math.Min(Math.Min(d[i - 1, j] + 1, d[i, j - 1] + 1), d[i - 1, j - 1] + ((t[j - 1] == s[i - 1]) ? 0 : 1));

            return d[n, m];
        }

        public bool CompareAndCheckSpam(string message, long time)
        {
            if (time - LastMessageTime < 500)
            {
                LastMessageTime = time;

                if (Spam)
                    return true;
                else
                {
                    Spam = true;
                    return false;
                }
            }

            var strippedMessage = nonAlphaNum.Replace(message, "").ToLower();
            strippedMessage = repetition.Replace(strippedMessage, "");

            if (time - LastMessageTime > 10000)
            {
                LastMessageDeviation = LevenshteinDistance(LastMessage, strippedMessage);
                LastMessageTime = time;
                LastMessage = strippedMessage;
                Spam = false;
                return false;
            }
            else
            {
                var deviation = LevenshteinDistance(LastMessage, strippedMessage);
                LastMessageTime = time;
                LastMessage = strippedMessage;

                if (LastMessageDeviation <= LengthThreshold(LastMessage.Length) && deviation <= LengthThreshold(message.Length))
                {
                    LastMessageDeviation = deviation;

                    if (Spam)
                        return true;
                    else
                    {
                        Spam = true;
                        return false;
                    }
                }
                else
                {
                    LastMessageDeviation = deviation;
                    Spam = false;
                    return false;
                }
            }
        }

        public void SendClientText(string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "*Client*",
            Txt = text
        });

        public void SendClientTextFormat(string text, params object[] args) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "*Client*",
            Txt = string.Format(text, args)
        });

        public void SendEnemy(string name, string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = $"#{name}",
            Txt = text
        });

        public void SendEnemyFormat(string name, string text, params object[] args) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = $"#{name}",
            Txt = string.Format(text, args)
        });

        public void SendError(string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "*Error*",
            Txt = text
        });

        public void SendErrorFormat(string text, params object[] args) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "*Error*",
            Txt = string.Format(text, args)
        });

        public void SendHelp(string text)
        {
            Client.SendPacket(new Text()
            {
                BubbleTime = 0,
                NumStars = -1,
                Name = "*Help*",
                Txt = text
            });
        }

        public void SendHelpFormat(string text, params object[] args) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "*Help*",
            Txt = string.Format(text, args)
        });

        public void SendInfo(string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "",
            Txt = text
        });

        internal void AnnouncementReceived(string text, string user = null) => Client.Player.SendInfo(string.Concat($"<{user ?? "ANNOUNCEMENT"}> ", text));

        internal void DeathNotif(string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "Death",
            Txt = text,
            TextColor = 0xFFFFFF,
            NameColor = 0xff2f00
        });

        internal void GuildReceived(int objId, int stars, string from, string text) => Client.SendPacket(new Text()
        {
            ObjectId = objId,
            BubbleTime = 10,
            NumStars = stars,
            Name = from,
            Recipient = "*Guild*",
            Txt = text
        });

        internal void PartyReceived(int objId, int stars, string from, string text) => Client.SendPacket(new Text()
        {
            ObjectId = objId,
            BubbleTime = 10,
            NumStars = stars,
            Name = from,
            Recipient = "*Party*",
            Txt = text
        });

        internal void SendLootNotif(string text) => Client.SendPacket(new Text()
        {
            BubbleTime = 0,
            NumStars = -1,
            Name = "Loot Notifier",
            Txt = text,
            TextColor = 0xFFFFFF,
            NameColor = 0xAD054F
        });

        internal void TellReceived(int objId, int stars, int admin, string from, string to, string text) => Client.SendPacket(new Text()
        {
            ObjectId = objId,
            BubbleTime = 10,
            NumStars = stars,
            Name = from,
            Recipient = to,
            Txt = text
        });
    }
}
