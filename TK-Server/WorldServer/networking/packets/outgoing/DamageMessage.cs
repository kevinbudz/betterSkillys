using System.Collections.Generic;
using Shared;
using Shared.resources;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class DamageMessage : OutgoingMessage
    {
        public int TargetId { get; set; }
        public ConditionEffectIndex Effects { get; set; }
        public int DamageAmount { get; set; }
        public bool Kill { get; set; }
        public int BulletId { get; set; }
        public int ObjectId { get; set; }
        public bool Pierce { get; set; }

        public override MessageId MessageId => MessageId.DAMAGE;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(TargetId);
            List<byte> eff = new List<byte>();
            for (byte i = 1; i < 255; i++)
                if ((Effects & (ConditionEffectIndex)(1 << i)) != 0)
                    eff.Add(i);
            wtr.Write((byte)eff.Count);
            foreach (var i in eff) wtr.Write(i);
            wtr.Write(DamageAmount);
            wtr.Write(Kill);
            wtr.Write(BulletId);
            wtr.Write(ObjectId);
            wtr.Write(Pierce);
        }
    }
}
