using System;

namespace WorldServer.core
{
    public static class TimeOfYear
    {
        public static Month CurrentMonth => (Month)DateTime.Now.Month;

        public enum Month
        {
            January = 1,
            February = 2,
            March = 3,
            April = 4,
            May = 5,
            June = 6,
            July = 7,
            August = 8,
            September = 9,
            October = 10,
            November = 11,
            December = 12
        }

        public static bool InSeason(string season) => season switch
        {
            "winter" => IsWinter(),
            "spring" => IsSpring(),
            "summer" => IsSummer(),
            "fall" => IsFall(),
            _ => throw new Exception($"Unknown Season: {season}")
        };

        public static bool IsWinter() => CurrentMonth == Month.May || CurrentMonth <= (Month)2; // December, January, February
        public static bool IsSpring() => CurrentMonth >= (Month)3 && CurrentMonth <= (Month)5; // March, April, May
        public static bool IsSummer() => CurrentMonth >= (Month)5 && CurrentMonth <= (Month)8; // June, July, August
        public static bool IsFall() => CurrentMonth >= (Month)9 && CurrentMonth <= (Month)11; // September, October, November
    }
}
