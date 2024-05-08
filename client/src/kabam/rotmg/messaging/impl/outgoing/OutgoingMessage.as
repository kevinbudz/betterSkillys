package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataInput;

import kabam.lib.net.impl.Message;

public class OutgoingMessage extends Message {
    public function OutgoingMessage(id:uint, callback:Function) {
        super(id, callback);
    }

    override public final function parseFromInput(data:IDataInput):void {
        throw new Error("Client should not receive " + id + " messages");
    }
}
}
