using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.structures;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        public sealed class ValidatedProjectile
        {
            public int BulletType;
            public int StartTime;
            public float StartX;
            public float StartY;
            public float Angle;
            public int ObjectType;
            public int Damage;
            public bool Spawned;
            public bool DamagesPlayers;
            public bool DamagesEnemies;
            public bool Disabled;
            public List<int> HitObjects = new List<int>();

            public ValidatedProjectile(int time, bool spawned, int projectileType, float x, float y, float angle, int objectType, int damage, bool damagesPlayers, bool damagesEnemies)
            {
                Spawned = spawned;
                BulletType = projectileType;
                StartTime = time;
                StartX = x;
                StartY = y;
                Angle = angle;
                ObjectType = objectType;
                Damage = damage;
                DamagesPlayers = damagesPlayers;
                DamagesEnemies = damagesEnemies;
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
