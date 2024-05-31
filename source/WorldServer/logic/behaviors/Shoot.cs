using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class Shoot : CycleBehavior
    {
        private const int PREDICT_NUM_TICKS = 4;

        private readonly float _angleOffset;
        private readonly int _coolDownOffset;
        private readonly int _count;
        private readonly float? _defaultAngle;
        private readonly float? _fixedAngle;
        private readonly float _predictive;
        private readonly int _projectileIndex;
        private readonly float _radius;
        private readonly float? _rotateAngle;
        private readonly bool _seeInvis;
        private readonly float _shootAngle;
        private readonly bool _shootLowHp;
        private Cooldown _coolDown;
        private int _rotateCount;

        public Shoot(double radius, int count = 1, double? shootAngle = null, int projectileIndex = 0, double? fixedAngle = null, double? rotateAngle = null, double angleOffset = 0, double? defaultAngle = null, double predictive = 0, int coolDownOffset = 0, Cooldown coolDown = new Cooldown(), bool shootLowHp = false, bool seeInvis = false)
        {
            _radius = (float)radius;
            _count = count;
            _shootAngle = count == 1 ? 0 : (float)((shootAngle ?? 360.0 / count) * Math.PI / 180);
            _projectileIndex = projectileIndex;
            _fixedAngle = (float?)(fixedAngle * Math.PI / 180);
            _rotateAngle = (float?)(rotateAngle * Math.PI / 180);
            _angleOffset = (float)(angleOffset * Math.PI / 180);
            _defaultAngle = (float?)(defaultAngle * Math.PI / 180);
            _predictive = (float)predictive;
            _coolDownOffset = coolDownOffset;
            _coolDown = coolDown.Normalize();
            _shootLowHp = shootLowHp;
            _seeInvis = seeInvis;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = _coolDownOffset;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int?)state ?? -1; // <-- crashes server due to state being null... patched now but should be looked at.

            Status = CycleStatus.NotStarted;

            if (cool > 0)
            {
                cool -= time.ElapsedMsDelta;
                Status = CycleStatus.InProgress;
                state = cool;
                return;
            }

            if (host.HasConditionEffect(ConditionEffectIndex.Stunned))
            {
                cool = _coolDown.Next(Random);
                Status = CycleStatus.Completed;
                state = cool;
                return;
            }

            var count = _count;

            if (host.HasConditionEffect(ConditionEffectIndex.Dazed))
                count = (int)Math.Ceiling(_count / 2.0);

            var player = host.AttackTarget ?? (_shootLowHp ? host.GetLowestHpEntity(_radius, null, _seeInvis) : host.GetNearestEntity(_radius, null, _seeInvis));

            if (player != null || _defaultAngle != null || _fixedAngle != null)
            {
                var hasProjectileDesc = host.ObjectDesc.Projectiles.TryGetValue(_projectileIndex, out var desc);
                if (!hasProjectileDesc)
                {
                    Console.WriteLine($"{host.ObjectDesc.IdName} Doesnt have projectile: {_projectileIndex}");
                    cool = _coolDown.Next(Random);
                    Status = CycleStatus.Completed;
                    state = cool;
                    return;
                }

                float a;

                if (_fixedAngle != null)
                    a = (float)_fixedAngle;
                else if (player != null)
                {
                    if (_predictive != 0 && _predictive > Random.NextDouble())
                        a = Predict(host, player);
                    else
                        a = (float)Math.Atan2(player.Y - host.Y, player.X - host.X);
                }
                else if (_defaultAngle != null)
                    a = (float)_defaultAngle;
                else
                    a = 0;

                a += _angleOffset + (_rotateAngle != null ? (float)_rotateAngle * _rotateCount : 0);

                _rotateCount++;

                var dmg = (double)Random.Next(desc.MinDamage, desc.MaxDamage);

                if (host.HasConditionEffect(ConditionEffectIndex.Weak))
                    dmg /= 2;

                var startAngle = a - _shootAngle * (count - 1) / 2;

                var prjPos = new Position(host.X, host.Y);

                var prjId = host.GetNextBulletId(count);
                var pkt = new EnemyShootMessage()
                {
                    Spawned = host.Spawned,
                    BulletId = prjId,
                    OwnerId = host.Id,
                    StartingPos = prjPos,
                    Angle = startAngle,
                    Damage = (short)dmg,
                    BulletType = (byte)desc.BulletType,
                    AngleInc = _shootAngle,
                    NumShots = (byte)count,
                    ObjectType = host.ObjectType,
                    ProjectileDesc = desc,
                };

                host.World.BroadcastEnemyShootIfVisible(pkt, host);
            }

            cool = _coolDown.Next(Random);

            Status = CycleStatus.Completed;

            state = cool;
        }

        private static float Predict(Entity host, Entity target)
        {
            var targetX = target.X + PREDICT_NUM_TICKS * (target.X - target.PrevX);
            var targetY = target.Y + PREDICT_NUM_TICKS * (target.Y - target.PrevY);
            var angle = (float)Math.Atan2(targetY - host.Y, targetX - host.X);
            return angle;
        }
    }
}
