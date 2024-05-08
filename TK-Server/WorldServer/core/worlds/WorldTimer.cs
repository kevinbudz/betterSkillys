using System;

namespace WorldServer.core.worlds
{
    public sealed class WorldTimer
    {
        private readonly Action<World, TickTime> Callback;
        private readonly Func<World, TickTime, bool> FuncCallback;
        private readonly int Total;
        private int Remaining;

        public WorldTimer(int tickMs, Action<World, TickTime> callback)
        {
            Remaining = Total = tickMs;
            Callback = callback;
        }

        public WorldTimer(int tickMs, Func<World, TickTime, bool> callback)
        {
            Remaining = Total = tickMs;
            FuncCallback = callback;
        }

        public bool Tick(World world, ref TickTime time)
        {
            Remaining -= time.ElapsedMsDelta;
            if (Remaining >= 0)
                return false;

            if (Callback != null)
            {
                Callback.Invoke(world, time);
                return true;
            }
            return FuncCallback.Invoke(world, time);
        }

        public void Reset() => Remaining = Total;
    }
}
