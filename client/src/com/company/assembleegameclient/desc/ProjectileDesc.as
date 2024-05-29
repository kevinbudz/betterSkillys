package com.company.assembleegameclient.desc {

public class ProjectileDesc {

    public var BulletType:int;
    public var ObjectId:String;
    public var Speed:Number;
    public var MinDamage:int;
    public var MaxDamage:int;
    public var LifetimeMS:Number;
    public var MultiHit:Boolean;
    public var PassesCover:Boolean;
    public var Parametric:Boolean;
    public var Boomerang:Boolean;
    public var ArmorPiercing:Boolean;
    public var Wavy:Boolean;
    public var Effects:Vector.<CondEffect>;
    public var Amplitude:Number;
    public var Frequency:Number;
    public var Magnitude:Number;
    public var Sound:String;

    public function ProjectileDesc(obj:*) {
        if (!obj)
            return;
        this.BulletType = ItemAttributes.GetValue(obj, null, "BulletType/@id", 0);
        this.ObjectId = ItemAttributes.GetValue(obj, null, "ObjectId", null);
        this.Speed = ItemAttributes.GetValue(obj, null, "Speed", 0);
        if (ItemAttributes.HasValue(obj, null, "Damage"))
        {
            this.MinDamage = ItemAttributes.GetValue(obj, null, "Damage", 0);
            this.MaxDamage = this.MinDamage;
        }
        else {
            this.MinDamage = ItemAttributes.GetValue(obj, null, "MinDamage", 0);
            this.MaxDamage = ItemAttributes.GetValue(obj, null, "MaxDamage", 0);
        }
        this.LifetimeMS = ItemAttributes.GetValue(obj, null, "LifetimeMS", 0);
        this.MultiHit = ItemAttributes.GetValue(obj, null, "MultiHit", false);
        this.PassesCover = ItemAttributes.GetValue(obj, null, "PassesCover", false);
        this.Parametric = ItemAttributes.GetValue(obj, null, "Parametric", false);
        this.Boomerang = ItemAttributes.GetValue(obj, null, "Boomerang", false);
        this.ArmorPiercing = ItemAttributes.GetValue(obj, null, "ArmorPiercing", false);
        this.Wavy = ItemAttributes.GetValue(obj, null, "Wavy", false);
        if (ItemAttributes.HasValue(obj, null, "Effects/ConditionEffect")){
            this.Effects = new Vector.<CondEffect>();
            for each (var eff:* in ItemAttributes.GetValue(obj, null, "Effects/ConditionEffect", null)){
                this.Effects.push(new CondEffect(ItemAttributes.GetValue(eff, null, "EffectName/", 0), ItemAttributes.GetValue(eff, null, "DurationMS/@duration", 0)));
            }
        }
        this.Amplitude = ItemAttributes.GetValue(obj, null, "Amplitude", 0);
        this.Frequency = ItemAttributes.GetValue(obj, null, "Frequency", 1);
        this.Magnitude = ItemAttributes.GetValue(obj, null, "Magnitude", 3);
        this.Sound = ItemAttributes.GetValue(obj, null, "Sound", null);
    }
}
}
