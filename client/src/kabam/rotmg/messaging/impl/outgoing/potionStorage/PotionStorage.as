package kabam.rotmg.messaging.impl.outgoing.potionStorage {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class PotionStorage extends OutgoingMessage {

    public var statType_:int;
    public var interactionType_:int;

    public function PotionStorage(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeByte(this.statType_);
        _arg1.writeInt(this.interactionType_);
    }

    override public function toString():String {
        return (formatToString("PotionStorage", "statType_", "interactionType_"));
    }


}
}
