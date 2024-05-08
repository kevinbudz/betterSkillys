using System;

namespace Shared.logger
{
    public static class Log
    {
        public static void Custom(string message, ConsoleColor color) => Logger(message, null, color);

        public static void Error(string message, Exception exception = null) => Logger(message, exception, ConsoleColor.Red);

        public static void Info(string message) => Logger(message, null, ConsoleColor.Gray);

        public static void Warn(string message) => Logger(message, null, ConsoleColor.Yellow);

        private static void Logger(string message, Exception exception, ConsoleColor color)
        {
            Console.ForegroundColor = color;
            Console.WriteLine(message);

            if (exception != null)
                Console.WriteLine($"\nException: {exception}");

            Console.ResetColor();
        }
    }
}
