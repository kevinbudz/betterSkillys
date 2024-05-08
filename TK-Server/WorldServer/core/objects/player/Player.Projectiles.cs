using NLog.LayoutRenderers;
using Pipelines.Sockets.Unofficial.Arenas;
using System;
using System.Collections.Generic;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.networking.packets.outgoing;
using static WorldServer.core.commands.Command;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private struct ShootAcknowledgement
        {
            public readonly EnemyShootMessage EnemyShoot;
            public readonly ServerPlayerShoot ServerPlayerShoot;

            public ShootAcknowledgement(EnemyShootMessage enemyShoot)
            {
                EnemyShoot = enemyShoot;
                ServerPlayerShoot = null;
            }

            public ShootAcknowledgement(ServerPlayerShoot serverPlayerShoot)
            {
                EnemyShoot = null;
                ServerPlayerShoot = serverPlayerShoot;
            }
        }

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

        private Queue<ShootAcknowledgement> PendingShootAcknowlegements = new Queue<ShootAcknowledgement>();
        private Dictionary<int, Dictionary<int, ValidatedProjectile>> VisibleProjectiles = new Dictionary<int, Dictionary<int, ValidatedProjectile>>();

        public void EnemyShoot(EnemyShootMessage enemyShoot) => PendingShootAcknowlegements.Enqueue(new ShootAcknowledgement(enemyShoot));
        public void ServerPlayerShoot(ServerPlayerShoot serverPlayerShoot)
        {
            if(serverPlayerShoot.OwnerId != Id)
            {
                if (!VisibleProjectiles.ContainsKey(serverPlayerShoot.OwnerId))
                    VisibleProjectiles.Add(serverPlayerShoot.OwnerId, new Dictionary<int, ValidatedProjectile>());
                VisibleProjectiles[serverPlayerShoot.OwnerId][serverPlayerShoot.BulletId] = new ValidatedProjectile(LastClientTime, false, serverPlayerShoot.BulletType, serverPlayerShoot.StartingPos.X, serverPlayerShoot.StartingPos.Y, serverPlayerShoot.Angle, serverPlayerShoot.ObjectType, serverPlayerShoot.Damage, false, true);
                return;
            }
            PendingShootAcknowlegements.Enqueue(new ShootAcknowledgement(serverPlayerShoot));
        }

        public void PlayerShoot(int time, int newBulletId, Position startingPosition, float angle, int slot)
        {
            var item = Inventory[slot];
            var projectileDesc = item.Projectiles[0];

            var damage = (int)(Client.Random.NextIntRange((uint)projectileDesc.MinDamage, (uint)projectileDesc.MaxDamage) * Stats.GetAttackMult());

            if (!VisibleProjectiles.ContainsKey(Id))
                VisibleProjectiles[Id] = new Dictionary<int, ValidatedProjectile>();
            VisibleProjectiles[Id][newBulletId] = new ValidatedProjectile(time, false, 0, startingPosition.X, startingPosition.Y, angle, item.ObjectType, damage, false, true);

            var allyShoot = new AllyShootMessage(newBulletId, Id, item.ObjectType, angle);
            World.BroadcastIfVisibleExclude(allyShoot, this, this);
            FameCounter.Shoot();
        }

        public void ShootAck(int time)
        {
            var topLevelShootAck = PendingShootAcknowlegements.Dequeue();
            if (time == -1)
            {
                //var ownerId = topLevelShootAck.EnemyShoot?.OwnerId ?? topLevelShootAck.ServerPlayerShoot.OwnerId;
                //var owner = World.GetEntity(ownerId);
                //Console.WriteLine($"[ShootAck] {Name} -> Time: -1 for: {owner?.Name ?? "Unknown"}");
                // check entity doesnt exist in our visible list
                // if it doesnt its valid
                // if it does its not valid
                return;
            }

            // validate projectiles here
            var enemyShoot = topLevelShootAck.EnemyShoot;

            if (enemyShoot != null)
            {
                if (!VisibleProjectiles.ContainsKey(enemyShoot.OwnerId))
                    VisibleProjectiles.Add(enemyShoot.OwnerId, new Dictionary<int, ValidatedProjectile>());

                for (var i = 0; i < enemyShoot.NumShots; i++)
                {
                    var angle = enemyShoot.Angle + enemyShoot.AngleInc * i;
                    var bulletId = enemyShoot.BulletId + i;
                    VisibleProjectiles[enemyShoot.OwnerId][bulletId] = new ValidatedProjectile(time, enemyShoot.Spawned, enemyShoot.BulletType, enemyShoot.StartingPos.X, enemyShoot.StartingPos.Y, angle, enemyShoot.ObjectType, enemyShoot.Damage, true, false);
                }
                return;
            }

            var serverPlayerShoot = topLevelShootAck.ServerPlayerShoot;
            if (!VisibleProjectiles.ContainsKey(serverPlayerShoot.OwnerId))
                VisibleProjectiles.Add(serverPlayerShoot.OwnerId, new Dictionary<int, ValidatedProjectile>());
            VisibleProjectiles[serverPlayerShoot.OwnerId][serverPlayerShoot.BulletId] = new ValidatedProjectile(time, false, serverPlayerShoot.BulletType, serverPlayerShoot.StartingPos.X, serverPlayerShoot.StartingPos.Y, serverPlayerShoot.Angle, serverPlayerShoot.ObjectType, serverPlayerShoot.Damage, false, true);
        }

        public void PlayerHit(int bulletId, int objectId)
        {
            if (!VisibleProjectiles.TryGetValue(objectId, out var dict))
            {
                //Console.WriteLine($"[PlayerHit] {Name} -> {Id} not present in VisibleProjectiles List");
                return;
            }

            if (!dict.TryGetValue(bulletId, out var projectile))
            {
                //Console.WriteLine($"[PlayerHit] {Name} -> {bulletId} not present in VisibleProjectiles List");
                return;
            }

            var objectDesc = GameServer.Resources.GameData.ObjectDescs[(ushort)projectile.ObjectType];
            var projectileDesc = objectDesc.Projectiles[projectile.BulletType];

            if (projectile.Disabled)
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {bulletId} Projectile Already Disabled: Multihit: {projectileDesc.MultiHit}");
                return;
            }

            var elapsedSinceStart = LastClientTime - projectile.StartTime;
            if (elapsedSinceStart > projectileDesc.LifetimeMS)
            {
                projectile.Disabled = true;
                //Console.WriteLine("[PlayerHit] -> A expired shot tried to hit entity");
                return;
            }

            projectile.Disabled = !projectileDesc.MultiHit;

            // todo validate hit position

            for (var i = 0; i < 4; i++)
            {
                var item = Inventory[i];
                if (item == null || !item.Legendary && !item.Mythical)
                    continue;

                if (item.MonkeyKingsWrath)
                    MonkeyKingsWrath(i);
                if (item.GodTouch)
                    GodTouch(i);
                if (item.GodBless)
                    GodBless(i);
                if (item.Clarification)
                    Clarification(i);
            }

            var dmg = StatsManager.DamageWithDefense(this, projectile.Damage, projectileDesc.ArmorPiercing, Stats[3]);
            HP -= dmg;

            ApplyConditionEffect(projectileDesc.Effects);
            World.BroadcastIfVisibleExclude(new DamageMessage()
            {
                TargetId = Id,
                Effects = 0,
                DamageAmount = dmg,
                Kill = HP <= 0,
                BulletId = bulletId,
                ObjectId = Id
            }, this, this);

            if (HP <= 0)
                Death(objectDesc.DisplayId ?? objectDesc.IdName, projectile.Spawned);
        }

        public void EnemyHit(ref TickTime tickTime, int time, int bulletId, int targetId, bool killed)
        {
            if (!VisibleProjectiles.TryGetValue(Id, out var dict))
            {
                //Console.WriteLine($"[EnemyHit] {Name} -> {Id} not present in VisibleProjectiles List");
                return;
            }

            if (!dict.TryGetValue(bulletId, out var projectile))
            {
                //Console.WriteLine($"[EnemyHit] {Name} -> {bulletId} not present in VisibleProjectiles List");
                return;
            }

            var objectDesc = GameServer.Resources.GameData.Items[(ushort)projectile.ObjectType];
            var projectileDesc = objectDesc.Projectiles[projectile.BulletType];

            if (projectile.Disabled)
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {bulletId} Projectile Already Disabled: Multihit: {projectileDesc.MultiHit}");
                return;
            }

            var elapsedSinceStart = time - projectile.StartTime;
            if (elapsedSinceStart > projectileDesc.LifetimeMS)
            {
                projectile.Disabled = true;
                //Console.WriteLine("[EnemyHit] -> A expired shot tried to hit entity");
                return;
            }

            projectile.Disabled = !projectileDesc.MultiHit;

            var e = World.GetEntity(targetId);
            if(e == null)
                return;

            if (e.Dead)
                return;

            if (e is Enemy)
            {
                var entity = e as Enemy;
                var player = this;

                var dmg = StatsManager.DamageWithDefense(entity, projectile.Damage, projectileDesc.ArmorPiercing, entity.Defense);
                entity.HP -= dmg;

                for (var i = 0; i < 4; i++)
                {
                    var item = player.Inventory[i];
                    if (item == null || !item.Legendary && !item.Mythical)
                        continue;

                    if (item.Demonized)
                        entity.Demonized(player, i);

                    if (item.Vampiric)
                        entity.VampireBlast(player, i, ref tickTime, entity, projectileDesc.MultiHit);

                    if (item.Electrify)
                        entity.Electrify(player, i, ref tickTime, entity);
                }

                entity.ApplyConditionEffect(projectileDesc.Effects);

                World.BroadcastIfVisibleExclude(new DamageMessage()
                {
                    TargetId = entity.Id,
                    Effects = 0,
                    DamageAmount = dmg,
                    Kill = entity.HP < 0,
                    BulletId = bulletId,
                    ObjectId = Id
                }, entity, this);

                entity.DamageCounter.HitBy(this, dmg);

                if (entity.HP < 0)
                {
                    entity.Death(ref tickTime);
                    if (entity.ObjectDesc.BlocksSight)
                    {
                        var tile = World.Map[(int)entity.X, (int)entity.Y];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                        player.PlayerUpdate.UpdateTiles();
                    }
                }
            }

            if(e is StaticObject)
            {
                var s = e as StaticObject;
                if (s.Vulnerable)
                {
                    var dmg = StatsManager.DamageWithDefense(s, projectile.Damage, projectileDesc.ArmorPiercing, s.ObjectDesc.Defense);
                    s.HP -= dmg;

                    World.BroadcastIfVisibleExclude(new DamageMessage()
                    {
                        TargetId = Id,
                        Effects = 0,
                        DamageAmount = dmg,
                        Kill = !s.CheckHP(),
                        BulletId = bulletId,
                        ObjectId = Id
                    }, s, this);
                }
            }
        }

        public void SquareHit(ref TickTime tickTime, int time, int bulletId, int objectId)
        {
            if (!VisibleProjectiles.TryGetValue(objectId, out var dict))
            {
                //Console.WriteLine($"[SquareHit] {Name} -> {objectId} not present in VisibleProjectiles List");
                return;
            }

            if (!dict.TryGetValue(bulletId, out var projectile))
            {
                //Console.WriteLine($"[SquareHit] {Name} -> {bulletId} not present in VisibleProjectiles List");
                return;
            }

            var objectDesc = GameServer.Resources.GameData.ObjectDescs[(ushort)projectile.ObjectType];
            var projectileDesc = objectDesc.Projectiles[projectile.BulletType];

            if (projectile.Disabled)
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {bulletId} Projectile Already Disabled: Multihit: {projectileDesc.MultiHit}");
                return;
            }

            var elapsed = time - projectile.StartTime;
            //var hitPos = projectile.GetPosition(elapsed, bulletId, projectileDesc);

            var elapsedSinceStart = time - projectile.StartTime;
            if (elapsedSinceStart > projectileDesc.LifetimeMS)
            {
                projectile.Disabled = true;
                //Console.WriteLine($"[SquareHit] {Name} -> Projectile Expired");
                return;
            }

            // if not seentiles.contains x, y then not valid 

            projectile.Disabled = true;
        }

        public void OtherHit(ref TickTime tickTime, int time, int bulletId, int objectId, int targetId)
        {
            if (!VisibleProjectiles.TryGetValue(objectId, out var dict))
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {objectId} not present in VisibleProjectiles List");
                return;
            }

            if (!dict.TryGetValue(bulletId, out var projectile))
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {bulletId} not present in VisibleProjectiles List");
                return;
            }

            var objectDesc = GameServer.Resources.GameData.ObjectDescs[(ushort)projectile.ObjectType];
            var projectileDesc = objectDesc.Projectiles[projectile.BulletType];

            if (projectile.Disabled)
            {
                //Console.WriteLine($"[OtherHit] {Name} -> {bulletId} Projectile Already Disabled: Multihit: {projectileDesc.MultiHit}");
                return;
            }

            var elapsed = time - projectile.StartTime;
            var hitPos = projectile.GetPosition(elapsed, bulletId, projectileDesc);

            var elapsedSinceStart = time - projectile.StartTime;
            if (elapsedSinceStart > projectileDesc.LifetimeMS)
            {
                projectile.Disabled = true;
                //Console.WriteLine($"[OtherHit] {Name} -> Projectile Expired");
                return;
            }

            var target = World.GetEntity(targetId);
            if (target != null)
            {
                projectile.Disabled = !projectileDesc.MultiHit;
                //Console.WriteLine($"[OtherHit] {Name} -> (Entity) Success, Disabled Projectile");
                return;
            }

            // must be static
            var tile = World.Map[(int)hitPos.X, (int)hitPos.Y];
            if (tile.ObjId == targetId) // still unable to find?
            {
                projectile.Disabled = true;
                //Console.WriteLine($"[OtherHit] {Name} -> (Static) Success, Disabled Projectile");
                return;
            }

            Console.WriteLine($"[OtherHit] {Name} -> Failure Unknown OtherHit target END OF LOGIC");
        }

        public void HandleProjectileDetection(int time, float x, float y, ref TimedPosition[] moveRecords)
        {
            // todo more validation on records

            var visibleProjectileToRemove = new List<ValueTuple<int, int>>();
            foreach (var dict in VisibleProjectiles)
                foreach (var kvp in dict.Value)
                {
                    ProjectileDesc projectileDesc;
                    if (kvp.Value.DamagesEnemies)
                    {
                        var objectDesc = GameServer.Resources.GameData.Items[(ushort)kvp.Value.ObjectType];
                        projectileDesc = objectDesc.Projectiles[0];
                    }
                    else
                    {
                        var objectDesc = GameServer.Resources.GameData.ObjectDescs[(ushort)kvp.Value.ObjectType];
                        projectileDesc = objectDesc.Projectiles[kvp.Value.BulletType];
                    }

                    var elapsed = time - kvp.Value.StartTime;
                    if (elapsed > projectileDesc.LifetimeMS)
                        visibleProjectileToRemove.Add(ValueTuple.Create(dict.Key, kvp.Key));
                }

            foreach (var kvp in visibleProjectileToRemove)
            {
                _ = VisibleProjectiles[kvp.Item1].Remove(kvp.Item2);
                if (VisibleProjectiles[kvp.Item1].Count == 0)
                    VisibleProjectiles.Remove(kvp.Item1);
            }
        }

    }
}
