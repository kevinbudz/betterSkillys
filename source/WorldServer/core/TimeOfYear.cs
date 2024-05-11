using System;

namespace WorldServer.core
{
    public static class TimeOfYear
    {
        public static int CurrentMonth => DateTime.Now.Month;

        public static bool InSeason(string season) => season switch
        {
            "winter" => IsWinter(),
            "spring" => IsSpring(),
            "summer" => IsSummer(),
            "fall" => IsFall(),
            _ => throw new Exception($"Unknown Season: {season}")
        };

        public static bool IsWinter() => CurrentMonth == 12 || CurrentMonth <= 2; // December, January, February
        public static bool IsSpring() => CurrentMonth >= 3 && CurrentMonth <= 5; // March, April, May
        public static bool IsSummer() => CurrentMonth >= 6 && CurrentMonth <= 8; // June, July, August
        public static bool IsFall() => CurrentMonth >= 9 && CurrentMonth <= 11; // September, October, November
    }
}
