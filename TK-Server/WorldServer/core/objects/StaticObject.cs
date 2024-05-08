using System.Collections.Generic;
using WorldServer.core.net.stats;
using WorldServer.core.objects.player;
using WorldServer.core.worlds;

namespace WorldServer.core.objects
{
    public class StaticObject : Entity
    {
        private StatTypeValue<int> _hp;

        public StaticObject(GameServer manager, ushort objType, int? life, bool isStatic, bool dying, bool hittestable) : base(manager, objType)
        {
            _hp = new StatTypeValue<int>(this, StatDataType.Health, 0, dying);

            if (Vulnerable = life.HasValue)
                HP = life.Value;

            Dying = dying;
            Hittestable = hittestable;
        }

        public bool Dying { get; private set; }
        public bool Hittestable { get; private set; }
        public int HP { get => _hp.GetValue(); set => _hp.SetValue(value); }
        public bool Vulnerable { get; private set; }

        public override void Tick(ref TickTime time)
        {
            if (Vulnerable)
            {
                if (Dying)
                    HP -= time.ElapsedMsDelta;
                _ = CheckHP();
            }
            base.Tick(ref time);
        }

        public bool CheckHP()
        {
            if (HP <= 0)
            {
                var x = (int)(X - 0.5);
                var y = (int)(Y - 0.5);

                if (World.Map.Contains(x, y))
                    if (ObjectDesc != null && World.Map[x, y].ObjType == ObjectType)
                    {
                        var tile = World.Map[x, y];
                        tile.ObjType = 0;
                        tile.UpdateCount++;

                        foreach (var player in World.PlayersCollision.HitTest(x, y, PlayerUpdate.VISIBILITY_RADIUS))
                            if (player is Player && (player as Player).PlayerUpdate != null)
                                (player as Player).PlayerUpdate.UpdateTiles();
                    }
                World.LeaveWorld(this);
                return false;
            }
            return true;
        }

        protected override void ExportStats(IDictionary<StatDataType, object> stats, bool isOtherPlayer)
        {
            stats[StatDataType.Health] = !Vulnerable ? int.MaxValue : HP;
            base.ExportStats(stats, isOtherPlayer);
        }
    }
}
