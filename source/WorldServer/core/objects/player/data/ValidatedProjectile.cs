using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.structures;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        public enum DamageType
        {
            Enemy,
            Player,
        }

        public sealed class ValidatedProjectile
        {
            public int Time { get; set; }

            public readonly int ObjectId;
            public readonly int BulletId;
            public readonly float Angle;
            public readonly int ContainerType;
            public readonly float StartX;
            public readonly float StartY;
            public readonly int Damage;
            public readonly DamageType DamageType;
            public readonly ProjectileDesc ProjectileDesc;
            public readonly bool Spawned;

            public ValidatedProjectile(int objectId, int bulletId, Position startPos, float angle, int containerType, int damage, DamageType damageType, ProjectileDesc projectileDesc, bool spawned)
            {
                ObjectId = objectId;
                BulletId = bulletId;

                StartX = startPos.X;
                StartY = startPos.Y;
                Angle = angle;
                ContainerType = containerType;
                Damage = damage;

                DamageType = damageType;

                ProjectileDesc = projectileDesc;
                Spawned = spawned;
            }

            public bool Disabled { get; set; }
            public List<int> HitObjects = new List<int>();

            public static Position GetPosition(long elapsedTicks, int projId, ProjectileDesc desc, float angle, float speedMult)
            {
                var x = 0.0;
                var y = 0.0;

                var dist = elapsedTicks * (desc.Speed / 10000.0) * speedMult;
                var period = projId % 2 == 0 ? 0 : Math.PI;

                if (desc.Wavy)
                {
                    var theta = angle + (Math.PI * 64) * Math.Sin(period + 6 * Math.PI * (elapsedTicks / 1000.0));
                    x += dist * Math.Cos(theta);
                    y += dist * Math.Sin(theta);
                }
                else if (desc.Parametric)
                {
                    var theta = (double)elapsedTicks / desc.LifetimeMS * 2 * Math.PI;
                    var a = Math.Sin(theta) * (projId % 2 != 0 ? 1 : -1);
                    var b = Math.Sin(theta * 2) * (projId % 4 < 2 ? 1 : -1);
                    var c = Math.Sin(angle);
                    var d = Math.Cos(angle);
                    x += (a * d - b * c) * desc.Magnitude;
                    y += (a * c + b * d) * desc.Magnitude;
                }
                else
                {
                    if (desc.Boomerang)
                    {
                        var d = desc.LifetimeMS * (desc.Speed * speedMult) / 10000.0 / 2;
                        if (dist > d)
                            dist = d - (dist - d);
                    }
                    x += dist * Math.Cos(angle);
                    y += dist * Math.Sin(angle);
                    if (desc.Amplitude != 0)
                    {
                        var d = desc.Amplitude * Math.Sin(period + (double)elapsedTicks / desc.LifetimeMS * desc.Frequency * 2 * Math.PI);
                        x += d * Math.Cos(angle + Math.PI / 2);
                        y += d * Math.Sin(angle + Math.PI / 2);
                    }
                }

                return new Position() { X = (float)x, Y = (float)y };
            }
            public Position GetPosition(int elapsed, int bulletId, ProjectileDesc desc)
            {
                double periodFactor;
                double amplitudeFactor;
                double theta;

                var pX = (double)StartX;
                var pY = (double)StartY;
                var dist = elapsed * desc.Speed / 10000.0;
                var phase = bulletId % 2 == 0 ? 0 : Math.PI;

                if (desc.Wavy)
                {
                    periodFactor = 6 * Math.PI;
                    amplitudeFactor = Math.PI / 64;
                    theta = Angle + amplitudeFactor * Math.Sin(phase + periodFactor * elapsed / 1000);
                    pX += dist * Math.Cos(theta);
                    pY += dist * Math.Sin(theta);
                }
                else if (desc.Parametric)
                {
                    var t = elapsed / desc.LifetimeMS * 2 * Math.PI;
                    var x = Math.Sin(t) * (bulletId % 2 == 0 ? 1 : -1);
                    var y = Math.Sin(2 * t) * (bulletId % 4 < 2 ? 1 : -1);
                    var sin = Math.Sin(Angle);
                    var cos = Math.Cos(Angle);
                    pX += (x * cos - y * sin) * desc.Magnitude;
                    pY += (x * sin + y * cos) * desc.Magnitude;
                }
                else
                {
                    if (desc.Boomerang)
                    {
                        var halfway = desc.LifetimeMS * (desc.Speed / 10000.0) / 2.0;
                        if (dist > halfway)
                            dist = halfway - (dist - halfway);
                    }
                    pX += dist * Math.Cos(Angle);
                    pY += dist * Math.Sin(Angle);

                    if (desc.Amplitude != 0.0)
                    {
                        var deflection = desc.Amplitude * Math.Sin(phase + elapsed / desc.LifetimeMS * desc.Frequency * 2.0 * Math.PI);
                        pX += deflection * Math.Cos(Angle + Math.PI / 2.0);
                        pY += deflection * Math.Sin(Angle + Math.PI / 2.0);
                    }
                }
                return new Position((float)pX, (float)pY);
            }

        }

    }
}
