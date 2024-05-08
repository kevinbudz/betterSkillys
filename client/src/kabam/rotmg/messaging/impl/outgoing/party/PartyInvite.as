package kabam.rotmg.messaging.impl.outgoing.party
{
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class PartyInvite extends OutgoingMessage
{


    public var name_:String;

    public function PartyInvite(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
        data.writeUTF(this.name_);
    }

    override public function toString() : String
    {
        return formatToString("PARTY_INVITE","name_");
    }
}
}
