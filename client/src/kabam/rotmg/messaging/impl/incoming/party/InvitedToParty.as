package kabam.rotmg.messaging.impl.incoming.party
{
import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class InvitedToParty extends IncomingMessage
{


    public var name_:String;

    public var partyId_:int;

    public function InvitedToParty(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function parseFromInput(data:IDataInput) : void
    {
        this.name_ = data.readUTF();
        this.partyId_ = data.readInt();
    }

    override public function toString() : String
    {
        return formatToString("INVITED_TO_PARTY","name_");
    }
}
}
