using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.logic.behaviors
{
    internal class Flash : Behavior
    {
        private readonly uint color;
        private float flashPeriod;
        private int flashRepeats;

        public Flash(uint color, double flashPeriod, int flashRepeats)
        {
            this.color = color;
            this.flashPeriod = (float)flashPeriod;
            this.flashRepeats = flashRepeats;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => host.World.BroadcastIfVisible(new ShowEffect()
        { 
            EffectType = EffectType.Flashing, Pos1 = new Position() { X = flashPeriod, Y = flashRepeats }, TargetObjectId = host.Id, Color = new ARGB(color) }, host);

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
        }
    }
}
