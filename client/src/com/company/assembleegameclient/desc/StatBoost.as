package com.company.assembleegameclient.desc{

public class StatBoost {

    public var Stat:int;
    public var Amount:int;

    public function StatBoost(obj:*) {
        this.Stat = ItemData.GetValue(obj, null, "Key/@stat", -1);
        this.Amount = ItemData.GetValue(obj, null, "Value/@amount", 0);
    }
}
}
