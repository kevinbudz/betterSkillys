using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class NewCharacters
    {
        public readonly int Level;

        public NewCharacters(XElement e)
        {
            Level = e.GetValue("Level", 1);
        }
    }
}
