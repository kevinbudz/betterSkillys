package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.ForgeItem;

public class ForgeFusion extends OutgoingMessage{


    public var myInv:Vector.<ForgeItem>;

    public function ForgeFusion(id:uint, callback:Function)
    {
        super(id,callback);
        this.myInv = new Vector.<ForgeItem>();
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
        }
    }

    override public function toString() : String
    {
        return formatToString("FORGEFUSION","myInventory_");
    }

}
}
