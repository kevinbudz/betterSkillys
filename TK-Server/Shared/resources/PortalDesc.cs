using System.Xml.Linq;

namespace Shared.resources
{
    public class PortalDesc : ObjectDesc
    {
        public readonly bool IntergamePortal;
        public readonly bool Locked;
        public readonly bool NexusPortal;
        public readonly int Timeout;

        public string DungeonName;

        public PortalDesc(ushort type, XElement e) : base(type, e)
        {
            NexusPortal = e.HasElement("NexusPortal");
            DungeonName = e.GetValue<string>("DungeonName");
            IntergamePortal = e.HasElement("IntergamePortal");
            Locked = e.HasElement("LockedPortal");
            Timeout = e.GetValue("Timeout", 30);
        }
    }
}
