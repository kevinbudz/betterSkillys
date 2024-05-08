using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class Text : OutgoingMessage
    {
        public string Name { get; set; }
        public int ObjectId { get; set; }
        public int NumStars { get; set; }
        public byte BubbleTime { get; set; }
        public string Recipient { get; set; }
        public string Txt { get; set; }
        public string CleanText { get; set; }
        public int NameColor { get; set; } = 0;
        public int TextColor { get; set; } = 0;

        public override MessageId MessageId => MessageId.TEXT;

        public override void Write(NetworkWriter wtr)
        {
            wtr.WriteUTF16(Name);
            wtr.Write(ObjectId);
            wtr.Write(NumStars);
            wtr.Write(BubbleTime);
            wtr.WriteUTF16(Recipient);
            wtr.WriteUTF16(Txt);
            wtr.WriteUTF16(CleanText);
            wtr.Write(NameColor);
            wtr.Write(TextColor);
        }
    }
}
