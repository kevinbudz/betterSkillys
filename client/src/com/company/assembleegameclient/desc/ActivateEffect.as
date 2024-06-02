package com.company.assembleegameclient.desc {

public class ActivateEffect {

    public var EffectName:String;
    public var EffectId:int;
    public var ConditionEffect:String;
    public var CheckExistingEffect:int;
    public var TotalDamage:int;
    public var Radius:Number;
    public var EffectDuration:Number;
    public var DurationSec:Number;
    public var DurationMS:int;
    public var Amount:int;
    public var Range:Number;
    public var MaximumDistance:Number;
    public var ObjectId:String;
    public var Id:String;
    public var MaxTargets:int;
    public var Color:uint;
    public var Stats:int;
    public var Cooldown:Number;
    public var RemoveSelf:Boolean;
    public var DungeonName:String;
    public var LockedName:String;
    public var Type:String;
    public var UseWisMod:Boolean;
    public var Target:String;
    public var Center:String;
    public var VisualEffect:int;
    public var AirDurationMS:int;
    public var SkinType:int;
    public var ImpactDmg:int;
    public var NodeReq:int;
    public var DosesReq:int;
    public var CurrencyName:String;
    public var Currency:int;
    public var HealAmount:int;
    public var NumShots:int;

    public function ActivateEffect(obj:*) {
        //trace(XML(obj).toXMLString());
        this.EffectName = ItemAttributes.GetValue(obj, null, "EffectName/", null);
        this.EffectId = ItemAttributes.GetValue(obj, null, "Effect", 0);
        this.ConditionEffect = ItemAttributes.GetValue(obj, null, "ConditionEffectName/@effect", null);
        if (!this.ConditionEffect || this.ConditionEffect == "")
            this.ConditionEffect = ItemAttributes.GetValue(obj, null, "@condEffect", null);
        this.CheckExistingEffect = ItemAttributes.GetValue(obj, null, "CheckExistingEffect/@checkExistingEffect", 0);
        this.TotalDamage = ItemAttributes.GetValue(obj, null, "TotalDamage/@totalDamage", 0);
        this.Radius = ItemAttributes.GetValue(obj, null, "Radius/@radius", 0);
        this.EffectDuration = ItemAttributes.GetValue(obj, null, "EffectDuration/@condDuration", 0);
        this.DurationSec = ItemAttributes.GetValue(obj, null, "DurationSec/@duration", 0);
        this.DurationMS = this.DurationSec * 1000;
        this.Amount = ItemAttributes.GetValue(obj, null, "Amount/@amount", 0);
        this.Range = ItemAttributes.GetValue(obj, null, "Range/@range", 0);
        this.MaximumDistance = ItemAttributes.GetValue(obj, null, "MaximumDistance/@maxDistance", 0);
        this.ObjectId = ItemAttributes.GetValue(obj, null, "ObjectId/@objectId", null);
        this.Id = ItemAttributes.GetValue(obj, null, "Id/@id", null);
        this.NumShots = ItemAttributes.GetValue(obj, null, "NumShots/@numShots", 20);
        this.MaxTargets = ItemAttributes.GetValue(obj, null, "MaxTargets/@maxTargets", 0);
        this.Color = ItemAttributes.GetValue(obj, null, "Color/@color", 0);
        this.Stats = ItemAttributes.GetValue(obj, null, "Stats/@stat", -1);
        this.Cooldown = ItemAttributes.GetValue(obj, null, "Cooldown/@cooldown", 0);
        this.RemoveSelf = ItemAttributes.GetValue(obj, null, "RemoveSelf/@removeSelf", false);
        this.DungeonName = ItemAttributes.GetValue(obj, null, "DungeonName/@dungeonName", null);
        this.LockedName = ItemAttributes.GetValue(obj, null, "LockedName/@lockedName", null);
        this.Type = ItemAttributes.GetValue(obj, null, "Type/@type", null);
        this.UseWisMod = ItemAttributes.GetValue(obj, null, "UseWisMod/@useWisMod", false);
        this.Target = ItemAttributes.GetValue(obj, null, "Target/@target", null);
        this.Center = ItemAttributes.GetValue(obj, null, "Center/@center", null);
        this.VisualEffect = ItemAttributes.GetValue(obj, null, "VisualEffect/@visualEffect", 0);
        this.AirDurationMS = ItemAttributes.GetValue(obj, null, "AirDurationMS/@airDurationMS", 1500);
        this.SkinType = ItemAttributes.GetValue(obj, null, "SkinType/@skinType", 0);
        this.ImpactDmg = ItemAttributes.GetValue(obj, null, "ImpactDmg/@impactDmg", 0);
        this.NodeReq = ItemAttributes.GetValue(obj, null, "NodeReq/@nodeReq", -1);
        this.DosesReq = ItemAttributes.GetValue(obj, null, "DosesReq/@dosesReq", 0);
        this.CurrencyName = ItemAttributes.GetValue(obj, null, "CurrencyName/@currency", null);
        this.Currency = ItemAttributes.GetValue(obj, null, "Currency", 0);
        this.HealAmount = ItemAttributes.GetValue(obj, null, "HealAmount/@heal", 0);
    }
}
}
