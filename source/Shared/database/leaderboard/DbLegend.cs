using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Shared.database.leaderboard
{
    public struct DbLegendEntry
    {
        public readonly int AccId;
        public readonly int ChrId;

        public DbLegendEntry(int accId, int chrId)
        {
            AccId = accId;
            ChrId = chrId;
        }
    }

    public static class DbLegend
    {
        private const int _max = 20;

        private static readonly Dictionary<string, TimeSpan> TimeSpans = new Dictionary<string, TimeSpan>()
        {
            { "week", TimeSpan.FromDays(7) },
            { "month", TimeSpan.FromDays(30) },
            { "all", TimeSpan.MaxValue }
        };

        public static void Clean(IDatabase db)
        {
            foreach (var span in TimeSpans)
            {
                if (span.Value == TimeSpan.MaxValue)
                {
                    db.SortedSetRemoveRangeByRankAsync($"legends:{span.Key}:byFame", 0, -_max - 1, CommandFlags.FireAndForget);
                    continue;
                }

                var outdated = db.SortedSetRangeByScore($"legends:{span.Key}:byTimeOfDeath", 0, DateTime.UtcNow.ToUnixTimestamp());
                var trans = db.CreateTransaction();
                trans.SortedSetRemoveAsync($"legends:{span.Key}:byFame", outdated, CommandFlags.FireAndForget);
                trans.SortedSetRemoveAsync($"legends:{span.Key}:byTimeOfDeath", outdated, CommandFlags.FireAndForget);
                trans.ExecuteAsync(CommandFlags.FireAndForget);
            }

            db.KeyDeleteAsync("legend", CommandFlags.FireAndForget);

            foreach (var span in TimeSpans)
            {
                var legendTask = db.SortedSetRangeByRankAsync($"legends:{span.Key}:byFame", 0, _max - 1, Order.Descending);
                legendTask.ContinueWith(r =>
                {
                    var trans = db.CreateTransaction();

                    foreach (var e in r.Result)
                    {
                        var accId = BitConverter.ToInt32(e, 0);

                        trans.HashSetAsync("legend", accId, "", flags: CommandFlags.FireAndForget);
                    }

                    trans.ExecuteAsync(CommandFlags.FireAndForget);
                });
            }

            db.StringSetAsync("legends:updateTime", DateTime.UtcNow.ToUnixTimestamp(), flags: CommandFlags.FireAndForget);
        }

        public static DbLegendEntry[] Get(IDatabase db, string timeSpan)
        {
            if (!TimeSpans.ContainsKey(timeSpan))
                return new DbLegendEntry[0];

            var listings = db.SortedSetRangeByRank($"legends:{timeSpan}:byFame", 0, _max - 1, Order.Descending);

            return listings.Select(e => new DbLegendEntry(BitConverter.ToInt32(e, 0), BitConverter.ToInt32(e, 4))).ToArray();
        }

        public static void Insert(IDatabase db, int accId, int chrId, int totalFame)
        {
            var buff = new byte[8];

            Buffer.BlockCopy(BitConverter.GetBytes(accId), 0, buff, 0, 4);
            Buffer.BlockCopy(BitConverter.GetBytes(chrId), 0, buff, 4, 4);

            var trans = db.CreateTransaction();

            foreach (var span in TimeSpans)
            {
                trans.SortedSetAddAsync($"legends:{span.Key}:byFame", buff, totalFame, CommandFlags.FireAndForget);

                if (span.Value == TimeSpan.MaxValue)
                    continue;

                var t = DateTime.UtcNow.Add(span.Value).ToUnixTimestamp();

                trans.SortedSetAddAsync($"legends:{span.Key}:byTimeOfDeath", buff, t, CommandFlags.FireAndForget);
            }

            trans.ExecuteAsync();

            foreach (var span in TimeSpans)
                db.SortedSetRankAsync($"legends:{span.Key}:byFame", buff, Order.Descending).ContinueWith(r =>
                {
                    if (r.Result >= _max)
                        return;

                    db.HashSetAsync("legend", accId, "", flags: CommandFlags.FireAndForget);
                });

            db.StringSetAsync("legends:updateTime", DateTime.UtcNow.ToUnixTimestamp(), flags: CommandFlags.FireAndForget);
        }
    }
}
