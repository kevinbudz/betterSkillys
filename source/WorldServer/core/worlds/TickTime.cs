namespace WorldServer.core.worlds
{
    public struct TickTime
    {
        public int ElapsedMsDelta;
        public long TickCount;
        public long TotalElapsedMs;
        public float DeltaTime => ElapsedMsDelta * 0.001f;
        
        // Slendergo -> DONT EVER CHANGE THIS VALUE, ESPECIALLY IF U HAVE CHANGED TPS FROM 200ms (5 TPS), ANY CHANGES WILL CAUSE SPEEDY ENTITIES IF TPS IS NOT 5
        // ENTITIES WERE DESIGNED TO MOVE AT 5 TPS SPEEDS SO ANY TPS CHANGES WILL AFFECT ENTITY MOVEMENT RATE
        // THIS ENSURES ENTITIES MOVE AT A SPEED OF 5 TPS
        public float BehaviourTickTime => DeltaTime * 5.0f; 
    }
}
