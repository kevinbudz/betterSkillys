using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.structures;
using WorldServer.core.worlds.impl;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    partial class Player
    {
        private int _canTpCooldownTime;

        public bool CanTeleport() => _canTpCooldownTime <= 0;

        public void Teleport(TickTime time, int objId, bool ignoreRestrictions = false)
        {
            if (IsInMarket && (World is NexusWorld))
            {
                SendError("You cannot teleport while inside the market.");
                return;
            }

            var obj = World.GetEntity(objId);
            if (obj == null)
            {
                SendError("Target does not exist.");
                return;
            }

            if (!ignoreRestrictions)
            {
                if (Id == objId)
                {
                    SendInfo("You are already at yourself, and always will be!");
                    return;
                }

                if (!World.AllowTeleport && !IsAdmin)
                {
                    SendError("Cannot teleport here.");
                    return;
                }

                if (HasConditionEffect(ConditionEffectIndex.Paused))
                {
                    SendError("Cannot teleport while paused.");
                    return;
                }

                if (obj is not Player)
                {
                    SendError("Can only teleport to players.");
                    return;
                }

                if (obj.HasConditionEffect(ConditionEffectIndex.Invisible))
                {
                    SendError("Cannot teleport to an invisible player.");
                    return;
                }

                if (obj.HasConditionEffect(ConditionEffectIndex.Paused))
                {
                    SendError("Cannot teleport to a paused player.");
                    return;
                }

                if (obj is Player p && p.IsHidden)
                {
                    SendError("Target does not exist.");
                    return;
                }

                if (!CanTeleport())
                {
                    SendError("Too soon to teleport again!");
                    return;
                }
            }

            ApplyConditionEffect(ConditionEffectIndex.Invulnerable, 2500);
            ApplyConditionEffect(ConditionEffectIndex.Stunned, 2500);
            TeleportPosition(time, obj.X, obj.Y, ignoreRestrictions);
        }

        public void TeleportPosition(TickTime time, float x, float y, bool ignoreRestrictions = false) => TeleportPosition(time, new Position(x, y), ignoreRestrictions);
        public void TeleportPosition(TickTime time, Position position, bool ignoreRestrictions = false)
        {
            if (!ignoreRestrictions)
            {
                if (!CanTeleport())
                {
                    SendError("Too soon to teleport again!");
                    return;
                }

                _canTpCooldownTime = 10000;
                ResetNewbiePeriod();
                FameCounter.Teleport();
            }

            var tpPkts = new OutgoingMessage[]
            {
                new GotoMessage(Id, position),
                new ShowEffect()
                {
                    EffectType = EffectType.Teleport,
                    TargetObjectId = Id,
                    Pos1 = position,
                    Color = new ARGB(0xFFFFFFFF)
                }
            };

            World.ForeachPlayer(_ =>
            {
                _.AwaitGotoAck(time.TotalElapsedMs);
                _.Client.SendPackets(tpPkts);
            });

            UpdateTiles();
        }

    }
}