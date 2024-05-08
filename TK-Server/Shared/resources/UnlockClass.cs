using System.Xml.Linq;

namespace Shared.resources
{
    public class UnlockClass
    {
        public readonly uint? Cost;
        public readonly int? Level;
        public readonly ushort? Type;

        public UnlockClass(XElement e)
        {
            var n = e.Element("UnlockLevel");

            if (n != null && n.HasAttribute("type") && n.HasAttribute("level"))
            {
                Type = n.GetAttribute<ushort>("type");
                Level = n.GetAttribute<int>("level");
            }

            n = e.Element("UnlockCost");

            if (n != null)
                Cost = (uint)int.Parse(n.Value);
        }
    }
}
