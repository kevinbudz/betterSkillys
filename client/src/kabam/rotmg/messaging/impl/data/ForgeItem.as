package kabam.rotmg.messaging.impl.data
{

import flash.utils.IDataOutput;

public class ForgeItem
{


    public var objectType_:int;
    public var slotId_:int;
    public var included_:Boolean;

    public function ForgeItem()
    {
        super();
    }

    public function parseFromInput(data:IDataOutput) : void
    {
        data.writeShort(this.objectType_);
        data.writeInt(this.slotId_);
        data.writeBoolean(this.included_);
    }

    public function toString() : String
    {
        return "";
    }
}
}
