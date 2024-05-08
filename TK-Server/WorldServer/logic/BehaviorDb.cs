using Shared.resources;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using WorldServer.core;
using WorldServer.core.objects;
using WorldServer.logic;
using WorldServer.logic.loot;

namespace WorldServer.logic
{
    public partial class BehaviorDb
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private static float _rightAngle = 0;
        private static float _leftAngle = 180;
        private static float _upAngle = -90;
        private static float _downAngle = 90;
        public GameServer GameServer { get; private set; }

        private static int _initializing;
        internal static BehaviorDb InitDb;
        internal static XmlData InitGameData => InitDb.GameServer.Resources.GameData;

        public BehaviorDb(GameServer manager)
        {
            GameServer = manager;
            Log.Info("Behavior Database initialized...");
        }

        public void Initialize()
        {
            if (Interlocked.Exchange(ref _initializing, 1) == 1)
            {
                Log.Error("Attempted to initialize multiple BehaviorDb at the same time.");
                throw new InvalidOperationException("Attempted to initialize multiple BehaviorDb at the same time.");
            }
            InitDb = this;

            var fields = GetType().GetFields(BindingFlags.NonPublic | BindingFlags.Instance).Where(field => field.FieldType == typeof(_)).ToArray();
            for (int i = 0; i < fields.Length; i++)
            {
                var field = fields[i];
                ((_)field.GetValue(this))();
                field.SetValue(this, null);
            }

            InitDb = null;
            _initializing = 0;
        }

        public void ResolveBehavior(Entity entity)
        {
            if (Definitions.TryGetValue(entity.ObjectType, out Tuple<State, Loot> def))
                entity.SwitchTo(def.Item1);
        }

        private delegate ctor _();

        private struct ctor
        {
            public ctor Init(string id, State rootState, params MobDrops[] defs)
            {
                try
                {
                    var d = new Dictionary<string, State>();
                    rootState.Resolve(d);
                    rootState.ResolveChildren(d);
                    var dat = InitDb.GameServer.Resources.GameData;

                    if (!dat.IdToObjectType.ContainsKey(id))
                    {
                        Log.Error($"Failed to add behavior: {id}. Xml data not found.");
                        return this;
                    }

                    if (defs.Length > 0)
                    {
                        var loot = new Loot(defs);
                        InitDb.Definitions.Add(dat.IdToObjectType[id], new Tuple<State, Loot>(rootState, loot));
                    }
                    else
                        InitDb.Definitions.Add(dat.IdToObjectType[id], new Tuple<State, Loot>(rootState, null));

                }
                catch (Exception e)
                {
                    Console.WriteLine($"[Behavior] {id} Error -> {e}");
                }
                return this;
            }

            public ctor InitMany(string objTypeMin, string objTypeMax, Func<string, State> rootState, params MobDrops[] defs)
            {
                XmlData dat = InitDb.GameServer.Resources.GameData;
                ushort idMin = dat.IdToObjectType[objTypeMin];
                ushort idMax = dat.IdToObjectType[objTypeMax];
                int count = idMax - idMin;
                for (int i = 0; i <= count; i++)
                    if (!InitDb.Definitions.ContainsKey((ushort)(idMin + i)))
                        Init(dat.ObjectTypeToId[(ushort)(idMin + i)],
                            rootState(dat.ObjectTypeToId[(ushort)(idMin + i)]), defs);
                return this;
            }
        }

        private static ctor Behav()
        {
            return new ctor();
        }

        public Dictionary<ushort, Tuple<State, Loot>> Definitions { get; private set; } = new Dictionary<ushort, Tuple<State, Loot>>();
    }
}
