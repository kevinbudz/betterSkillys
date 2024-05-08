using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class PlayerDesc : ObjectDesc
    {
        public ushort[] Equipment;
        public Stat[] Stats;
        public UnlockClass Unlock;

        public PlayerDesc(ushort type, XElement e) : base(type, e)
        {
            Equipment = e.GetValue<string>("Equipment").CommaToArray<ushort>();
            Stats = new Stat[8];

            for (var i = 0; i < Stats.Length; i++)
                Stats[i] = new Stat(i, e);
            if (e.HasElement("UnlockLevel") || e.HasElement("UnlockCost"))
                Unlock = new UnlockClass(e);
        }
    }
}
