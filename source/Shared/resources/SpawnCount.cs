using System.Xml.Linq;

namespace Shared.resources
{
    public class SpawnCount
    {
        public readonly int Max;
        public readonly int Mean;
        public readonly int Min;
        public readonly int StdDev;

        public SpawnCount(XElement e)
        {
            Mean = e.GetValue<int>("Mean");
            StdDev = e.GetValue<int>("StdDev");
            Min = e.GetValue<int>("Min");
            Max = e.GetValue<int>("Max");
        }
    }
}
