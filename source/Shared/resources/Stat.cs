using System.Xml.Linq;
using Shared;

namespace Shared.resources
{
    public class Stat
    {
        public readonly int MaxIncrease;
        public readonly int MaxValue;
        public readonly int MinIncrease;
        public readonly int StartingValue;

        public string Type;

        public Stat(int index, XElement e)
        {
            Type = StatIndexToName(index);

            var x = e.Element(Type);

            if (x != null)
            {
                StartingValue = int.Parse(x.Value);
                MaxValue = x.GetAttribute<int>("max");
            }

            var y = e.Elements("LevelIncrease");

            foreach (var s in y)
                if (s.Value == Type)
                {
                    MinIncrease = s.GetAttribute<int>("min");
                    MaxIncrease = s.GetAttribute<int>("max");
                    break;
                }
        }

        private static string StatIndexToName(int index)
        {
            switch (index)
            {
                case 0: return "MaxHitPoints";
                case 1: return "MaxMagicPoints";
                case 2: return "Attack";
                case 3: return "Defense";
                case 4: return "Speed";
                case 5: return "Dexterity";
                case 6: return "HpRegen";
                case 7: return "MpRegen";
            }
            return null;
        }
    }
}
