using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    class TeleportPlayer : CycleBehavior
    {
        private readonly float range;
        private readonly float _X;
        private readonly float _Y;
        private readonly bool _isMapPosition;

        public TeleportPlayer(double range, float X, float Y, bool isMapPosition = false)
        {
            this.range = (float)range;
            _X = X;
            _Y = Y;
            _isMapPosition = isMapPosition;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            Status = CycleStatus.NotStarted;
            foreach (var i in host.GetNearestEntities(range, null, true))
            {
                var player = i as Player;
                player?.TeleportPosition(time, _isMapPosition ? _X : host.X + _X, _isMapPosition ? _Y : host.Y + _Y, true);
                state = CycleStatus.Completed;
            }
        }
    }
}
