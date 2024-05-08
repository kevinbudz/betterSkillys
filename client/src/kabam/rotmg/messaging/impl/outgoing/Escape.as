package kabam.rotmg.messaging.impl.outgoing
{
import flash.utils.IDataOutput;

public class Escape extends OutgoingMessage
{


    public function Escape(id:uint, callback:Function)
    {
        super(id,callback);
    }

    override public function writeToOutput(data:IDataOutput) : void
    {
    }

    override public function toString() : String
    {
        return formatToString("ESCAPE");
    }
}
}
