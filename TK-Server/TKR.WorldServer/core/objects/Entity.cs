using System;
using System.Collections.Generic;
using System.Linq;
using TKR.Shared;
using TKR.Shared.resources;
using TKR.WorldServer.core.net.datas;
using TKR.WorldServer.core.net.stats;
using TKR.WorldServer.core.objects.connection;
using TKR.WorldServer.core.objects.containers;
using TKR.WorldServer.core.objects.vendors;
using TKR.WorldServer.core.structures;
using TKR.WorldServer.core.worlds;
using TKR.WorldServer.core.worlds.census;
using TKR.WorldServer.logic;
using TKR.WorldServer.logic.transitions;
using TKR.WorldServer.utils;

namespace TKR.WorldServer.core.objects
{
    public class Entity : ICollidable<Entity>
    {
        private const float COL_SKIP_BOUNDARY = 0.4f;

        public bool GivesNoXp;
        public float? savedAngle;
        public bool Spawned;
        public bool SpawnedByBehavior;

        private StatTypeValue<int> _altTextureIndex;
        private StatTypeValue<string> _name;
        private StatTypeValue<int> _size;
        private bool _stateEntry;
        private State _stateEntryCommonRoot;
        private Dictionary<object, object> _states;
        private StatTypeValue<float> _x;
        private StatTypeValue<float> _y;
        private ConditionEffectManager ConditionEffectManager;
        public bool Dead { get; private set; }

        protected Entity(GameServer coreServerManager, ushort objType)
        {
            GameServer = coreServerManager;

            ObjectType = objType;

            coreServerManager.BehaviorDb.ResolveBehavior(this);
            coreServerManager.Resources.GameData.ObjectDescs.TryGetValue(ObjectType, out var desc);
            ObjectDesc = desc;

            ConditionEffectManager = new ConditionEffectManager(this);

            if (ObjectDesc == null)
                throw new Exception($"ObjectDesc is NUll: {ObjectType.To4Hex()}");

            if (ObjectDesc.Invincible)
                ApplyPermanentConditionEffect(ConditionEffectIndex.Invincible);
            if (ObjectDesc.ArmorBreakImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.ArmorBreakImmune);
            if (ObjectDesc.CurseImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.CurseImmune);
            if (ObjectDesc.DazedImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.DazedImmune);
            if (ObjectDesc.ParalyzeImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.ParalyzeImmune);
            if (ObjectDesc.PetrifyImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.PetrifyImmune);
            if (ObjectDesc.SlowedImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.SlowedImmune);
            if (ObjectDesc.StasisImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.StasisImmune);
            if (ObjectDesc.StunImmune)
                ApplyPermanentConditionEffect(ConditionEffectIndex.StunImmune);

            _name = new StatTypeValue<string>(this, StatDataType.Name, ObjectDesc.DisplayName);
            _size = new StatTypeValue<int>(this, StatDataType.Size, ObjectDesc.Size);
            _altTextureIndex = new StatTypeValue<int>(this, StatDataType.AltTextureIndex, -1);
            _x = new StatTypeValue<float>(this, StatDataType.None, 0);
            _y = new StatTypeValue<float>(this, StatDataType.None, 0);
        }

        public event EventHandler<StatChangedEventArgs> StatChanged;

        public int AltTextureIndex { get => _altTextureIndex.GetValue(); set => _altTextureIndex?.SetValue(value); }
        public Player AttackTarget { get; set; }
        public CollisionNode<Entity> CollisionNode { get; set; }

        public GameServer GameServer { get; private set; }
        public State CurrentState { get; private set; }
        public int Id { get; internal set; } = -1;
        public string Name { get => _name.GetValue(); set => _name?.SetValue(value); }
        public ObjectDesc ObjectDesc { get; private set; }
        public ushort ObjectType { get; protected set; }
        public World World { get; private set; }
        public CollisionMap<Entity> Parent { get; set; }
        public int Size { get => _size.GetValue(); set => _size?.SetValue(value); }

        public int NextBulletId = 1;
        public int NextAbilityBulletId = 0x40000000;

        public int GetNextBulletId(int numShots = 1, bool ability = false)
        {
            if (ability)
            {
                var currentAbilityId = NextAbilityBulletId;
                NextAbilityBulletId += numShots;
                return currentAbilityId;
            }

            var currentBulletId = NextBulletId;
            NextBulletId += numShots;
            return currentBulletId;
        }

        public IDictionary<object, object> StateStorage
        {
            get
            {
                if (_states == null)
                    _states = new Dictionary<object, object>();
                return _states;
            }
        }

        public float X { get => _x.GetValue(); set => _x.SetValue(value); }
        public float Y { get => _y.GetValue(); set => _y.SetValue(value); }
        public float PrevX { get; private set; }
        public float PrevY { get; private set; }

        public bool MoveToward(ref Position pos, float speed) => MoveToward(pos.X, pos.Y, speed);
        public bool MoveToward(float x, float y, float speed)
        {
            var facing = AngleTo(x, y);
            var spd = ClampSpeed(GetSpeedMultiplier(speed), 0.0f, (float)DistTo(x, y));
            var newPos = PointAt(facing, spd);
            if (X != newPos.X || Y != newPos.Y)
            {
                ValidateAndMove(newPos.X, newPos.Y);
                return true;
            }
            return false;
        }

        public static Entity Resolve(GameServer gameServer, string name)
        {
            if (!gameServer.Resources.GameData.IdToObjectType.TryGetValue(name, out ushort id))
                return null;
            return Resolve(gameServer, id);
        }

        public static Entity Resolve(GameServer gameServer, ushort objectType)
        {
            var desc = gameServer.Resources.GameData.ObjectDescs[objectType];
            int? hp = desc.MaxHP == 0 ? null : desc.MaxHP;
            var type = desc.Class;

            if (desc.Connects)
                return new ConnectedObject(gameServer, objectType);
            if (desc.Container)
                return new Container(gameServer, objectType);
            if (desc.Enemy)
                return new Enemy(gameServer, objectType);
            
            switch (type)
            {
                case "GameObject":
                case "CharacterChanger":
                case "MoneyChanger":
                case "NameChanger":
                    return new StaticObject(gameServer, objectType, hp, true, false, true);
                case "Character":   //Other characters means enemy
                    return new Enemy(gameServer, objectType);
                case "GuildHallPortal":
                case "ArenaPortal":
                case "Portal":
                    return new Portal(gameServer, objectType);
                case "ClosedVaultChest":
                    return new ClosedVaultChest(gameServer, objectType);
                case "Merchant":
                    return new NexusMerchant(gameServer, objectType);
                case "GuildMerchant":
                    return new GuildMerchant(gameServer, objectType);
                case "ClosedVaultChestGold":
                case "VaultChest":
                case "MarketNPC":
                case "SkillTree":
                case "Forge":
                case "StatNPC":
                    return new SellableMerchant(gameServer, objectType);
            }
            return new StaticObject(gameServer, objectType, null, true, false, false);
        }

        public void ApplyPermanentConditionEffect(ConditionEffectIndex effect)
        {
            if (!CanApplyCondition(effect))
                return;
            ConditionEffectManager.AddPermanentCondition((byte)effect);
        }

        public void ApplyConditionEffect(ConditionEffectIndex effect, int durationMs)
        {
            if (!CanApplyCondition(effect))
                return;
            ConditionEffectManager.AddCondition((byte)effect, durationMs);
        }

        public void ApplyConditionEffect(params ConditionEffect[] effs)
        {
            foreach (var i in effs)
            {
                if (!CanApplyCondition(i.Effect))
                    continue;
                ConditionEffectManager.AddCondition((byte)i.Effect, i.DurationMS);
            }
        }

        public bool HasConditionEffect(ConditionEffectIndex effect) => ConditionEffectManager.HasCondition((byte)effect);
        public void RemoveCondition(ConditionEffectIndex effect) => ConditionEffectManager.RemoveCondition((byte)effect);

        protected virtual bool CanApplyCondition(ConditionEffectIndex effect)
        {
            if (effect == ConditionEffectIndex.Stunned && HasConditionEffect(ConditionEffectIndex.StunImmune))
                return false;
            if (effect == ConditionEffectIndex.Stasis && HasConditionEffect(ConditionEffectIndex.StasisImmune))
                return false;
            if (effect == ConditionEffectIndex.Paralyzed && HasConditionEffect(ConditionEffectIndex.ParalyzeImmune))
                return false;
            if (effect == ConditionEffectIndex.ArmorBroken && HasConditionEffect(ConditionEffectIndex.ArmorBreakImmune))
                return false;
            if (effect == ConditionEffectIndex.Unstable && HasConditionEffect(ConditionEffectIndex.UnstableImmune))
                return false;
            if (effect == ConditionEffectIndex.Curse && HasConditionEffect(ConditionEffectIndex.CurseImmune))
                return false;
            if (effect == ConditionEffectIndex.Petrify && HasConditionEffect(ConditionEffectIndex.PetrifyImmune))
                return false;
            if (effect == ConditionEffectIndex.Dazed && HasConditionEffect(ConditionEffectIndex.DazedImmune))
                return false;
            if (effect == ConditionEffectIndex.Slowed && HasConditionEffect(ConditionEffectIndex.SlowedImmune))
                return false;
            return true;
        }

        public virtual bool CanBeSeenBy(Player player) => true;

        public ObjectStats ExportStats(bool isOtherPlayer)
        {
            var stats = new Dictionary<StatDataType, object>();
            ExportStats(stats, isOtherPlayer);
            return new ObjectStats()
            {
                Id = Id,
                X = X,
                Y = Y,
                Stats = stats.ToArray()
            };
        }

        public virtual void Init(World owner) => World = owner;

        public void InvokeStatChange(StatDataType t, object val, bool updateSelfOnly = false) => StatChanged?.Invoke(this, new StatChangedEventArgs(t, val, updateSelfOnly));

        public void Move(float x, float y)
        {
            if (World != null && !(this is Pet) && (!(this is StaticObject) || (this as StaticObject).Hittestable))
                (this is Enemy || this is StaticObject && !(this is Decoy) ? World.EnemiesCollision : World.PlayersCollision).Move(this, x, y);

            var prevX = X;
            var prevY = Y;
            X = x;
            Y = y;
            PrevX = prevX;
            PrevY = prevY;
        }

        public void OnChatTextReceived(Player player, string text)
        {
            var state = CurrentState;

            while (state != null)
            {
                foreach (var t in state.Transitions.OfType<PlayerTextTransition>())
                    t.OnChatReceived(player, text);

                state = state.Parent;
            }
        }

        public void SetDefaultSize(int size) => Size = size;

        public void SwitchTo(State state)
        {
            var origState = CurrentState;

            CurrentState = state;
            if (CurrentState != null)
                while (CurrentState.States.Count > 0)
                    CurrentState = CurrentState.States[0];

            _stateEntryCommonRoot = State.CommonParent(origState, CurrentState);
            _stateEntry = true;
        }

        public virtual void Tick(ref TickTime time)
        {
            ConditionEffectManager.Update(ref time);

            if (HasConditionEffect(ConditionEffectIndex.Stasis))
                return;
            TickState(time);
        }

        public void TickState(TickTime time)
        {
            if (CurrentState == null)
                return;

            if (_stateEntry)
            {
                //State entry
                var s = CurrentState;

                while (s != null && s != _stateEntryCommonRoot)
                {
                    foreach (var i in s.Behaviors)
                        i.OnStateEntry(this, time);

                    s = s.Parent;
                }

                _stateEntryCommonRoot = null;
                _stateEntry = false;
            }

            var origState = CurrentState;
            var state = CurrentState;
            var transited = false;

            while (state != null)
            {
                if (!transited)
                    foreach (var i in state.Transitions)
                        if (i.Tick(this, time))
                        {
                            transited = true;
                            break;
                        }

                try
                {
                    foreach (var i in state.Behaviors)
                        i.Tick(this, time);
                }
                catch (Exception e)
                {
                    StaticLogger.Instance.Error(e);
                }
                state = state.Parent;
            }

            if (transited)
            {
                //State exit
                var s = origState;

                while (s != null && s != _stateEntryCommonRoot)
                {
                    foreach (var i in s.Behaviors)
                        i.OnStateExit(this, time);

                    s = s.Parent;
                }
            }
        }

        public bool TileFullOccupied(float x, float y)
        {
            var xx = (int)x;
            var yy = (int)y;

            if (!World.Map.Contains(xx, yy))
                return true;

            var tile = World.Map[xx, yy];

            if (tile.ObjType != 0)
            {
                var objDesc = GameServer.Resources.GameData.ObjectDescs[tile.ObjType];

                if (objDesc?.FullOccupy == true)
                    return true;
            }

            return false;
        }

        public bool TileOccupied(float x, float y)
        {
            if (this == null || World == null)
                return false;

            var x_ = (int)x;
            var y_ = (int)y;

            var map = World.Map;

            if (map == null)
                return false;

            if (!map.Contains(x_, y_))
                return true;

            var tile = map[x_, y_];

            if (tile == null)
                return false;

            var tiles = GameServer.Resources.GameData.Tiles;

            if (!tiles.ContainsKey(tile.TileId))
            {
                StaticLogger.Instance.Error($"There is no tile for tile ID '{tile.TileId}'.");
                return false;
            }

            var tileDesc = tiles[tile.TileId];

            if (tileDesc != null && tileDesc.NoWalk)
                return true;

            if (tile.ObjType != 0)
            {
                var objDescs = GameServer.Resources.GameData.ObjectDescs;

                if (!objDescs.ContainsKey(tile.ObjType))
                {
                    StaticLogger.Instance.Error($"There is no object description for tile object type '{tile.ObjType}'.");
                    return false;
                }

                var objDesc = objDescs[tile.ObjType];
                return objDesc != null && objDesc.EnemyOccupySquare;
            }

            return false;
        }

        public ObjectDef ToDefinition(bool isOtherPlayer = false) => new ObjectDef()
        {
            ObjectType = ObjectType,
            Stats = ExportStats(isOtherPlayer)
        };

        public void ValidateAndMove(float x, float y)
        {
            var pos = new FPoint();
            ResolveNewLocation(x, y, pos);
            Move(pos.X, pos.Y);
        }

        protected virtual void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.Name] = Name;
            stats[StatDataType.Size] = Size;
            stats[StatDataType.AltTextureIndex] = AltTextureIndex;
            ConditionEffectManager.ExportStats(stats);
        }

        private void CalcNewLocation(float x, float y, FPoint pos)
        {
            var fx = 0f;
            var fy = 0f;
            var isFarX = X % .5f == 0 && x != X || (int)(X / .5f) != (int)(x / .5f);
            var isFarY = Y % .5f == 0 && y != Y || (int)(Y / .5f) != (int)(y / .5f);

            if (!isFarX && !isFarY || RegionUnblocked(x, y))
            {
                pos.X = x;
                pos.Y = y;
                return;
            }

            if (isFarX)
            {
                fx = x > X ? (int)(x * 2) / 2f : (int)(X * 2) / 2f;

                if ((int)fx > (int)X)
                    fx = fx - 0.01f;
            }

            if (isFarY)
            {
                fy = y > Y ? (int)(y * 2) / 2f : (int)(Y * 2) / 2f;

                if ((int)fy > (int)Y)
                    fy = fy - 0.01f;
            }

            if (!isFarX)
            {
                pos.X = x;
                pos.Y = fy;
                return;
            }

            if (!isFarY)
            {
                pos.X = fx;
                pos.Y = y;
                return;
            }

            var ax = x > X ? x - fx : fx - x;
            var ay = y > Y ? y - fy : fy - y;

            if (ax > ay)
            {
                if (RegionUnblocked(x, fy))
                {
                    pos.X = x;
                    pos.Y = fy;
                    return;
                }

                if (RegionUnblocked(fx, y))
                {
                    pos.X = fx;
                    pos.Y = y;
                    return;
                }
            }
            else
            {
                if (RegionUnblocked(fx, y))
                {
                    pos.X = fx;
                    pos.Y = y;
                    return;
                }

                if (RegionUnblocked(x, fy))
                {
                    pos.X = x;
                    pos.Y = fy;
                    return;
                }
            }

            pos.X = fx;
            pos.Y = fy;
        }

        private bool RegionUnblocked(float x, float y)
        {
            if (TileOccupied(x, y))
                return false;

            var xFrac = x - (int)x;
            var yFrac = y - (int)y;

            if (xFrac < 0.5)
            {
                if (TileFullOccupied(x - 1, y))
                    return false;

                if (yFrac < 0.5)
                {
                    if (TileFullOccupied(x, y - 1) || TileFullOccupied(x - 1, y - 1))
                        return false;
                }
                else
                {
                    if (yFrac > 0.5)
                        if (TileFullOccupied(x, y + 1) || TileFullOccupied(x - 1, y + 1))
                            return false;
                }

                return true;
            }

            if (xFrac > 0.5)
            {
                if (TileFullOccupied(x + 1, y))
                    return false;

                if (yFrac < 0.5)
                {
                    if (TileFullOccupied(x, y - 1) || TileFullOccupied(x + 1, y - 1))
                        return false;
                }
                else
                {
                    if (yFrac > 0.5)
                        if (TileFullOccupied(x, y + 1) || TileFullOccupied(x + 1, y + 1))
                            return false;
                }

                return true;
            }

            if (yFrac < 0.5)
            {
                if (TileFullOccupied(x, y - 1))
                    return false;

                return true;
            }

            if (yFrac > 0.5)
                if (TileFullOccupied(x, y + 1))
                    return false;

            return true;
        }

        private void ResolveNewLocation(float x, float y, FPoint pos)
        {
            if (HasConditionEffect(ConditionEffectIndex.Paralyzed))
            {
                pos.X = X;
                pos.Y = Y;
                return;
            }

            var dx = x - X;
            var dy = y - Y;

            if (dx < COL_SKIP_BOUNDARY && dx > -COL_SKIP_BOUNDARY && dy < COL_SKIP_BOUNDARY && dy > -COL_SKIP_BOUNDARY)
            {
                CalcNewLocation(x, y, pos);
                return;
            }

            var ds = COL_SKIP_BOUNDARY / Math.Max(Math.Abs(dx), Math.Abs(dy));
            var tds = 0f;

            pos.X = X;
            pos.Y = Y;

            var done = false;

            while (!done)
            {
                if (tds + ds >= 1)
                {
                    ds = 1 - tds;
                    done = true;
                }

                CalcNewLocation(pos.X + dx * ds, pos.Y + dy * ds, pos);
                tds += ds;
            }
        }

        public void Expunge() => Dead = true;

        private class FPoint
        {
            public float X;
            public float Y;
        }

        public float AngleTo(Entity host) => MathF.Atan2(host.Y - Y, host.X - X);
        public float AngleTo(ref Position position) => MathF.Atan2(position.Y - Y, position.X - X);
        public float AngleTo(float x, float y) => MathF.Atan2(y - Y, x - X);

        public float SqDistTo(Entity host) => (host.X - X) * (host.X - X) + (host.Y - Y) * (host.Y - Y);
        public float SqDistTo(ref Position position) => (position.X - X) * (position.X - X) + (position.Y - Y) * (position.Y - Y);
        public float SqDistTo(float x, float y) => (x - X) * (x - X) + (y - Y) * (y - Y);

        public float DistTo(Entity host) => MathF.Sqrt((host.X - X) * (host.X - X) + (host.Y - Y) * (host.Y - Y));
        public float DistTo(ref Position position) => MathF.Sqrt((position.X - X) * (position.X - X) + (position.Y - Y) * (position.Y - Y));
        public float DistTo(float x, float y) => MathF.Sqrt((x - X) * (x - X) + (y - Y) * (y - Y));

        public Position PointAt(float angle, float radius) => new Position(X + MathF.Cos(angle) * radius, Y + MathF.Sin(angle) * radius);

        protected static float ClampSpeed(float value, float min, float max) => value < min ? min : value > max ? max : value;
        protected float GetSpeedMultiplier(float spd) => HasConditionEffect(ConditionEffectIndex.Slowed) ? spd * 0.5f : HasConditionEffect(ConditionEffectIndex.Speedy) ? spd * 1.5f : spd;
    }
}
