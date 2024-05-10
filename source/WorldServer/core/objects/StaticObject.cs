using System.Collections.Generic;
using System.Linq;
using WorldServer.core.net.stats;
using WorldServer.core.worlds;

namespace WorldServer.core.objects
{
    public class StaticObject : Entity
    {
        private readonly StatTypeValue<int> _hp;
        public int Health
        {
            get => _hp.GetValue(); 
            set => _hp.SetValue(value);
        }

        public bool Dying { get; private set; }
        public bool Hittestable { get; private set; }
        public bool Vulnerable { get; private set; }

        public StaticObject(GameServer manager, ushort objType, int? life, bool isStatic, bool dying, bool hittestable) : base(manager, objType)
        {
            _hp = new StatTypeValue<int>(this, StatDataType.Health, 0, dying);

            if (Vulnerable = life.HasValue)
                Health = life.Value;

            Dying = dying;
            Hittestable = hittestable;
        }

        public override void Tick(ref TickTime time)
        {
            if (Vulnerable)
            {
                if (Dying)
                    Health -= time.ElapsedMsDelta;
                _ = CheckHP();
            }
            base.Tick(ref time);
        }

        public bool CheckHP()
        {
            if (Health <= 0)
            {
                var x = (int)(X - 0.5);
                var y = (int)(Y - 0.5);

                if (World.Map.Contains(x, y))
                    if (ObjectDesc != null && World.Map[x, y].ObjType == ObjectType)
                    {
                        var tile = World.Map[x, y];
                        tile.ObjType = 0;
                        tile.UpdateCount++;

                        foreach (var player in World.PlayersCollision.HitTest(x, y, Player.VISIBILITY_RADIUS).Cast<Player>())
                            player.UpdateTiles();
                    }
                World.LeaveWorld(this);
                return false;
            }
            return true;
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.Health] = !Vulnerable ? int.MaxValue : Health;
            base.ExportStats(stats, isOtherPlayer);
        }
    }
}
