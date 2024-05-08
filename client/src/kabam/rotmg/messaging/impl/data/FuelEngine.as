package kabam.rotmg.messaging.impl.data
{

import flash.utils.IDataOutput;

public class FuelEngine
{


    public var objectType_:int;
    public var slotId_:int;
    public var included_:Boolean;
    public var itemData_:int;

    public function FuelEngine()
    {
        super();
    }

    public function parseFromInput(data:IDataOutput) : void
    {
        data.writeShort(this.objectType_);
        data.writeInt(this.slotId_);
        data.writeBoolean(this.included_);
        data.writeInt(this.itemData_)
    }

    public function toString() : String
    {
        return "";
    }
}
}
