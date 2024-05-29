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

    public function ActivateEffect(obj:*) {
        //trace(XML(obj).toXMLString());
        this.EffectName = ItemData.GetValue(obj, null, "EffectName/", null);
        this.EffectId = ItemData.GetValue(obj, null, "Effect", 0);
        this.ConditionEffect = ItemData.GetValue(obj, null, "ConditionEffectName/@effect", null);
        if (!this.ConditionEffect || this.ConditionEffect == "")
            this.ConditionEffect = ItemData.GetValue(obj, null, "@condEffect", null);
        this.CheckExistingEffect = ItemData.GetValue(obj, null, "CheckExistingEffect/@checkExistingEffect", 0);
        this.TotalDamage = ItemData.GetValue(obj, null, "TotalDamage/@totalDamage", 0);
        this.Radius = ItemData.GetValue(obj, null, "Radius/@radius", 0);
        this.EffectDuration = ItemData.GetValue(obj, null, "EffectDuration/@condDuration", 0);
        this.DurationSec = ItemData.GetValue(obj, null, "DurationSec/@duration", 0);
        this.DurationMS = this.DurationSec * 1000;
        this.Amount = ItemData.GetValue(obj, null, "Amount/@amount", 0);
        this.Range = ItemData.GetValue(obj, null, "Range/@range", 0);
        this.MaximumDistance = ItemData.GetValue(obj, null, "MaximumDistance/@maxDistance", 0);
        this.ObjectId = ItemData.GetValue(obj, null, "ObjectId/@objectId", null);
        this.Id = ItemData.GetValue(obj, null, "Id/@id", null);
        this.MaxTargets = ItemData.GetValue(obj, null, "MaxTargets/@maxTargets", 0);
        this.Color = ItemData.GetValue(obj, null, "Color/@color", 0);
        this.Stats = ItemData.GetValue(obj, null, "Stats/@stat", -1);
        this.Cooldown = ItemData.GetValue(obj, null, "Cooldown/@cooldown", 0);
        this.RemoveSelf = ItemData.GetValue(obj, null, "RemoveSelf/@removeSelf", false);
        this.DungeonName = ItemData.GetValue(obj, null, "DungeonName/@dungeonName", null);
        this.LockedName = ItemData.GetValue(obj, null, "LockedName/@lockedName", null);
        this.Type = ItemData.GetValue(obj, null, "Type/@type", null);
        this.UseWisMod = ItemData.GetValue(obj, null, "UseWisMod/@useWisMod", false);
        this.Target = ItemData.GetValue(obj, null, "Target/@target", null);
        this.Center = ItemData.GetValue(obj, null, "Center/@center", null);
        this.VisualEffect = ItemData.GetValue(obj, null, "VisualEffect/@visualEffect", 0);
        this.AirDurationMS = ItemData.GetValue(obj, null, "AirDurationMS/@airDurationMS", 1500);
        this.SkinType = ItemData.GetValue(obj, null, "SkinType/@skinType", 0);
        this.ImpactDmg = ItemData.GetValue(obj, null, "ImpactDmg/@impactDmg", 0);
        this.NodeReq = ItemData.GetValue(obj, null, "NodeReq/@nodeReq", -1);
        this.DosesReq = ItemData.GetValue(obj, null, "DosesReq/@dosesReq", 0);
        this.CurrencyName = ItemData.GetValue(obj, null, "CurrencyName/@currency", null);
        this.Currency = ItemData.GetValue(obj, null, "Currency", 0);
        this.HealAmount = ItemData.GetValue(obj, null, "HealAmount/@heal", 0);
    }
}
}
