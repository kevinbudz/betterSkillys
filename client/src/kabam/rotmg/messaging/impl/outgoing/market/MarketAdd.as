package kabam.rotmg.messaging.impl.outgoing.market
{

import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

public class MarketAdd extends OutgoingMessage
{
    public var slots_:Vector.<int>;
    public var price_:int;
    public var currency_:int;
    public var hours_:int;

    public function MarketAdd(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
        data.writeByte(this.slots_.length);
        for (var i:int = 0; i < this.slots_.length; i++)
        {
            data.writeByte(this.slots_[i]);
        }
        data.writeInt(this.price_);
        data.writeInt(this.currency_);
        data.writeInt(this.hours_);
    }
}
}
