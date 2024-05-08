package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class PotionStorageInteraction extends OutgoingMessage {

    public var itemId_:int;
    public var action_:int;
    public var type_:int;


    public function PotionStorageInteraction(action:uint, func:Function) {
        super(action, func);
    }

    override public function writeToOutput(iDataOutput:IDataOutput):void {
        iDataOutput.writeByte(this.type_);
        iDataOutput.writeByte(this.action_);

    }

    override public function toString():String {
        return (formatToString("PotionStorageInteraction", "action_", "type_"));
    }


}
}
