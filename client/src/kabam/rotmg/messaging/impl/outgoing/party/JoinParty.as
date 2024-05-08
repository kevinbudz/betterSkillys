package kabam.rotmg.messaging.impl.outgoing.party
{
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class JoinParty extends OutgoingMessage
{


    public var leader_:String;
    public var partyId:int;

    public function JoinParty(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
        data.writeUTF(this.leader_);
        data.writeInt(this.partyId);
    }

    override public function toString() : String
    {
        return formatToString("JOINGUILD","guildName_");
    }
}
}
