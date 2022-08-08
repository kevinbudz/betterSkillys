﻿using common;

namespace wServer.networking.packets.outgoing
{
    public class TradeRequested : OutgoingMessage
    {
        public string Name { get; set; }

        public override PacketId MessageId => PacketId.TRADEREQUESTED;

        protected override void Write(NWriter wtr)
        {
            wtr.WriteUTF(Name);
        }
    }
}
