using System.Collections.Generic;
using System.Xml.Linq;

namespace Shared.resources
{
    public class ProjectileDesc
    {
        public float Amplitude;
        public bool ArmorPiercing;
        public bool Boomerang;
        public int BulletType;
        public ConditionEffect[] Effects;
        public float Frequency;
        public float LifetimeMS;
        public float OrigSpeed;
        public float NewSpeed;
        public float Magnitude;
        public int MaxDamage;
        public int MinDamage;
        public bool MultiHit;
        public string ObjectId;
        public bool Parametric;
        public bool PassesCover;
        public float Speed;
        public bool Wavy;

        public ProjectileDesc(XElement e)
        {
            BulletType = e.GetAttribute<int>("id");
            ObjectId = e.GetValue<string>("ObjectId");
            LifetimeMS = e.GetValue<float>("LifetimeMS");
            Speed = e.GetValue<float>("Speed", 100);
            OrigSpeed = e.GetValue<float>("Speed", 100);
            NewSpeed = e.GetValue<float>("Speed", 100) * 1.25f;

            var dmg = e.Element("Damage");

            if (dmg != null)
                MinDamage = MaxDamage = e.GetValue<int>("Damage");
            else
            {
                MinDamage = e.GetValue<int>("MinDamage");
                MaxDamage = e.GetValue<int>("MaxDamage");
            }

            var effects = new List<ConditionEffect>();

            foreach (var i in e.Elements("ConditionEffect"))
                effects.Add(new ConditionEffect(i));

            Effects = effects.ToArray();
            MultiHit = e.HasElement("MultiHit");
            PassesCover = e.HasElement("PassesCover");
            ArmorPiercing = e.HasElement("ArmorPiercing");
            Wavy = e.HasElement("Wavy");
            Parametric = e.HasElement("Parametric");
            Boomerang = e.HasElement("Boomerang");
            Amplitude = e.GetValue<float>("Amplitude", 0);
            Frequency = e.GetValue<float>("Frequency", 1);
            Magnitude = e.GetValue<float>("Magnitude", 3);
        }
    }
}
