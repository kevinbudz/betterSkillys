package kabam.rotmg.messaging.impl.incoming.market
{

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.MarketData;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class MarketRemoveResult  extends IncomingMessage
{
    public var code_:int;
    public var description_:String;

    public function MarketRemoveResult(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function parseFromInput(data:IDataInput) : void
    {
        this.code_ = data.readInt();
        this.description_ = data.readUTF();
    }
}
}
