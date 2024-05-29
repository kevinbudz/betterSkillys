using Shared.resources;
using System;
using System.Collections.Generic;
using WorldServer.core.net.datas;
using WorldServer.core.net.stats;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.logic;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    public partial class Player
    {
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
            TryAddOnPlayerEffects("shoot");
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

            var dmg = StatsManager.DamageWithDefense(this, projectile.Damage, projectileDesc.ArmorPiercing, Stats[3]);
            Health -= dmg;

            TryAddOnPlayerEffects("hit", dmg);

            ApplyConditionEffect(projectileDesc.Effects);
            World.BroadcastIfVisibleExclude(new DamageMessage()
            {
                TargetId = Id,
                Effects = 0,
                DamageAmount = dmg,
                Kill = Health <= 0,
                BulletId = bulletId,
                ObjectId = Id
            }, this, this);

            if (Health <= 0)
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
                entity.Health -= dmg;

                TryAddOnEnemyHitEffect(ref tickTime, entity, projectileDesc);

                entity.ApplyConditionEffect(projectileDesc.Effects);

                World.BroadcastIfVisibleExclude(new DamageMessage()
                {
                    TargetId = entity.Id,
                    Effects = 0,
                    DamageAmount = dmg,
                    Kill = entity.Health < 0,
                    BulletId = bulletId,
                    ObjectId = Id
                }, entity, this);

                entity.DamageCounter.HitBy(this, dmg);

                if (entity.Health < 0)
                {
                    entity.Death(ref tickTime);
                    if (entity.ObjectDesc.BlocksSight)
                    {
                        var tile = World.Map[(int)entity.X, (int)entity.Y];
                        tile.ObjType = 0;
                        tile.UpdateCount++;
                        player.UpdateTiles();
                    }
                }
            }

            if(e is StaticObject)
            {
                var s = e as StaticObject;
                if (s.Vulnerable)
                {
                    var dmg = StatsManager.DamageWithDefense(s, projectile.Damage, projectileDesc.ArmorPiercing, s.ObjectDesc.Defense);
                    s.Health -= dmg;

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
