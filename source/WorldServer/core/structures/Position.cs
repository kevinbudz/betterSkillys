using Shared;
using System;
using WorldServer.core.objects;

namespace WorldServer.core.structures
{
    public struct Position
    {
        public float X;
        public float Y;
        public int Hash => (int)X << 16 | (int)Y;
        public IntPoint IntPoint => new IntPoint((int)X, (int)Y);

        public Position(float x, float y)
        {
            X = x;
            Y = y;
        }

        public Position(double x, double y)
        {
            X = (float)x;
            Y = (float)y;
        }

        public static Position Read(NetworkReader rdr) => new Position
        {
            X = rdr.ReadSingle(),
            Y = rdr.ReadSingle()
        };

        public override string ToString() => string.Format("{{X: {0}, Y: {1}}}", X, Y);

        public void Write(NetworkWriter wtr)
        {
            wtr.Write(X);
            wtr.Write(Y);
        }

        public double AngleTo(double x, double y) => Math.Atan2(y - Y, x - X);
        public Position PointAt(double angle, double radius) => new Position( + Math.Cos(angle) * radius, Y + Math.Sin(angle) * radius);

        public double DistTo(Entity host) => Math.Sqrt((host.X - X) * (host.X - X) + (host.Y - Y) * (host.Y - Y));
        public double DistTo(ref Position position) => Math.Sqrt((position.X - X) * (position.X - X) + (position.Y - Y) * (position.Y - Y));
        public double DistTo(double x, double y) => Math.Sqrt((x - X) * (x - X) + (y - Y) * (y - Y));
    }
}
