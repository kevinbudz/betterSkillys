package kabam.rotmg.messaging.impl.outgoing.bounty {
import kabam.rotmg.messaging.impl.outgoing.*;

import flash.utils.IDataOutput;

public class BountyRequest extends OutgoingMessage {

    public var BountyId:int;
    public var playersAllowed:Vector.<int>;

    public function BountyRequest(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
        playersAllowed = new Vector.<int>();
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.BountyId);
        _arg1.writeInt(this.playersAllowed.length);
        for(var i:int = 0; i < this.playersAllowed.length; i++)
        {
            _arg1.writeInt(this.playersAllowed[i]);
        }
    }

    override public function toString():String {
        return (formatToString("BOUNTYREQUEST", "BountyId", "playersAllowed"));
    }


}
}
