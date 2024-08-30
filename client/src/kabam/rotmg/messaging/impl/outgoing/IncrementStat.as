package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class IncrementStat extends OutgoingMessage {

    public var statIndex_:int;
    public var increase_:int;

    public function IncrementStat(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.statIndex_);
        _arg1.writeInt(this.increase_);
    }

    override public function toString():String {
        return (formatToString("IncrementStat", "statIndex_", "increase_"));
    }


}
}
