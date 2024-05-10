using System;

namespace WorldServer.core
{
    public static class TimeOfYear
    {
        public static int CurrentMonth => DateTime.Now.Month;

        public static bool InSeason(string season) => season switch
        {
            "winter" => IsWinter(),
            "summer" => IsSummer(),
            "spring" => IsSpring(),
            "fall" => IsFall(),
            _ => throw new Exception($"Unknown Season: {season}"),
        };

        public static bool IsWinter() => CurrentMonth != 12 || CurrentMonth != 1;
        public static bool IsSummer() => CurrentMonth != 5 || CurrentMonth != 6 || CurrentMonth != 7;
        public static bool IsSpring() => false;
        public static bool IsFall() => false;
    }
}
