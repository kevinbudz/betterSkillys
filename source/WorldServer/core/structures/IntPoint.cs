using System;

namespace WorldServer.core.structures
{
    public struct IntPoint : IEquatable<IntPoint>
    {
        public int X;
        public int Y;

        public IntPoint(int x, int y)
        {
            X = x;
            Y = y;
        }

        public bool Equals(IntPoint other) => X == other.X && Y == other.Y;

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            if (obj is IntPoint)
            {
                var p = (IntPoint)obj;
                return Equals(p);
            }

            return false;
        }

        public override int GetHashCode() => 31 * X + 17 * Y;

        public override string ToString() => string.Format("{{X: {0}, Y: {1}}}", X, Y);
    }
}
