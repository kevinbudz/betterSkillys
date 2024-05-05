using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TKR.Shared;
using TKR.Shared.resources;
using TKR.WorldServer.core.objects;
using TKR.WorldServer.core.setpieces;
using TKR.WorldServer.core.structures;
using TKR.WorldServer.core.worlds.impl;
using TKR.WorldServer.networking.packets.outgoing;
using TKR.WorldServer.utils;

namespace TKR.WorldServer.core.worlds
{
    public enum KingdomState
    {
        Idle,
        Emptying,
        Closed,
        DoNothing
    }

    public sealed class KingdomManager
    {
        public int _EventCount = 0;
        public RealmWorld World;

        private static readonly Tuple<string, TauntData>[] CriticalEnemies = new Tuple<string, TauntData>[]
        {
            Tuple.Create("Skull Shrine", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Skull Shrine"
            }),
            Tuple.Create("Cube God", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Cube God"
            }),
            Tuple.Create("Pentaract", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Pentaract"
            }),
            Tuple.Create("Grand Sphinx", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Grand Sphinx"
            }),
            Tuple.Create("Lord of the Lost Lands", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Lord of the Lost Lands"
            }),
            Tuple.Create("Hermit God", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                NumberOfEnemies = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Hermit God"
            }),
            Tuple.Create("Ghost Ship", new TauntData()
            {
                Spawn = new string[] {
                    ""
                },
                Final = new string[] {
                    ""
                },
                Killed = new string[] {
                    ""
                },
                NameOfDeath = "Ghost Ship"
            })
        };

        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private static readonly Dictionary<TerrainType, Tuple<int, Tuple<string, double>[]>> RegionMobs = new Dictionary<TerrainType, Tuple<int, Tuple<string, double>[]>>()
        {
            { TerrainType.ShoreSand, Tuple.Create(
                100, new []
                {
                    Tuple.Create("Pirate", 0.3),
                    Tuple.Create("Piratess", 0.1),
                    Tuple.Create("Snake", 0.2),
                    Tuple.Create("Scorpion Queen", 0.4),
                })
            },
            { TerrainType.ShorePlains, Tuple.Create(
                150, new []
                {
                    Tuple.Create("Bandit Leader", 0.4),
                    Tuple.Create("Red Gelatinous Cube", 0.2),
                    Tuple.Create("Purple Gelatinous Cube", 0.2),
                    Tuple.Create("Green Gelatinous Cube", 0.2),
                })
            },
            { TerrainType.LowPlains, Tuple.Create(
                200, new []
                {
                    Tuple.Create("Hobbit Mage", 0.5),
                    Tuple.Create("Undead Hobbit Mage", 0.4),
                    Tuple.Create("Sumo Master", 0.1),
                })
            },
            { TerrainType.LowForest, Tuple.Create(
                200, new []
                {
                    Tuple.Create("Elf Wizard", 0.2),
                    Tuple.Create("Goblin Mage", 0.2),
                    Tuple.Create("Easily Enraged Bunny", 0.3),
                    Tuple.Create("Forest Nymph", 0.3),
                })
            },
            { TerrainType.LowSand, Tuple.Create(
                200, new []
                {
                    Tuple.Create("Sandsman King", 0.4),
                    Tuple.Create("Giant Crab", 0.2),
                    Tuple.Create("Sand Devil", 0.4),
                })
            },
            { TerrainType.MidPlains, Tuple.Create(
                150, new []
                {
                    Tuple.Create("Fire Sprite", 0.1),
                    Tuple.Create("Ice Sprite", 0.1),
                    Tuple.Create("Magic Sprite", 0.1),
                    Tuple.Create("Pink Blob", 0.07),
                    Tuple.Create("Gray Blob", 0.07),
                    Tuple.Create("Earth Golem", 0.04),
                    Tuple.Create("Paper Golem", 0.04),
                    Tuple.Create("Big Green Slime", 0.08),
                    Tuple.Create("Swarm", 0.05),
                    Tuple.Create("Wasp Queen", 0.2),
                    Tuple.Create("Shambling Sludge", 0.03),
                    Tuple.Create("Orc King", 0.06)
                })
            },
            { TerrainType.MidForest, Tuple.Create(
                150, new []
                {
                    Tuple.Create("Dwarf King", 0.3),
                    Tuple.Create("Metal Golem", 0.05),
                    Tuple.Create("Clockwork Golem", 0.05),
                    Tuple.Create("Werelion", 0.1),
                    Tuple.Create("Horned Drake", 0.3),
                    Tuple.Create("Red Spider", 0.1),
                    Tuple.Create("Black Bat", 0.1)
                })
            },
            { TerrainType.MidSand, Tuple.Create(
                300, new []
                {
                    Tuple.Create("Desert Werewolf", 0.25),
                    Tuple.Create("Fire Golem", 0.1),
                    Tuple.Create("Darkness Golem", 0.1),
                    Tuple.Create("Sand Phantom", 0.2),
                    Tuple.Create("Nomadic Shaman", 0.25),
                    Tuple.Create("Great Lizard", 0.1),
                })
            },
            { TerrainType.HighPlains, Tuple.Create(
                300, new []
                {
                    Tuple.Create("Shield Orc Key", 0.2),
                    Tuple.Create("Urgle", 0.2),
                    Tuple.Create("Undead Dwarf God", 0.6)
                })
            },
            { TerrainType.HighForest, Tuple.Create(
                300, new []
                {
                    Tuple.Create("Ogre King", 0.4),
                    Tuple.Create("Dragon Egg", 0.1),
                    Tuple.Create("Lizard God", 0.5),
                    Tuple.Create("Beer God", 0.1)
                })
            },
            { TerrainType.HighSand, Tuple.Create(
                250, new []
                {
                    Tuple.Create("Minotaur", 0.4),
                    Tuple.Create("Flayer God", 0.4),
                    Tuple.Create("Flamer King", 0.2)
                })
            },
            { TerrainType.Mountains, Tuple.Create(
                125, new []
                {
                    Tuple.Create("White Demon", 0.09),
                    Tuple.Create("Sprite God", 0.09),
                    Tuple.Create("Medusa", 0.09),
                    Tuple.Create("Ent God", 0.09),
                    Tuple.Create("Beholder", 0.09),
                    Tuple.Create("Flying Brain", 0.09),
                    Tuple.Create("Slime God", 0.09),
                    Tuple.Create("Ghost God", 0.09),
                    Tuple.Create("Rock Bot", 0.01),
                    Tuple.Create("Djinn", 0.09),
                    Tuple.Create("Leviathan", 0.09),
                    Tuple.Create("Arena Headless Horseman", 0.09)
                })
            },
        };

        private readonly List<Tuple<string, ISetPiece>> _events = new List<Tuple<string, ISetPiece>>()
        {
            Tuple.Create("Cube God", (ISetPiece) null),
            Tuple.Create("Pentaract", (ISetPiece) new Pentaract()),
            Tuple.Create("Lord of the Lost Lands", (ISetPiece) null),
            Tuple.Create("Ghost Ship", (ISetPiece) new GhostShip()),
            Tuple.Create("Grand Sphinx", (ISetPiece) new Sphinx()),
            Tuple.Create("Hermit God", (ISetPiece) new Hermit()),
            Tuple.Create("Skull Shrine", (ISetPiece) new SkullShrine()),
            Tuple.Create("Lucky Ent God", (ISetPiece) null),
            Tuple.Create("Lucky Djinn", (ISetPiece) null),
        };

        private int[] EnemyCounts = new int[12];
        private int[] EnemyMaxCounts = new int[12];
        private long LastEnsurePopulationTime;
        private long LastAnnouncementTime;
        private long LastQuestTime;

        public KingdomState CurrentState;
        public bool DisableSpawning;

        public KingdomManager(RealmWorld world)
        {
            World = world;
            CurrentState = KingdomState.Idle;
        }

        public void Update(ref TickTime time)
        {
            switch (CurrentState)
            {
                case KingdomState.Idle:
                    {
                        if (time.TotalElapsedMs - LastQuestTime >= 10000)
                        {
                            EnsureQuest();
                            LastQuestTime = time.TotalElapsedMs;
                        }

                        if (time.TotalElapsedMs - LastAnnouncementTime >= 20000)
                        {
                            HandleAnnouncements();
                            LastAnnouncementTime = time.TotalElapsedMs;
                        }

                        if (time.TotalElapsedMs - LastEnsurePopulationTime >= 60000)
                        {
                            EnsurePopulation();
                            LastEnsurePopulationTime = time.TotalElapsedMs;
                        }
                    }
                    break;
                case KingdomState.Emptying:
                    {
                        BroadcastMsg("RAAHH MY TROOPS HAVE FAILED ME!");
                        BroadcastMsg("THIS KINGDOM SHALL NOT FALL!!");

                        CurrentState = KingdomState.DoNothing;

                        foreach (var e in World.Enemies.Values)
                        {
                            if (e.ObjectDesc.IdName.Contains("Oryx Guardian TaskMaster") || e.ObjectDesc.IdName.Contains("Talisman King's Golden Guardian"))
                                continue;
                            World.LeaveWorld(e);
                        }

                        World.StartNewTimer(30000, (w, t) => CurrentState = KingdomState.Closed);
                    }
                    break;
                case KingdomState.Closed:
                    {
                        BroadcastMsg("ENOUGH WAITING!");
                        BroadcastMsg("YOU SHALL MEET YOUR DOOM BY MY HAND!!!");
                        BroadcastMsg("GUARDIANS AWAKEN AND KILL THESE FOOLS!!!");

                        foreach (var e in World.Enemies.Values)
                        {
                            if (e.ObjectDesc.IdName.Contains("Oryx Guardian TaskMaster"))
                                continue;

                            if (e.ObjectDesc.IdName.Contains("Talisman King's Golden Guardian"))
                                e.Death(ref time);
                        }

                        MovePeopleNearby(time);

                        CurrentState = KingdomState.DoNothing;
                    }
                    break;
                case KingdomState.DoNothing:
                    break;
            }
        }

        public void EnsureQuest()
        {
            if (HasQuestAlready || DisableSpawning)
                return;

            var events = _events;
            var evt = events[Random.Shared.Next(0, events.Count)];
            var gameData = World.GameServer.Resources.GameData;

            if (gameData.ObjectDescs[gameData.IdToObjectType[evt.Item1]].PerRealmMax == 1)
                events.Remove(evt);

            SpawnEvent(evt.Item1, evt.Item2);
            HasQuestAlready = true;
        }

        public void AnnounceMVP(Enemy eventDead, string name)
        {
            var hitters = eventDead.DamageCounter.GetHitters();
            if (hitters.Count == 0)
                return;

            var mvp = hitters.Aggregate((a, b) => a.Value > b.Value ? a : b).Key;
            if (mvp == null)
                return;

            var playerCount = hitters.Count;
            var dmgPercentage = (float)Math.Round(100.0 * (hitters[mvp] / (double)eventDead.DamageCounter.TotalDamage), 0);
            if (eventDead.Name.Contains("Pentaract"))
                dmgPercentage = (float)Math.Round(dmgPercentage / 5, 0);

            var sb = new StringBuilder($"{mvp.Name} dealt {dmgPercentage}% damage to {name}");
            if (playerCount > 1)
            {
                var playerAssist = playerCount - 1;
                if (playerAssist == 1)
                    _ = sb.Append(" with one other person helping");
                else
                    _ = sb.Append($" with {playerAssist} people helping");
            }
            else
                _ = sb.Append(" solo");
            _ = sb.Append("!");
            var text = new Text()
            {
                BubbleTime = 0,
                NumStars = -1,
                Name = "Oryx the Mad God",
                Txt = sb.ToString(),
                TextColor = 0xFFFFFF,
                NameColor = 0xFF681F
            };
            World.Broadcast(text);
        }
        public void CountingEvents(string eventDead)
        {
            if (DisableSpawning)
                return;
            HasQuestAlready = false;

            _EventCount++;
            World.ForeachPlayer(player =>
            {
                player.SendInfo($"<Realm> {eventDead} has been defeated! [{_EventCount}/25]");
            });

            if (_EventCount == 25)
                _ = World.CloseRealm();
        }

        public void Init()
        {
            SpawnEvent("Skull Shrine", new SkullShrine(), 1024, 1024);

            var events = _events;
            var evt = events[Random.Shared.Next(0, events.Count)];
            var gameData = World.GameServer.Resources.GameData;

            if (gameData.ObjectDescs[gameData.IdToObjectType[evt.Item1]].PerRealmMax == 1)
                events.Remove(evt);

            var w = World.Map.Width;
            var h = World.Map.Height;
            var stats = new int[12];

            for (var y = 0; y < h; y++)
                for (var x = 0; x < w; x++)
                {
                    var tile = World.Map[x, y];
                    if (tile.Terrain != TerrainType.None)
                        stats[(int)tile.Terrain - 1]++;
                }

            foreach (var i in RegionMobs)
            {
                var terrain = i.Key;
                var idx = (int)terrain - 1;
                var enemyCount = stats[idx] / i.Value.Item1;
                EnemyMaxCounts[idx] = enemyCount;
                EnemyCounts[idx] = 0;

                for (var j = 0; j < enemyCount; j++)
                {
                    var objType = GetRandomObjType(i.Value.Item2);

                    if (objType == 0)
                        continue;

                    EnemyCounts[idx] += Spawn(World.GameServer.Resources.GameData.ObjectDescs[objType], terrain, w, h);

                    if (EnemyCounts[idx] >= enemyCount)
                        break;
                }
            }

            World.StartNewTimer(15000, (world, t) => SpawnEvent(evt.Item1, evt.Item2));
        }

        public void OnEnemyKilled(Enemy enemy, Player killer)
        {
            foreach (var dat in CriticalEnemies)
                if (enemy.ObjectDesc.IdName == dat.Item1)
                {
                    CountingEvents(dat.Item2.NameOfDeath);
                    AnnounceMVP(enemy, dat.Item2.NameOfDeath);
                    break;
                }
        }

        private bool HasQuestAlready;

        public void OnPlayerEntered(Player player)
        {
            player.SendInfo("Welcome to betterSkilys");
            player.SendEnemy("Oryx the Mad God", "You are a pest to my kingdom!");
            player.SendInfo("Use [WASDQE] to move; click to shoot!");
            player.SendInfo("Type \"/commands\" for more help");
        }

        private static double GetNormal(Random rand)
        {
            // Use Box-Muller algorithm
            var u1 = GetUniform(rand);
            var u2 = GetUniform(rand);
            var r = Math.Sqrt(-2.0 * Math.Log(u1));
            var theta = 2.0 * Math.PI * u2;

            return r * Math.Sin(theta);
        }

        private static double GetNormal(Random rand, double mean, double standardDeviation) => mean + standardDeviation * GetNormal(rand);

        private static double GetUniform(Random rand) => ((uint)(rand.NextDouble() * uint.MaxValue) + 1.0) * 2.328306435454494e-10;

        private void BroadcastMsg(string message) => World.GameServer.ChatManager.Oryx(World, message);

        private void EnsurePopulation()
        {
            RecalculateEnemyCount();

            var state = new int[12];
            var diff = new int[12];
            var c = 0;

            for (var i = 0; i < state.Length; i++)
            {
                if (EnemyCounts[i] > EnemyMaxCounts[i] * 1.5) //Kill some
                {
                    state[i] = 1;
                    diff[i] = EnemyCounts[i] - EnemyMaxCounts[i];
                    c++;
                    continue;
                }

                if (EnemyCounts[i] < EnemyMaxCounts[i] * 0.75) //Add some
                {
                    state[i] = 2;
                    diff[i] = EnemyMaxCounts[i] - EnemyCounts[i];
                    continue;
                }

                state[i] = 0;
            }

            foreach (var i in World.Enemies) //Kill
            {
                var idx = (int)i.Value.Terrain - 1;

                if (idx == -1 || state[idx] == 0 || i.Value.GetNearestEntity(10, true) != null || diff[idx] == 0)
                    continue;

                if (state[idx] == 1)
                {
                    World.LeaveWorld(i.Value);
                    diff[idx]--;
                    if (diff[idx] == 0)
                        c--;
                }

                if (c == 0)
                    break;
            }

            var w = World.Map.Width;
            var h = World.Map.Height;

            for (var i = 0; i < state.Length; i++) //Add
            {
                if (state[i] != 2)
                    continue;

                var x = diff[i];
                var t = (TerrainType)(i + 1);

                for (var j = 0; j < x;)
                {
                    var objType = GetRandomObjType(RegionMobs[t].Item2);

                    if (objType == 0)
                        continue;

                    j += Spawn(World.GameServer.Resources.GameData.ObjectDescs[objType], t, w, h);
                }
            }

            RecalculateEnemyCount();
        }

        private ushort GetRandomObjType(IEnumerable<Tuple<string, double>> dat)
        {
            var p = Random.Shared.NextDouble();

            double n = 0;
            ushort objType = 0;

            foreach (var k in dat)
            {
                n += k.Item2;

                if (n > p)
                {
                    objType = World.GameServer.Resources.GameData.IdToObjectType[k.Item1];
                    break;
                }
            }

            return objType;
        }

        private void HandleAnnouncements()
        {
            if (World.Closed)
                return;

            var taunt = CriticalEnemies[Random.Shared.Next(0, CriticalEnemies.Length)];
            var count = 0;

            foreach (var i in World.Enemies)
            {
                var desc = i.Value.ObjectDesc;

                if (desc == null || desc.IdName != taunt.Item1)
                    continue;

                count++;
            }

            if (count == 0)
                return;

            if (count == 1 && taunt.Item2.Final != null || taunt.Item2.Final != null && taunt.Item2.NumberOfEnemies == null)
            {
                var arr = taunt.Item2.Final;
                var msg = arr[Random.Shared.Next(0, arr.Length)];

                BroadcastMsg(msg);
            }
            else
            {
                var arr = taunt.Item2.NumberOfEnemies;

                if (arr == null)
                    return;

                var msg = arr[Random.Shared.Next(0, arr.Length)];
                msg = msg.Replace("{COUNT}", count.ToString());

                BroadcastMsg(msg);
            }
        }

        private void RecalculateEnemyCount()
        {
            for (var i = 0; i < EnemyCounts.Length; i++)
                EnemyCounts[i] = 0;

            foreach (var i in World.Enemies)
            {
                if (i.Value.Terrain == TerrainType.None)
                    continue;

                EnemyCounts[(int)i.Value.Terrain - 1]++;
            }
        }

        private int Spawn(ObjectDesc desc, TerrainType terrain, int w, int h)
        {
            Entity entity;

            var ret = 0;
            var pt = new IntPoint();

            if (desc.Spawn != null)
            {
                var num = (int)GetNormal(Random.Shared, desc.Spawn.Mean, desc.Spawn.StdDev);

                if (num > desc.Spawn.Max)
                    num = desc.Spawn.Max;
                else if (num < desc.Spawn.Min)
                    num = desc.Spawn.Min;

                do
                {
                    pt.X = Random.Shared.Next(0, w);
                    pt.Y = Random.Shared.Next(0, h);
                } while (World.Map[pt.X, pt.Y].Terrain != terrain || !World.IsPassable(pt.X, pt.Y) || World.AnyPlayerNearby(pt.X, pt.Y));

                for (var k = 0; k < num; k++)
                {
                    entity = Entity.Resolve(World.GameServer, desc.ObjectType);
                    entity.Move(pt.X + (float)(Random.Shared.NextDouble() * 2 - 1) * 5, pt.Y + (float)(Random.Shared.NextDouble() * 2 - 1) * 5);
                    (entity as Enemy).Terrain = terrain;
                    World.EnterWorld(entity);
                    ret++;
                }

                return ret;
            }

            do
            {
                pt.X = Random.Shared.Next(0, w);
                pt.Y = Random.Shared.Next(0, h);
            }
            while (World.Map[pt.X, pt.Y].Terrain != terrain || !World.IsPassable(pt.X, pt.Y) || World.AnyPlayerNearby(pt.X, pt.Y));

            entity = Entity.Resolve(World.GameServer, desc.ObjectType);
            entity.Move(pt.X, pt.Y);
            (entity as Enemy).Terrain = terrain;
            World.EnterWorld(entity);
            ret++;
            return ret;
        }

        private void MovePeopleNearby(TickTime time)
        {
            var regions = World.GetRegionPoints(TileRegion.Defender);
            foreach (var player in World.Players.Values)
            {
                var pos = Random.Shared.NextLength(regions);
                player.TeleportPosition(time, pos.Key.X, pos.Key.Y, true);
            }
        }

        private void SpawnEvent(string name, ISetPiece setpiece, int x = 0, int y = 0)
        {
            if (DisableSpawning)
                return;

            var pt = new IntPoint(x, y);
            while (World.Map[pt.X, pt.Y].Terrain < TerrainType.Mountains || World.Map[pt.X, pt.Y].Terrain > TerrainType.MidForest || !World.IsPassable(pt.X, pt.Y, true) || World.AnyPlayerNearby(pt.X, pt.Y))
            {
                pt.X = Random.Shared.Next(0, World.Map.Width);
                pt.Y = Random.Shared.Next(0, World.Map.Height);
            }

            var sp = setpiece ?? new NamedEntitySetPiece(name);

            pt.X -= (sp.Size - 1) / 2;
            pt.Y -= (sp.Size - 1) / 2;
            sp.RenderSetPiece(World, pt);

            var taunt = $"{name} has been spawned!";

            BroadcastMsg(taunt);
        }

        private struct TauntData
        {
            public string[] Final;
            public string[] Killed;
            public string NameOfDeath;
            public string[] NumberOfEnemies;
            public string[] Spawn;
        }
    }
}
