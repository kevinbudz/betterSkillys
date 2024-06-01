using Shared.resources;
using System;
using System.Collections.Generic;
using System.Reflection.Metadata;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class AllyShoot : CycleBehavior
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
        private readonly float _shootAngle;
        private Cooldown _coolDown;
        private int _rotateCount;

        public AllyShoot(double radius, int count = 1, double? shootAngle = null, int projectileIndex = 0, double? fixedAngle = null, double? rotateAngle = null, double angleOffset = 0, double? defaultAngle = null, double predictive = 0, int coolDownOffset = 0, Cooldown coolDown = new Cooldown(), bool shootLowHp = false, bool seeInvis = false)
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

            var entity = host.GetNearestEntity(_radius, false, e => (e is Enemy en && en.AllyOwnerId == -1 && !en.HasConditionEffect(ConditionEffectIndex.Invincible))); // kihnda hacky to rpevent t argeting other npcs
            if (entity != null || _defaultAngle != null || _fixedAngle != null)
            {
                var hasProjectileDesc = host.ObjectDesc.Projectiles.TryGetValue(_projectileIndex, out var desc);
                if (!hasProjectileDesc)
                {
                    cool = _coolDown.Next(Random);
                    Status = CycleStatus.Completed;
                    state = cool;
                    return;
                }

                float angle;
                if (_fixedAngle != null)
                    angle = (float)_fixedAngle;
                else if (entity != null)
                {
                    if (_predictive != 0 && _predictive > Random.NextDouble())
                        angle = Predict(host, entity);
                    else
                        angle = (float)Math.Atan2(entity.Y - host.Y, entity.X - host.X);
                }
                else if (_defaultAngle != null)
                    angle = (float)_defaultAngle;
                else
                    angle = 0;

                angle += _angleOffset + (_rotateAngle != null ? (float)_rotateAngle * _rotateCount : 0);

                _rotateCount++;

                var player = host.World.Players.GetValueOrDefault(host.AllyOwnerId);
                if (player == null)
                    return;

                var bulletId = host.GetNextBulletId(count);
                var damage = Random.Shared.Next(desc.MinDamage, desc.MaxDamage);
                float startAngle = angle - _shootAngle * (count - 1) / 2;
                for (int i = 0; i < count; i++)
                {
                    var shotAngle = startAngle + (i * _shootAngle);
                    var serverPlayerShoot = new ServerPlayerShoot(player.Id, bulletId, host.ObjectType, host.Position, shotAngle, damage, desc);
                    host.World.BroadcastServerPlayerShoot(serverPlayerShoot, host);
                }
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
