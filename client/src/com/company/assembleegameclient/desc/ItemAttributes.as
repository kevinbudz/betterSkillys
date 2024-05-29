package com.company.assembleegameclient.desc {
import com.adobe.serialization.json.JSON;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.AnimatedChars;

public class ItemAttributes {

    public var ObjectType:int;
    public var ObjectId:String;
    public var DisplayName:String;
    public var DisplayId:String;
    public var Tex1:int;
    public var Tex2:int;
    public var SlotType:int;
    public var Description:String;
    public var Consumable:Boolean;
    public var InvUse:Boolean;
    public var Soulbound:Boolean;
    public var Potion:Boolean;
    public var Usable:Boolean;
    public var Resurrects:Boolean;
    public var RateOfFire:Number;
    public var Tier:int;
    public var BagType:int;
    public var FameBonus:int;
    public var NumProjectiles:int;
    public var ArcGap:Number;
    public var MpCost:int;
    public var MpEndCost:int;
    public var Cooldown:Number;
    public var Doses:int;
    public var Backpack:Boolean;
    public var MaxDoses:int;
    public var MultiPhase:Boolean;
    public var Treasure:Boolean;
    public var PermaPet:Boolean;
    public var StatsBoosts:Vector.<StatBoost>;
    public var ActivateEffects:Vector.<ActivateEffect>;
    public var Projectile:ProjectileDesc;
    public var Texture:TextureDesc;

    public function ItemAttributes(val:*, objType:int, fromJson:Boolean = true) {
        if (objType == -1)
            return;
        var obj:*;
        if (fromJson)
            obj = com.adobe.serialization.json.JSON.decode(val);
        else obj = ObjectLibrary.xmlLibrary_[val];
        var xml:XML = fromJson ? ObjectLibrary.xmlLibrary_[objType] : obj;
        this.ObjectType = objType;
        this.ObjectId = GetValue(obj, xml, "ObjectId/@id", null);
        this.DisplayId = GetValue(obj, xml, "DisplayId", null);
        this.DisplayName = this.DisplayId || this.ObjectId;
        this.Tex1 = GetValue(obj, xml, "Tex1", 0);
        this.Tex2 = GetValue(obj, xml, "Tex2", 0);
        this.SlotType = GetValue(obj, xml, "SlotType", 0);
        this.Description = GetValue(obj, xml, "Description", null);
        this.Consumable = GetValue(obj, xml, "Consumable", false);
        this.InvUse = GetValue(obj, xml, "InvUse", false);
        this.Soulbound = GetValue(obj, xml, "Soulbound", false);
        this.Potion = GetValue(obj, xml, "Potion", false);
        this.Usable = GetValue(obj, xml, "Usable", false);
        this.Resurrects = GetValue(obj, xml, "Resurrects", false);
        this.RateOfFire = GetValue(obj, xml, "RateOfFire", 1);
        this.Tier = GetValue(obj, xml, "Tier", -1);
        this.BagType = GetValue(obj, xml, "BagType", 0);
        this.FameBonus = GetValue(obj, xml, "FameBonus", 0);
        this.NumProjectiles = GetValue(obj, xml, "NumProjectiles", 1);
        if (this.NumProjectiles == -1 && HasValue(obj, xml, "Projectile"))
            this.NumProjectiles = 1;
        this.ArcGap = GetValue(obj, xml, "ArcGap", 11.25);
        this.MpCost = GetValue(obj, xml, "MpCost", -1);
        this.MpEndCost = GetValue(obj, xml, "MpEndCost", 0);
        this.Cooldown = GetValue(obj, xml, "Cooldown", 0.5);
        this.Doses = GetValue(obj, xml, "Doses", 0);
        this.Backpack = GetValue(obj, xml, "Backpack", false);
        this.MaxDoses = GetValue(obj, xml, "MaxDoses", 0);
        this.MultiPhase = GetValue(obj, xml, "MultiPhase", false);
        this.Treasure = GetValue(obj, xml, "Treasure", false);
        this.PermaPet = GetValue(obj, xml, "PermaPet", false);
        this.Texture = new TextureDesc(GetValue(obj, xml, "Texture", null));
        if (!this.Texture.File) {
            this.Texture = new TextureDesc(GetValue(obj, xml, "AnimatedTexture", null));
        }
        if (HasValue(xml, null, "Projectile")) {
            this.Projectile = new ProjectileDesc(GetValue(obj, xml, "Projectile", null));
        }
        if (HasValue(obj, xml, "ActivateOnEquip")) {
            this.StatsBoosts = new Vector.<StatBoost>();
            for each (var stat:* in GetValue(obj, xml, "ActivateOnEquip", null)) {
                this.StatsBoosts.push(new StatBoost(stat));
            }
        }
        if (HasValue(obj, xml, "Activate")) {
            this.ActivateEffects = new Vector.<ActivateEffect>();
            for each (var eff:* in GetValue(obj, xml, "Activate", null)) {
                this.ActivateEffects.push(new ActivateEffect(eff));
            }
        }
    }

    public static function FromXML(objType:int):ItemAttributes {
        if (objType == -1)
            return null;
        return new ItemAttributes(objType, objType, false);
    }

    public static function GetValue(obj:*, xml:XML, prop:String, defValue:*):* {
        if (!obj && !xml)
            return defValue;
        if (prop.indexOf('/') != -1) {
            var props:Array = prop.split('/');
            var prop1:String = props[0];
            var prop2:String = props[1];
            if (obj) {
                if (obj.hasOwnProperty(prop1))
                    return obj[prop1];
                if (obj.hasOwnProperty(prop2))
                    return obj[prop2];
                if (prop1 == "" || prop2 == "") {
                    return obj;
                }
            }
            if (xml) {
                if (xml.hasOwnProperty(prop1))
                    return xml[prop1];
                if (xml.hasOwnProperty(prop2))
                    return xml[prop2];
                if (prop1 == "" || prop2 == "")
                    return xml;
            }
            return defValue;
        }
        if (obj && obj.hasOwnProperty(prop))
            return obj[prop];
        if (xml && xml.hasOwnProperty(prop))
            return xml[prop];
        return defValue;
    }

    public static function HasValue(obj:*, xml:XML, prop:String):Boolean {
        if (!obj && !xml)
            return false;
        if (prop.indexOf('/') != -1) {
            var props:Array = prop.split('/');
            var prop1:String = props[0];
            var prop2:String = props[1];
            if (obj) {
                if (obj.hasOwnProperty(prop1))
                    return true;
                if (obj.hasOwnProperty(prop2))
                    return true;
            }
            if (xml) {
                if (xml.hasOwnProperty(prop1))
                    return true;
                if (xml.hasOwnProperty(prop2))
                    return true;
            }
            return false;
        }
        if (obj)
            return obj.hasOwnProperty(prop);
        return xml.hasOwnProperty(prop);
    }
}
}
