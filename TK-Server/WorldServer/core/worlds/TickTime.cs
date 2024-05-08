namespace WorldServer.core.worlds
{
    public struct TickTime
    {
        public int ElapsedMsDelta;
        public long TickCount;
        public long TotalElapsedMs;
        public float DeltaTime => ElapsedMsDelta * 0.001f;
        public float BehaviourTickTime => DeltaTime * 5.0f;
    }
}
