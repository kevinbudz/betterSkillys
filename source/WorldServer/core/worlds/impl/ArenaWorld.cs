using Pipelines.Sockets.Unofficial.Arenas;
using Shared;
using Shared.isc;
using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.objects.inventory;
using WorldServer.core.objects.vendors;
using WorldServer.core.structures;
using WorldServer.networking;

namespace WorldServer.core.worlds.impl
{
    public sealed class ArenaWorld : World
    {
        public enum ArenaState
        {
            NotStarted,
            CountDown,
            Start,
            Rest,
            Spawn,
            Fight
        }

        private enum CountDownState
        {
            NotifyMinute,
            NotifyThirty,
            StartGame,
            Done
        }

        private readonly string[] _randomEnemies =
{
            "Djinn", "Beholder", "White Demon of the Abyss", "Flying Brain", "Slime God",
            "Native Sprite God", "Ent God", "Medusa", "Ghost God", "Leviathan", "Chaos Guardians",
            "Mini Bot"
        };

        private int _bossLevel = 0;
        private readonly int[] _changeBossLevel = new int[] { 0, 5, 10, 15, 20, 30 };

        private readonly string[][] _randomBosses = new string[][]
        {
            ["Red Demon", "Phoenix Lord", "Henchman of Oryx", "Oryx Brute"],
            ["Red Demon", "Phoenix Lord", "Henchman of Oryx", "Stheno the Snake Queen"],
            ["Stheno the Snake Queen", "Archdemon Malphas", "Septavius the Ghost God","Lord of the Lost Lands", "Dr Terrible"],
            ["Archdemon Malphas", "Septavius the Ghost God", "Limon the Sprite God", "Thessal the Mermaid Goddess", "Crystal Prisoner", "Gigacorn"],
            ["Thessal the Mermaid Goddess", "Crystal Prisoner", "Tomb Support", "Tomb Defender", "Tomb Attacker", "Oryx the Mad God 2", "Grand Sphinx"],
            ["Thessal the Mermaid Goddess", "Crystal Prisoner", "Tomb Support", "Tomb Defender", "Tomb Attacker", "Oryx the Mad God 2"]
        };

        private readonly Dictionary<int, string[]> _waveRewards = new Dictionary<int, string[]>
        {
            { 5, new string[] {"Spider Den Key", "Pirate Cave Key", "Forest Maze Key"} },
            { 10, new string[] {"Snake Pit Key", "Sprite World Key", "Undead Lair Key", "Abyss of Demons Key", "Lab Key", "Beachzone Key"} },
            { 20, new string[] {"Bella's Key", "Tomb of the Ancients Key", "Shaitan's Key", "The Crawling Depths Key", "Candy Key"} },
            { 25, new string[] {"Loot Drop Potion" } },
            { 30, new string[] {"Jeebs' Arena Key", "Shatters Key", "Asylum Key"}},
            { 50, new string[] {"Backpack"} }
        };

        private CountDownState _countDown;
        public ArenaState CurrentState { get; private set; }
        public static ArenaWorld Instance { get; private set; }

        private List<IntPoint> _outerSpawn;
        private List<IntPoint> _centralSpawn;

        private int _wave;
        private long _restTime;
        private long _time;
        private int _startingPlayers;
        public int count = 0;

        public ArenaWorld(GameServer gameServer, int id, WorldResource resource)
            : base(gameServer, id, resource)
        {
            CurrentState = ArenaState.NotStarted;
            _wave = 1;
            Instance = this;
        }

        public override void Init()
        {
            base.Init();
            AddSpawns();
        }

        private void AddSpawns()
        {
            _outerSpawn = new List<IntPoint>();
            _centralSpawn = new List<IntPoint>();
            var w = Map.Width;
            var h = Map.Height;
            for (int x = 0; x < w; x++)
                for (int y = 0; y < h; y++)
                {
                    if (Map[x, y].Region == TileRegion.Arena_Central_Spawn)
                        _centralSpawn.Add(new IntPoint(x, y));

                    if (Map[x, y].Region == TileRegion.Arena_Edge_Spawn)
                        _outerSpawn.Add(new IntPoint(x, y));
                }
        }

        public override bool AllowedAccess(Client client)
        {
            return base.AllowedAccess(client) &&
                  _countDown != CountDownState.Done || client.Account.Admin;
        }

        protected override void UpdateLogic(ref TickTime time)
        {
            _time += time.ElapsedMsDelta;
            switch (CurrentState)
            {
                case ArenaState.NotStarted:
                    CurrentState = ArenaState.CountDown;
                    break;
                case ArenaState.CountDown:
                    Countdown(time);
                    break;
                case ArenaState.Start:
                    Start(time);
                    break;
                default:
                    CurrentState = ArenaState.Start;
                    break;
            }
        }

        private void Countdown(TickTime time)
        {
            switch (_countDown)
            {
                case CountDownState.NotifyMinute:
                    _countDown = CountDownState.NotifyThirty;
                    GameServer.ChatManager.Arena("A public arena game is starting in one minute. Type /arena to join.");
                    break;
                case CountDownState.NotifyThirty:
                    if (_time < 30000)
                        return;
                    _countDown = CountDownState.StartGame;
                    foreach (var plr in Players.Values)
                        plr.SendInfo("The arena will start in 30 seconds.");
                    break;
                case CountDownState.StartGame:
                    if (_time < 60000)
                        return;
                    _countDown = CountDownState.Done;
                    _time = 0;
                    _startingPlayers = Players.Count();
                    CurrentState = ArenaState.Start;
                    break;
                case CountDownState.Done:
                    break;
            }
        }

        private void Start(TickTime time)
        {
            CurrentState = ArenaState.Rest;
            Rest(time, true);
        }

        private void Fight(TickTime time)
        {
            if (Players.Count(p => !p.Value.Client.Account.Admin) <= 1)
            {
                var plr = Players.FirstOrDefault(p => !p.Value.Client.Account.Admin).Value;
                if (plr != null && _startingPlayers > 1)
                    GameServer.ChatManager.ServerAnnounce(
                        "Congrats to " + plr.Name + " for being the sole survivor of the public arena. (Wave: " + _wave + ", Starting Players: " + _startingPlayers + ")");
            }

            if (!Enemies.Any(e => e.Value.ObjectDesc.Enemy))
            {
                _wave++;
                _restTime = _time;
                CurrentState = ArenaState.Rest;

                if (_bossLevel + 1 < _changeBossLevel.Length &&
                    _changeBossLevel[_bossLevel + 1] <= _wave)
                    _bossLevel++;

                Rest(time, true);
            }
        }

        private void HandleWaveRewards()
        {
            if (!_waveRewards.ContainsKey(_wave))
                return;

            // initialize reward items
            var gameData = GameServer.Resources.GameData;
            var items = new List<Item>();
            foreach (var reward in _waveRewards[_wave])
            {
                ushort itemType;
                Item item = null;

                if (!gameData.IdToObjectType.TryGetValue(reward, out itemType))
                    continue;

                if (!gameData.Items.TryGetValue(itemType, out item))
                    continue;

                items.Add(item);
            }

            if (items.Count <= 0)
                return;

            var r = new Random();
            foreach (var player in Players.Values)
            {
                var item = items[r.Next(0, items.Count)];
                var changes = player.Inventory.CreateTransaction();
                var slot = changes.GetAvailableInventorySlot(item);
                if (slot != -1)
                {
                    changes[slot] = item;
                    Inventory.Execute(changes);
                }
                else
                {
                    player.SendError("You were unable to get an award from the Arena as your inventory was full.");
                }
            }
        }

        private void Rest(TickTime time, bool recover = false)
        {
            if (recover)
            {
                foreach (var plr in Players.Values)
                    plr.ApplyConditionEffect(ConditionEffectIndex.Healing, 5000);
                /*BroadcastPacket(new ImminentArenaWave()
                {
                    CurrentRuntime = (int)_time,
                    Wave = _wave
                }, null);*/
                HandleWaveRewards();
                return;
            }
            if (_time - _restTime < 5000)
                return;
            CurrentState = ArenaState.Spawn;
        }

        private void Spawn(TickTime time)
        {
            SpawnEnemies();
            SpawnBosses();
            CurrentState = ArenaState.Fight;
        }

        private void SpawnEnemies()
        {
            var enemies = new List<string>();
            var r = new Random();

            for (int i = 0; i < Math.Ceiling((double)(_wave + Players.Count) / 2); i++)
                enemies.Add(_randomEnemies[r.Next(0, _randomEnemies.Length)]);

            foreach (string i in enemies)
            {
                var id = GameServer.Resources.GameData.IdToObjectType[i];

                var pos = _outerSpawn[r.Next(0, _outerSpawn.Count)];
                var xloc = pos.X + 0.5f;
                var yloc = pos.Y + 0.5f;

                var enemy = Entity.Resolve(GameServer, id);
                enemy.Move(xloc, yloc);
                EnterWorld(enemy);
            }
        }

        private void SpawnBosses()
        {
            var bosses = new List<string>();
            var r = new Random();

            for (int i = 0; i < 1; i++)
                bosses.Add(_randomBosses[_bossLevel][r.Next(0, _randomBosses[_bossLevel].Length)]);

            foreach (string i in bosses)
            {
                ushort id = GameServer.Resources.GameData.IdToObjectType[i];

                var pos = _centralSpawn[r.Next(0, _centralSpawn.Count)];
                var xloc = pos.X + 0.5f;
                var yloc = pos.Y + 0.5f;

                var enemy = Entity.Resolve(GameServer, id);
                enemy.Move(xloc, yloc);
                EnterWorld(enemy);
            }
        }

        public override void LeaveWorld(Entity entity)
        {
            base.LeaveWorld(entity);
            if (!(entity is Player)) return;
            if (Players.Count == 0)
                CurrentState = ArenaState.NotStarted;
        }
    }
}
