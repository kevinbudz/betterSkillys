package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class UsePotion extends OutgoingMessage {

    public var itemId_:int;

    public function UsePotion(val:uint, func:Function) {
        super(val, func);
    }

    override public function writeToOutput(iDataOutput:IDataOutput):void {
        iDataOutput.writeInt(this.itemId_);
    }

    override public function toString():String {
        return (formatToString("USEPOTION", "itemId_"));
    }


}
}