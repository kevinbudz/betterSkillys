package kabam.rotmg.messaging.impl.incoming.market
{

import com.company.assembleegameclient.util.FreeList;

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.MarketData;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class MarketMyOffersResult  extends IncomingMessage
{
    public var results_:Vector.<MarketData>;

    public function MarketMyOffersResult(id:uint, callback:Function)
    {
        this.results_ = new Vector.<MarketData>();
        super(id,callback);
    }

    override public function parseFromInput(data:IDataInput) : void
    {
        var i:int = 0;
        var len:int = data.readShort();
        for(i = len; i < this.results_.length; i++)
        {
            FreeList.deleteObject(this.results_[i]);
        }
        this.results_.length = Math.min(len,this.results_.length);
        while(this.results_.length < len)
        {
            this.results_.push(FreeList.newObject(MarketData) as MarketData);
        }
        for(i = 0; i < len; i++)
        {
            this.results_[i].parseFromInput(data);
        }
    }
}
}
