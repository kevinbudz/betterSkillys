﻿using TKR.Shared;

namespace TKR.WorldServer.networking.packets.outgoing
{
    public enum BuyResultType
    {
        Success = 0,
        NotEnoughGold = 1,
        NotEnoughFame = 2
    }

    public class BuyResultMessage : OutgoingMessage
    {
        public const int Success = 0;
        public const int Dialog = 1;

        public int Result { get; set; }
        public string ResultString { get; set; }

        public override MessageId MessageId => MessageId.BUYRESULT;

        protected override void Write(NWriter wtr)
        {
            wtr.Write(Result);
            wtr.WriteUTF(ResultString);
        }
    }
}