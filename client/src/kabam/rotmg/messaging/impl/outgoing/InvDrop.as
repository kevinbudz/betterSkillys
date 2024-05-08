package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   
   public class InvDrop extends OutgoingMessage
   {
       
      
      public var slotObject_:SlotObjectData;
      
      public function InvDrop(id:uint, callback:Function)
      {
         this.slotObject_ = new SlotObjectData();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         this.slotObject_.writeToOutput(data);
      }
      
      override public function toString() : String
      {
         return formatToString("INVDROP","slotObject_");
      }
   }
}
