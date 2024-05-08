using System;
using System.Diagnostics;

namespace Shared
{
    public sealed class TimedProfiler : IDisposable
    {
        private readonly Action<string> Action;
        private readonly string Message;
        private readonly Stopwatch StopWatch;

        public TimedProfiler(string message) : this(message, null) { }

        public TimedProfiler(string message, Action<string> action)
        {
            Message = message;
            Action = action;
            StopWatch = Stopwatch.StartNew();
        }

        public void Dispose()
        {
            StopWatch.Stop();

            var time = StopWatch.Elapsed;
            var ms = StopWatch.ElapsedMilliseconds;
            var info = $"{Message} - Elapsed: {time} ({ms}ms)";

            Action?.Invoke(info);
            Console.WriteLine(info);
        }
    }
}
