package com.company.assembleegameclient.desc {
import com.company.assembleegameclient.util.ConditionEffect;

public class CondEffect {

    public var Effect:int;
    public var EffectName:String;
    public var DurationMS:int;
    public var Range:Number;

    public function CondEffect(effect:String, duration:Number, range:Number = 0) {
        this.EffectName = effect;
        this.Effect = ConditionEffect.getConditionEffectFromName(effect);
        if (duration < 100) // ugly fix to incompatibility with item data
            duration *= 1000;
        this.DurationMS = duration;
        this.Range = range;
    }
}
}
