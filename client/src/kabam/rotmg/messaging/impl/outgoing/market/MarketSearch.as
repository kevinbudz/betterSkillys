package kabam.rotmg.messaging.impl.outgoing.market
{

import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class MarketSearch extends OutgoingMessage
{
    public var itemType_:int;

    public function MarketSearch(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
        data.writeInt(this.itemType_);
    }
}
}
