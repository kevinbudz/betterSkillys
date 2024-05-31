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
