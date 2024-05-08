using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class SkinDesc
    {
        public readonly int Cost;
        public readonly ushort PlayerClassType;
        public readonly int Size;
        public readonly ushort Type;
        public readonly int UnlockLevel;

        public string ObjectId;

        public SkinDesc(ushort type, XElement e)
        {
            Type = type;
            ObjectId = e.GetAttribute<string>("id");
            PlayerClassType = e.GetValue<ushort>("PlayerClassType");
            UnlockLevel = e.GetValue<int>("UnlockLevel");
            Cost = e.GetValue("Cost", 300);
            Size = e.GetValue("Size", 100);
        }
    }
}
