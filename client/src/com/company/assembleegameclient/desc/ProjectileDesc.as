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
        this.BulletType = ItemData.GetValue(obj, null, "BulletType/@id", 0);
        this.ObjectId = ItemData.GetValue(obj, null, "ObjectId", null);
        this.Speed = ItemData.GetValue(obj, null, "Speed", 0);
        if (ItemData.HasValue(obj, null, "Damage"))
        {
            this.MinDamage = ItemData.GetValue(obj, null, "Damage", 0);
            this.MaxDamage = this.MinDamage;
        }
        else {
            this.MinDamage = ItemData.GetValue(obj, null, "MinDamage", 0);
            this.MaxDamage = ItemData.GetValue(obj, null, "MaxDamage", 0);
        }
        this.LifetimeMS = ItemData.GetValue(obj, null, "LifetimeMS", 0);
        this.MultiHit = ItemData.GetValue(obj, null, "MultiHit", false);
        this.PassesCover = ItemData.GetValue(obj, null, "PassesCover", false);
        this.Parametric = ItemData.GetValue(obj, null, "Parametric", false);
        this.Boomerang = ItemData.GetValue(obj, null, "Boomerang", false);
        this.ArmorPiercing = ItemData.GetValue(obj, null, "ArmorPiercing", false);
        this.Wavy = ItemData.GetValue(obj, null, "Wavy", false);
        if (ItemData.HasValue(obj, null, "Effects/ConditionEffect")){
            this.Effects = new Vector.<CondEffect>();
            for each (var eff:* in ItemData.GetValue(obj, null, "Effects/ConditionEffect", null)){
                this.Effects.push(new CondEffect(ItemData.GetValue(eff, null, "EffectName/", 0), ItemData.GetValue(eff, null, "DurationMS/@duration", 0)));
            }
        }
        this.Amplitude = ItemData.GetValue(obj, null, "Amplitude", 0);
        this.Frequency = ItemData.GetValue(obj, null, "Frequency", 1);
        this.Magnitude = ItemData.GetValue(obj, null, "Magnitude", 3);
        this.Sound = ItemData.GetValue(obj, null, "Sound", null);
    }
}
}
