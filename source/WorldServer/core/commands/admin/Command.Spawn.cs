using Newtonsoft.Json;
using System;
using System.Linq;
using Shared;
using Shared.resources;
using Shared.utils;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking.packets.outgoing;
using WorldServer.utils;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        internal class Spawn : Command
        {
            private struct JsonSpawn
            {
                public string notif;
                public SpawnProperties[] spawns;
            }

            private struct SpawnProperties
            {
                public string name;
                public int? hp;
                public int? size;
                public int? count;
                public int[] x;
                public int[] y;
                public bool? target;
                public string clasify;
            }

            private const int Delay = 0; // in seconds

            public override RankingType RankRequirement => RankingType.Admin;
            public override string CommandName => "spawn";

            protected override bool Process(Player player, TickTime time, string args)
            {
                args = args.Trim();
                if (!(player.World is RealmWorld) && player.GameServer.Configuration.serverInfo.testing)
                {
                    player.SendError("You cant spawn in realm");
                    return false;
                }

                if (player.World is RealmWorld && player.GameServer.Configuration.serverInfo.testing)
                {
                    var tile = player.World.Map[(int)player.X, (int)player.Y];
                    if (tile.Terrain != TerrainType.Mountains)
                    {
                        player.SendError("You must be in glands to use this command");
                        return false;
                    }
                }

                return args.StartsWith("{") ? SpawnJson(player, args) : SpawnBasic(player, args);
            }

            private bool SpawnJson(Player player, string json)
            {
                var gameData = player.GameServer.Resources.GameData;

                JsonSpawn props;
                try
                {
                    props = JsonConvert.DeserializeObject<JsonSpawn>(json);
                }
                catch (Exception)
                {
                    player.SendError("JSON not formatted correctly!");
                    return false;
                }

                if (props.spawns != null)
                    foreach (var spawn in props.spawns)
                    {
                        if (spawn.name == null)
                        {
                            player.SendError("No mob specified. Every entry needs a name property.");
                            return false;
                        }

                        var objType = GetSpawnObjectType(gameData, spawn.name);
                        if (objType == null)
                        {
                            player.SendError("Unknown entity!");
                            return false;
                        }

                        var desc = gameData.ObjectDescs[objType.Value];

                        var hp = desc.MaxHP;
                        if (spawn.hp > hp && spawn.hp < int.MaxValue)
                            hp = spawn.hp.Value;

                        var size = desc.MinSize;
                        if (spawn.size >= 25 && spawn.size <= 500)
                            size = spawn.size.Value;

                        var count = 1;
                        if (spawn.count > count && spawn.count <= 500)
                            count = spawn.count.Value;

                        int[] x = null;
                        int[] y = null;

                        if (spawn.x != null)
                            x = new int[spawn.x.Length];

                        if (spawn.y != null)
                            y = new int[spawn.y.Length];

                        if (x != null)
                        {
                            for (int i = 0; i < x.Length && i < count; i++)
                            {
                                if (spawn.x[i] > 0 && spawn.x[i] <= player.World.Map.Width)
                                {
                                    x[i] = spawn.x[i];
                                }
                            }
                        }

                        if (y != null)
                        {
                            for (int i = 0; i < y.Length && i < count; i++)
                            {
                                if (spawn.y[i] > 0 && spawn.y[i] <= player.World.Map.Height)
                                {
                                    y[i] = spawn.y[i];
                                }
                            }
                        }

                        var clasified = "normal";
                        if (spawn.clasify != null)
                            clasified = spawn.clasify;

                        bool target = false;
                        if (spawn.target != null)
                            target = spawn.target.Value;

                        QueueSpawnEvent(player, count, objType.Value, hp, size, x, y, target, clasified);
                    }

                if (props.notif != null)
                {
                    NotifySpawn(player, props.notif);
                }

                return true;
            }

            private bool SpawnBasic(Player player, string args)
            {
                var gameData = player.GameServer.Resources.GameData;

                // split argument
                var index = args.IndexOf(' ');
                var name = args;
                if (args.IndexOf(' ') > 0 && int.TryParse(args.Substring(0, args.IndexOf(' ')), out int num)) //multi
                    name = args.Substring(index + 1);
                else
                    num = 1;

                var objType = GetSpawnObjectType(gameData, name);
                if (objType == null)
                {
                    player.SendError("Unknown entity!");
                    return false;
                }

                if (num <= 0)
                {
                    player.SendInfo($"Really? {num} {name}? I'll get right on that...");
                    return false;
                }

                //if(num > 10 && player.Rank <120)
                //{
                //    player.SendError("Only 10!");
                //    return false;
                //}

                var id = player.GameServer.Resources.GameData.ObjectTypeToId[objType.Value];
                NotifySpawn(player, id, num);
                QueueSpawnEvent(player, num, objType.Value);
                return true;
            }

            private ushort? GetSpawnObjectType(XmlData gameData, string name)
            {
                if (!gameData.IdToObjectType.TryGetValue(name, out ushort objType) ||
                    !gameData.ObjectDescs.ContainsKey(objType))
                {
                    // no match found, try to get partial match
                    var mobs = gameData.IdToObjectType
                        .Where(m => m.Key.ContainsIgnoreCase(name) && gameData.ObjectDescs.ContainsKey(m.Value))
                        .Select(m => gameData.ObjectDescs[m.Value]);

                    if (!mobs.Any())
                        return null;

                    var maxHp = mobs.Max(e => e.MaxHP);
                    objType = mobs.First(e => e.MaxHP == maxHp).ObjectType;
                }

                return objType;
            }

            private void NotifySpawn(Player player, string mob, int? num = null)
            {
                var w = player.World;

                var notif = mob;
                if (num != null)
                    notif = "Spawning " + ((num > 1) ? num + " " : "") + mob + "...";

                w.BroadcastIfVisible(new Notification
                {
                    Color = new ARGB(0xffff0000),
                    ObjectId = player.Id,
                    Message = notif
                }, player);

                w.BroadcastIfVisible(new Text
                {
                    Name = $"#{player.Name}",
                    NumStars = player.Stars,
                    BubbleTime = 0,
                    Txt = notif
                }, player);
            }

            private void QueueSpawnEvent(
                Player player,
                int num,
                ushort mobObjectType, int? hp = null, int? size = null,
                int[] x = null, int[] y = null,
                bool? target = false, string clasified = "normal")
            {
                var pX = player.X;
                var pY = player.Y;

                for (var i = 0; i < num && i < (player.GameServer.Configuration.serverInfo.testing ? player.IsAdmin ? 500 : 1 : 500); i++)
                {
                    Entity entity;
                    try
                    {
                        entity = Entity.Resolve(player.World.GameServer, mobObjectType);
                    }
                    catch (Exception e)
                    {
                        StaticLogger.Instance.Error(e.ToString());
                        return;
                    }

                    entity.Spawned = true;

                    if (entity is Enemy enemy)
                    {
                        if (hp != null)
                        {
                            enemy.Health = hp.Value;
                            enemy.MaxHealth = enemy.Health;
                        }

                        if (size != null)
                            enemy.Size = size.Value;

                        if (target == true)
                            enemy.AttackTarget = player;
                    }

                    if (clasified != "normal")
                        (entity as Enemy).ClasifyEnemyJson(clasified);

                    var sX = (x != null && i < x.Length) ? x[i] : pX;
                    var sY = (y != null && i < y.Length) ? y[i] : pY;

                    entity.Move(sX, sY);

                    player.World.EnterWorld(entity);
                }
            }
        }
    }
}
