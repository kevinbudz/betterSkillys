using System;
using System.Collections.Generic;
using System.Linq;
using Shared.resources;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private bool anticheat;
        private long l;

        private const float MoveSpeedThreshold = 1.1f;

        public float MoveMultiplier = 1f;
        public int MoveTime;
        public int AwaitingMoves;
        public Queue<int> AwaitingGoto;
        public float PushX;
        public float PushY;

        /*public bool ValidMove(int time, Position pos)
        {
            int diff = time - MoveTime;
            float speed = Stats.GetSpeed() * diff * MoveSpeedThreshold;
            Position pushedServer = new Position(X - (diff * PushX), Y - (diff * PushY));
            if (pos.Distance(pos, pushedServer) > speed && pos.Dist(new Position() { X = RealX, Y = RealY }) > speed)
            {
                return false;
            }
            return true;
        }*/

        private void HandleOxygen(TickTime time)
        {
            if (time.TotalElapsedMs - l <= 100 || World?.DisplayName != "Ocean Trench") 
                return;
            if (!(World?.StaticObjects.Where(i => i.Value.ObjectType == 0x0731).Count(i => (X - i.Value.X) * (X - i.Value.X) + (Y - i.Value.Y) * (Y - i.Value.Y) < 1) > 0))
            {
                if (OxygenBar == 0)
                    Health -= 10;
                else
                    OxygenBar -= 8;
                if (Health <= 0)
                    Death("suffocation");
            }
            else
            {
                if (OxygenBar < 100)
                    OxygenBar += 8;
                if (OxygenBar > 100)
                    OxygenBar = 100;
            }
            l = time.TotalElapsedMs;
        }

        public void ForceGroundHit(TickTime time, Position pos, int timeHit)
        {
            if (World == null || World.Map == null || HasConditionEffect(ConditionEffectIndex.Paused) || HasConditionEffect(ConditionEffectIndex.Invincible))
                return;

            var tile = World.Map[(int)pos.X, (int)pos.Y];
            var objDesc = tile.ObjType == 0 ? null : GameServer.Resources.GameData.ObjectDescs[tile.ObjType];
            var tileDesc = GameServer.Resources.GameData.Tiles[tile.TileId];

            if (tileDesc.Damaging && (objDesc == null || !objDesc.ProtectFromGroundDamage))
            {
                int dmg = (int)Client.Random.NextIntRange((uint)tileDesc.MinDamage, (uint)tileDesc.MaxDamage);

                Health -= dmg;

                if (Health <= 0)
                {
                    Death(tileDesc.ObjectId, tile.Spawned);
                    return;
                }

                World.BroadcastIfVisibleExclude(new DamageMessage()
                {
                    TargetId = Id,
                    DamageAmount = dmg,
                    Kill = Health <= 0,
                }, this, this);
                anticheat = true;
            }
        }

        public void GroundEffect(TickTime time)
        {
            if (World == null || World.Map == null || HasConditionEffect(ConditionEffectIndex.Paused) || HasConditionEffect(ConditionEffectIndex.Invincible) || HasConditionEffect(ConditionEffectIndex.Stasis))
                return;

            var tile = World.Map[(int)X, (int)Y];
            if (tile == null) {
                return;
            }

            var objDesc = tile.ObjType == 0 ? null : GameServer.Resources.GameData.ObjectDescs[tile.ObjType];
            var tileDesc = GameServer.Resources.GameData.Tiles[tile.TileId];

            //if (tileDesc.Effects != null)
            //    ApplyConditionEffect(tileDesc.Effects);

            if (time.TotalElapsedMs - l > 500 && !anticheat)
            {
                if (HasConditionEffect(ConditionEffectIndex.Paused) ||
                    HasConditionEffect(ConditionEffectIndex.Invincible))
                    return;

                if (tileDesc.Damaging && (objDesc == null || !objDesc.ProtectFromGroundDamage))
                {
                    int dmg = (int)Client.Random.NextIntRange((uint)tileDesc.MinDamage, (uint)tileDesc.MaxDamage);

                    Health -= dmg;

                    if (Health <= 0)
                    {
                        Death(tileDesc.ObjectId, tile.Spawned);
                        return;
                    }

                    World.BroadcastIfVisibleExclude(new DamageMessage()
                    {
                        TargetId = Id,
                        DamageAmount = dmg,
                        Kill = Health <= 0,
                    }, this, this);

                    l = time.TotalElapsedMs;
                }
            }
        }
    }
}
