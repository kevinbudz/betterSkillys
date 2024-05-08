using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class MapInfoMessage : OutgoingMessage
    {
        public short Width { get; set; }
        public short Height { get; set; }
        public string Name { get; set; }
        public string DisplayName { get; set; }
        public uint Seed { get; set; }
        public byte Background { get; set; }
        public byte Difficulty { get; set; }
        public bool AllowPlayerTeleport { get; set; }
        public bool ShowDisplays { get; set; }
        public string Music { get; set; }
        public bool DisableShooting { get; set; }
        public bool DisableAbilities { get; set; }


        public override MessageId MessageId => MessageId.MAPINFO;

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(Width);
            wtr.Write(Height);
            wtr.WriteUTF16(Name);
            wtr.WriteUTF16(DisplayName);
            wtr.Write(Seed);
            wtr.Write(Background);
            wtr.Write(Difficulty);
            wtr.Write(AllowPlayerTeleport);
            wtr.Write(ShowDisplays);
            wtr.WriteUTF16(Music);
            wtr.Write(DisableShooting);
            wtr.Write(DisableAbilities);
        }
    }
}
