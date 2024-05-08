using System;
using System.Globalization;

#if WINRT
using System.Runtime.Serialization;
#endif

namespace WorldServer.logic
{
#if WINRT
    [DataContract]
#else

    [Serializable]
#endif
    public struct Vector2 : IEquatable<Vector2>
    {
#if WINRT
        [DataMember]
#endif
        public float X;
#if WINRT
        [DataMember]
#endif
        public float Y;

        public Vector2(float x, float y)
        {
            X = x;
            Y = y;
        }

        public Vector2(float value)
        {
            X = value;
            Y = value;
        }

        public static Vector2 One { get; } = new Vector2(1f, 1f);
        public static Vector2 UnitX { get; } = new Vector2(1f, 0f);
        public static Vector2 UnitY { get; } = new Vector2(0f, 1f);
        public static Vector2 Zero { get; } = new Vector2(0f, 0f);

        public static Vector2 Add(Vector2 value1, Vector2 value2)
        {
            value1.X += value2.X;
            value1.Y += value2.Y;

            return value1;
        }

        public static void Add(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X + value2.X;
            result.Y = value1.Y + value2.Y;
        }

        public static float Distance(Vector2 value1, Vector2 value2)
        {
            var v1 = value1.X - value2.X;
            var v2 = value1.Y - value2.Y;

            return (float)Math.Sqrt(v1 * v1 + v2 * v2);
        }

        public static void Distance(ref Vector2 value1, ref Vector2 value2, out float result)
        {
            var v1 = value1.X - value2.X;
            var v2 = value1.Y - value2.Y;

            result = (float)Math.Sqrt(v1 * v1 + v2 * v2);
        }

        public static float DistanceSquared(Vector2 value1, Vector2 value2)
        {
            var v1 = value1.X - value2.X;
            var v2 = value1.Y - value2.Y;

            return v1 * v1 + v2 * v2;
        }

        public static void DistanceSquared(ref Vector2 value1, ref Vector2 value2, out float result)
        {
            var v1 = value1.X - value2.X;
            var v2 = value1.Y - value2.Y;

            result = v1 * v1 + v2 * v2;
        }

        public static Vector2 Divide(Vector2 value1, Vector2 value2)
        {
            value1.X /= value2.X;
            value1.Y /= value2.Y;

            return value1;
        }

        public static void Divide(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X / value2.X;
            result.Y = value1.Y / value2.Y;
        }

        public static Vector2 Divide(Vector2 value1, float divider)
        {
            var factor = 1 / divider;

            value1.X *= factor;
            value1.Y *= factor;

            return value1;
        }

        public static void Divide(ref Vector2 value1, float divider, out Vector2 result)
        {
            var factor = 1 / divider;

            result.X = value1.X * factor;
            result.Y = value1.Y * factor;
        }

        public static float Dot(Vector2 value1, Vector2 value2) => value1.X * value2.X + value1.Y * value2.Y;

        public static void Dot(ref Vector2 value1, ref Vector2 value2, out float result) => result = value1.X * value2.X + value1.Y * value2.Y;

        public static Vector2 Max(Vector2 value1, Vector2 value2) => new Vector2(value1.X > value2.X ? value1.X : value2.X, value1.Y > value2.Y ? value1.Y : value2.Y);

        public static void Max(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X > value2.X ? value1.X : value2.X;
            result.Y = value1.Y > value2.Y ? value1.Y : value2.Y;
        }

        public static Vector2 Min(Vector2 value1, Vector2 value2) => new Vector2(value1.X < value2.X ? value1.X : value2.X, value1.Y < value2.Y ? value1.Y : value2.Y);

        public static void Min(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X < value2.X ? value1.X : value2.X;
            result.Y = value1.Y < value2.Y ? value1.Y : value2.Y;
        }

        public static Vector2 Multiply(Vector2 value1, Vector2 value2)
        {
            value1.X *= value2.X;
            value1.Y *= value2.Y;

            return value1;
        }

        public static Vector2 Multiply(Vector2 value1, float scaleFactor)
        {
            value1.X *= scaleFactor;
            value1.Y *= scaleFactor;

            return value1;
        }

        public static void Multiply(ref Vector2 value1, float scaleFactor, out Vector2 result)
        {
            result.X = value1.X * scaleFactor;
            result.Y = value1.Y * scaleFactor;
        }

        public static void Multiply(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X * value2.X;
            result.Y = value1.Y * value2.Y;
        }

        public static Vector2 Negate(Vector2 value)
        {
            value.X = -value.X;
            value.Y = -value.Y;

            return value;
        }

        public static void Negate(ref Vector2 value, out Vector2 result)
        {
            result.X = -value.X;
            result.Y = -value.Y;
        }

        public static Vector2 Normalize(Vector2 value)
        {
            var val = 1.0f / (float)Math.Sqrt(value.X * value.X + value.Y * value.Y);

            value.X *= val;
            value.Y *= val;

            return value;
        }

        public static void Normalize(ref Vector2 value, out Vector2 result)
        {
            var val = 1.0f / (float)Math.Sqrt(value.X * value.X + value.Y * value.Y);

            result.X = value.X * val;
            result.Y = value.Y * val;
        }

        public static Vector2 operator -(Vector2 value)
        {
            value.X = -value.X;
            value.Y = -value.Y;

            return value;
        }

        public static Vector2 operator -(Vector2 value1, Vector2 value2)
        {
            value1.X -= value2.X;
            value1.Y -= value2.Y;

            return value1;
        }

        public static bool operator !=(Vector2 value1, Vector2 value2) => value1.X != value2.X || value1.Y != value2.Y;

        public static Vector2 operator *(Vector2 value1, Vector2 value2)
        {
            value1.X *= value2.X;
            value1.Y *= value2.Y;

            return value1;
        }

        public static Vector2 operator *(Vector2 value, float scaleFactor)
        {
            value.X *= scaleFactor;
            value.Y *= scaleFactor;

            return value;
        }

        public static Vector2 operator *(float scaleFactor, Vector2 value)
        {
            value.X *= scaleFactor;
            value.Y *= scaleFactor;

            return value;
        }

        public static Vector2 operator /(Vector2 value1, Vector2 value2)
        {
            value1.X /= value2.X;
            value1.Y /= value2.Y;

            return value1;
        }

        public static Vector2 operator /(Vector2 value1, float divider)
        {
            var factor = 1 / divider;

            value1.X *= factor;
            value1.Y *= factor;

            return value1;
        }

        public static Vector2 operator +(Vector2 value1, Vector2 value2)
        {
            value1.X += value2.X;
            value1.Y += value2.Y;

            return value1;
        }

        public static bool operator ==(Vector2 value1, Vector2 value2) => value1.X == value2.X && value1.Y == value2.Y;

        public static Vector2 Reflect(Vector2 vector, Vector2 normal)
        {
            Vector2 result;

            var val = 2.0f * (vector.X * normal.X + vector.Y * normal.Y);

            result.X = vector.X - normal.X * val;
            result.Y = vector.Y - normal.Y * val;

            return result;
        }

        public static void Reflect(ref Vector2 vector, ref Vector2 normal, out Vector2 result)
        {
            var val = 2.0f * (vector.X * normal.X + vector.Y * normal.Y);

            result.X = vector.X - normal.X * val;
            result.Y = vector.Y - normal.Y * val;
        }

        public static Vector2 Subtract(Vector2 value1, Vector2 value2)
        {
            value1.X -= value2.X;
            value1.Y -= value2.Y;

            return value1;
        }

        public static void Subtract(ref Vector2 value1, ref Vector2 value2, out Vector2 result)
        {
            result.X = value1.X - value2.X;
            result.Y = value1.Y - value2.Y;
        }

        public override bool Equals(object obj)
        {
            if (obj is Vector2)
                return Equals(this);

            return false;
        }

        public bool Equals(Vector2 other) => X == other.X && Y == other.Y;

        public override int GetHashCode() => X.GetHashCode() + Y.GetHashCode();

        public float Length() => (float)Math.Sqrt(X * X + Y * Y);

        public float LengthSquared() => X * X + Y * Y;

        public void Normalize()
        {
            var d = (float)Math.Sqrt(X * X + Y * Y);

            if (d == 0)
                return;

            var val = 1.0f / d;

            X *= val;
            Y *= val;
        }

        public override string ToString()
        {
            var currentCulture = CultureInfo.CurrentCulture;

            return string.Format(currentCulture, "{{X:{0} Y:{1}}}", new object[] { X.ToString(currentCulture), Y.ToString(currentCulture) });
        }
    }
}
