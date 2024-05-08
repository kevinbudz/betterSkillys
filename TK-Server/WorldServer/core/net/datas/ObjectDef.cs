using Shared;

namespace WorldServer.core.net.datas
{
    public struct ObjectDef
    {
        public int ObjectType;
        public ObjectStats Stats;

        public static ObjectDef Read(NetworkReader rdr) => new ObjectDef
        {
            ObjectType = rdr.ReadInt32(),
            Stats = ObjectStats.Read(rdr)
        };

        public void Write(NetworkWriter wtr)
        {
            wtr.Write(ObjectType);
            Stats.Write(wtr);
        }
    }
}
