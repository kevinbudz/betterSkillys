using System.Collections.Generic;
using Shared;
using WorldServer.core.net.datas;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class NewTickMessage : OutgoingMessage
    {
        private readonly int TickId;
        private readonly int TickTime;
        public List<ObjectStats> Statuses { get; set; }

        public override MessageId MessageId => MessageId.NEWTICK;

        public NewTickMessage(int tickId, int tickTime)
        {
            TickId = tickId;
            TickTime = tickTime;
            Statuses = new List<ObjectStats>();
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(TickId);
            wtr.Write(TickTime);
            wtr.Write((short)Statuses.Count);
            foreach (var status in Statuses)
                status.Write(wtr);
        }
    }
}
