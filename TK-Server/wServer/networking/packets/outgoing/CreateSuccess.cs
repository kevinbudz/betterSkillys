﻿using common;

namespace wServer.networking.packets.outgoing
{
    public class CreateSuccess : OutgoingMessage
    {
        public int ObjectId { get; set; }
        public int CharId { get; set; }

        public override PacketId MessageId => PacketId.CREATE_SUCCESS;

        protected override void Write(NWriter wtr)
        {
            wtr.Write(ObjectId);
            wtr.Write(CharId);
        }
    }
}
