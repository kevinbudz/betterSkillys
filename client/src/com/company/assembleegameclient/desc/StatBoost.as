package com.company.assembleegameclient.desc{

public class StatBoost {

    public var Stat:int;
    public var Amount:int;

    public function StatBoost(obj:*) {
        this.Stat = ItemAttributes.GetValue(obj, null, "Key/@stat", -1);
        this.Amount = ItemAttributes.GetValue(obj, null, "Value/@amount", 0);
    }
}
}
