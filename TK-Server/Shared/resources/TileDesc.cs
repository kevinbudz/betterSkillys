using System.Collections.Generic;
using System.Xml.Linq;

namespace Shared.resources
{
    public class TileDesc
    {
        public readonly bool Damaging;
        public readonly int MaxDamage;
        public readonly int MinDamage;
        public readonly bool NoWalk;
        public readonly ushort ObjectType;
        public readonly bool Push;
        public readonly float PushX;
        public readonly float PushY;
        public readonly bool Sink;
        public readonly bool Sinking;
        public readonly float Speed;

        public string ObjectId;

        public TileDesc(ushort type, XElement e)
        {
            ObjectType = type;
            ObjectId = e.GetAttribute<string>("id");
            NoWalk = e.HasElement("NoWalk");

            if (e.HasElement("MinDamage"))
            {
                MinDamage = e.GetValue<int>("MinDamage");
                Damaging = true;
            }

            if (e.HasElement("MaxDamage"))
            {
                MaxDamage = e.GetValue<int>("MaxDamage");
                Damaging = true;
            }

            Sink = e.HasElement("Sink");
            Sinking = e.HasElement("Sinking");

            Speed = e.GetValue("Speed", 1.0f);
            Push = e.HasElement("Push");
            if (Push)
            {
                var anim = e.Element("Animate");
                if (anim.HasAttribute("dx"))
                    PushX = anim.GetAttribute<float>("dx");
                if (anim.HasAttribute("dy"))
                    PushY = anim.GetAttribute<float>("dy");
            }

            if (e.Element("ConditionEffect") != null)
            {
                List<ConditionEffect> effects = new List<ConditionEffect>();
                foreach (XElement i in e.Elements("ConditionEffect"))
                    effects.Add(new ConditionEffect(i));
                Effects = effects.ToArray();
            }
        }

        public ConditionEffect[] Effects { get; private set; }
    }
}
