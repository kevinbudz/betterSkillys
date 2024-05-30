using Shared.resources;
using Shared.utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using WorldServer.core.net.stats;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.utils
{
    public static class EntityUtils
    {
        public static bool AnyEnemyNearby(this Entity entity, int radius = World.CULL_RANGE)
        {
            foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, radius))
            {
                if (i is not Enemy || entity == i)
                    continue;

                var d = i.SqDistTo(entity);
                if (d < radius * radius)
                    return true;
            }

            return false;
        }

        public static bool AnyEnemyNearby(this World world, float x, float y, int radius = World.CULL_RANGE)
        {
            foreach (var i in world.EnemiesCollision.HitTest(x, y, radius))
            {
                if (i is not Enemy)
                    continue;

                var d = i.SqDistTo(x, y);
                if (d < radius * radius)
                    return true;
            }

            return false;
        }

        public static bool AnyPlayerNearby(this Entity entity, int radius = World.CULL_RANGE)
        {
            foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, radius).Where(e => e is Player p && !p.IsHidden))
            {
                var d = i.SqDistTo(entity);

                if (d < radius * radius)
                    return true;
            }

            return false;
        }

        public static bool AnyPlayerNearby(this World world, float x, float y, int radius = World.CULL_RANGE)
        {
            foreach (var i in world.PlayersCollision.HitTest(x, y, radius).Where(e => e is Player p && !p.IsHidden))
            {
                var d = i.SqDistTo(x, y);
                if (d < radius * radius)
                    return true;
            }
            return false;
        }

        public static void AOE(this Entity entity, float radius, ushort? objType, Action<Entity> callback)   //Null for entity
        {
            if (objType == null)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, radius).Where(e => e is Player))
                {
                    var d = i.DistTo(entity);
                    if (d < radius)
                        callback(i);
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, radius))
                {
                    if (i.ObjectType != objType.Value)
                        continue;

                    var d = i.DistTo(entity);
                    if (d < radius)
                        callback(i);
                }
        }

        public static void AOE(this Entity entity, float radius, bool players, Action<Entity> callback)   //Null for entity
        {
            if (players)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, radius).Where(e => e is Player))
                {
                    var d = i.DistTo(entity);
                    if (d < radius)
                        callback(i);
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, radius))
                {
                    if (i is not Enemy)
                        continue;

                    var d = i.DistTo(entity);

                    if (d < radius)
                        callback(i);
                }
        }

        public static void AOE(this World world, Position pos, float radius, bool players, Action<Entity> callback)   //Null for entity
        {
            if (players)
            {
                foreach (var i in world.PlayersCollision.HitTest(pos.X, pos.Y, radius).Where(e => e is Player))
                {
                    var d = i.DistTo(pos.X, pos.Y);
                    if (d < radius)
                        callback(i);
                }
            }
            else
            {
                foreach (var i in world.EnemiesCollision.HitTest(pos.X, pos.Y, radius))
                {
                    if (!(i is Enemy e) || e.ObjectDesc.Static)
                        continue;

                    var d = i.DistTo(pos.X, pos.Y);
                    if (d < radius)
                        callback(i);
                }
            }
        }

        public static int CountEntity(this Entity entity, double dist, ushort? objType)
        {
            if (entity.World == null)
                return 0;

            var ret = 0;

            if (objType == null)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, dist).Where(e => e is Player))
                {
                    if (!(i as IPlayer).IsVisibleToEnemy())
                        continue;

                    var d = i.DistTo(entity);
                    if (d < dist)
                        ret++;
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    if (i.ObjectType != objType.Value)
                        continue;

                    var d = i.DistTo(entity);
                    if (d < dist)
                        ret++;
                }

            return ret;
        }

        public static int CountEntity(this Entity entity, double dist, string group)
        {
            if (entity.World == null)
                return 0;

            var ret = 0;

            foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
            {
                if (i.ObjectDesc == null || i.ObjectDesc.Group != group)
                    continue;

                var d = i.DistTo(entity);
                if (d < dist)
                    ret++;
            }

            return ret;
        }

        public static void ForceUpdate(this Entity e, int slot)
        {
            if (e == null || !(e is Player) && slot >= 8)
                return;

            switch (slot)
            {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                    e.InvokeStatChange((StatDataType)((int)StatDataType.Inventory0 + slot), (e as IContainer).Inventory[slot]?.ObjectType ?? -1);
                    e.InvokeStatChange((StatDataType)((int)StatDataType.InventoryData0 + slot), (e as IContainer).Inventory.Data[slot]?.GetData() ?? "{}");
                    break;

                case 12:
                case 13:
                case 14:
                case 15:
                case 16:
                case 17:
                case 18:
                case 19:
                    e.InvokeStatChange((StatDataType)((int)StatDataType.BackPack0 + slot), (e as IContainer).Inventory[slot]?.ObjectType ?? -1);
                    e.InvokeStatChange((StatDataType)((int)StatDataType.BackPackData0 + slot), (e as IContainer).Inventory.Data[slot]?.GetData() ?? "{}");
                    break;

                case 20:
                case 21:
                case 22:
                case 23:
                case 24:
                case 25:
                case 26:
                case 254:
                    e.InvokeStatChange(StatDataType.HealthStackCount, (e as Player).HealthPotionStack.Count);
                    break;

                case 255:
                    e.InvokeStatChange(StatDataType.MagicStackCount, (e as Player).MagicPotionStack.Count);
                    break;
            }
        }

        public static Entity GetLowestHpEntity(this Entity entity, double dist, ushort? objType, bool seeInvis = false) // objType = null for entity
        {
            var entities = entity.GetNearestEntities(dist, objType, seeInvis).OfType<Character>();

            if (!entities.Any())
                return null;

            var lowestHp = entities.Min(e => e.Health);

            return entities.FirstOrDefault(e => e.Health == lowestHp);
        }

        public static IEnumerable<Entity> GetNearestEntities(this Entity entity, double dist, ushort? objType, bool seeInvis = false)   //Null for entity
        {
            if (entity.World == null)
                yield break;

            if (objType == null)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, dist).Where(e => e is IPlayer))
                {
                    if (!seeInvis && !(i as IPlayer).IsVisibleToEnemy())
                        continue;

                    var d = i.DistTo(entity);

                    if (d < dist)
                        yield return i;
                }
            else if (objType == 0)
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    var d = i.DistTo(entity);

                    if (d < dist)
                        yield return i;
                }
            else if (objType == 1)
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    if (i.Name == entity.Name)
                        continue;
                    var d = i.DistTo(entity);
                    if (d < dist)
                        yield return i;
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    if (i.ObjectType != objType.Value)
                        continue;

                    var d = i.DistTo(entity);

                    if (d < dist)
                        yield return i;
                }
        }

        public static IEnumerable<Entity> GetNearestEntitiesByGroup(this Entity entity, double dist, string group)
        {
            if (entity.World == null)
                yield break;

            foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
            {
                if (i.ObjectDesc == null || i.ObjectDesc.Group == null || !i.ObjectDesc.Group.Equals(group, StringComparison.InvariantCultureIgnoreCase))
                    continue;

                var d = i.DistTo(entity);

                if (d < dist)
                    yield return i;
            }
        }

        public static IEnumerable<Entity> GetNearestEntitiesByName(this Entity entity, double dist, string id)
        {
            if (entity.World == null)
                yield break;

            foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
            {
                if (i.ObjectDesc == null || id != null && !i.ObjectDesc.IdName.ContainsIgnoreCase(id))
                    continue;

                var d = i.DistTo(entity);

                if (d < dist)
                    yield return i;
            }
        }

        public static IEnumerable<Entity> GetNearestEntitiesBySquare(this Entity entity, double dist, ushort? objType, bool seeInvis = false)   //Null for entity
        {
            if (entity.World == null)
                yield break;

            if (objType == null)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, dist).Where(e => e is IPlayer))
                {
                    if (!seeInvis && !(i as IPlayer).IsVisibleToEnemy())
                        continue;

                    var d = i.DistTo(entity);

                    if (d < dist)
                        yield return i;
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    if (i.ObjectType != objType.Value)
                        continue;

                    var d = i.DistTo(entity);

                    if (d < dist)
                        yield return i;
                }
        }

        public static Entity GetNearestEntity(this Entity entity, double dist, ushort? objType, bool seeInvis = false)   //Null for entity
        {
            var entities = entity.GetNearestEntities(dist, objType, seeInvis).ToArray();

            if (entities.Length <= 0)
                return null;

            return entities.Aggregate((curmin, x) => curmin == null || x.SqDistTo(entity) < curmin.SqDistTo(entity) ? x : curmin);
        }

        public static Entity GetNearestEntity(this Entity entity, double dist, bool players, Predicate<Entity> predicate = null)
        {
            if (entity.World == null)
                return null;

            Entity ret = null;

            if (players)
                foreach (var i in entity.World.PlayersCollision.HitTest(entity.X, entity.Y, dist).Where(e => e is IPlayer))
                {
                    if (!(i as IPlayer).IsVisibleToEnemy() || i == entity)
                        continue;

                    var d = i.DistTo(entity);

                    if (d < dist)
                    {
                        if (predicate != null && !predicate(i))
                            continue;

                        dist = d;
                        ret = i;
                    }
                }
            else
                foreach (var i in entity.World.EnemiesCollision.HitTest(entity.X, entity.Y, dist))
                {
                    if (i == entity)
                        continue;

                    var d = i.DistTo(entity);
                    if (d < dist)
                    {
                        if (predicate != null && !predicate(i))
                            continue;

                        dist = d;
                        ret = i;
                    }
                }

            return ret;
        }

        public static Entity GetNearestEntityByGroup(this Entity entity, double dist, string group)
        {
            // function speed might be a problem
            var entities = entity.GetNearestEntitiesByGroup(dist, group).ToArray();

            if (entities.Length <= 0)
                return null;

            return entities.Aggregate((curmin, x) => curmin == null || x.SqDistTo(entity) < curmin.SqDistTo(entity) ? x : curmin);
        }

        public static Entity GetNearestEntityByName(this Entity entity, double dist, string id)
        {
            // function speed might be a problem
            var entities = entity.GetNearestEntitiesByName(dist, id).ToArray();

            if (entities.Length <= 0)
                return null;

            return entities.Aggregate((curmin, x) => curmin == null || x.SqDistTo(entity) < curmin.SqDistTo(entity) ? x : curmin);
        }

        public static float GetSpeed(this Entity entity, float spd) => entity.HasConditionEffect(ConditionEffectIndex.Slowed) ? spd * 0.5f : spd;
        //public static float GetSpeed(this Entity entity, float spd) => entity.HasConditionEffect(ConditionEffects.Slowed) ? (5.55f * spd + 0.74f) / 2 : 5.55f * spd + 0.74f;
    }
}
