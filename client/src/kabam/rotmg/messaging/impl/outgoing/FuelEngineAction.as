package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.FuelEngine;

public class FuelEngineAction extends OutgoingMessage{


    public var myInv:Vector.<FuelEngine>;

    public function FuelEngineAction(id:uint, callback:Function)
    {
        super(id,callback);
        this.myInv = new Vector.<FuelEngine>();
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
        var i:int = 0;
        data.writeShort(this.myInv.length);
        for(i = 0; i < this.myInv.length; i++)
        {
            data.writeShort(this.myInv[i].objectType_);
            data.writeInt(this.myInv[i].slotId_);
            data.writeBoolean(this.myInv[i].included_);
            data.writeInt(this.myInv[i].itemData_)
        }
    }

    override public function toString() : String
    {
        return formatToString("ENGINE_FUEL_ACTION","myInventory_");
    }

}
}
