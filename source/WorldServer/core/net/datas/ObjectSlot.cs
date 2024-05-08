using Shared;

namespace WorldServer.core.net.datas
{
    public struct ObjectSlot
    {
        public int ObjectId;
        public int ObjectType;
        public byte SlotId;

        public static ObjectSlot Read(NetworkReader rdr) => new ObjectSlot
        {
            ObjectId = rdr.ReadInt32(),
            SlotId = rdr.ReadByte(),
            ObjectType = rdr.ReadInt32()
        };

        public override string ToString() => string.Format("{{ObjectId: {0}, SlotId: {1}, ObjectType: {2}}}", ObjectId, SlotId, ObjectType);

        public void Write(NetworkWriter wtr)
        {
            wtr.Write(ObjectId);
            wtr.Write(SlotId);
            wtr.Write(ObjectType);
        }
    }
}
