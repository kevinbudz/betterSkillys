package kabam.rotmg.messaging.impl.incoming.bounty
{

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.MarketData;

import kabam.rotmg.messaging.impl.incoming.IncomingMessage;

public class BountyMemberListSend  extends IncomingMessage
{

    public var playerIds:Vector.<int>;

    public function BountyMemberListSend(id:uint, callback:Function)
    {
        this.playerIds = new Vector.<int>();
        super(id,callback);
    }

    override public function parseFromInput(data:IDataInput) : void
    {
        this.playerIds.length = 0;
        var num:int = data.readInt();
        var ids:int = 0;
        while (ids < num)
        {
            this.playerIds.push(data.readInt());
            ids++;
        }
    }

}
}
