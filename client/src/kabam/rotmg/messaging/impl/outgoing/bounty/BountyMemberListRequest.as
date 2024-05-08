package kabam.rotmg.messaging.impl.outgoing.bounty {
import kabam.rotmg.messaging.impl.outgoing.*;

import flash.utils.IDataOutput;

public class BountyMemberListRequest extends OutgoingMessage {

    public function BountyMemberListRequest(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
    }

    override public function toString():String {
        return (formatToString("BOUNTYMEMBERLISTREQUEST"));
    }


}
}
