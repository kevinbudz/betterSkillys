package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class BreakdownSlot extends OutgoingMessage
   {
      public var time_:int;
      public var slot_:int;
      public var objectId_:int;

      public function BreakdownSlot(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(time_);
         data.writeByte(slot_);
         data.writeInt(objectId_);
      }

      override public function toString() : String
      {
         return formatToString("SELLITEM","time_", "slot_", "objectId_");
      }
   }
}
