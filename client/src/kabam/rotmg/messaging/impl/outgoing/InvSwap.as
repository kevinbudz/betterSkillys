package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class InvSwap extends OutgoingMessage
   {
       
      
      public var time_:int;
      
      public var position_:WorldPosData;
      
      public var slotObject1_:SlotObjectData;
      
      public var slotObject2_:SlotObjectData;
      
      public function InvSwap(id:uint, callback:Function)
      {
         this.position_ = new WorldPosData();
         this.slotObject1_ = new SlotObjectData();
         this.slotObject2_ = new SlotObjectData();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         this.position_.writeToOutput(data);
         this.slotObject1_.writeToOutput(data);
         this.slotObject2_.writeToOutput(data);
      }
      
      override public function toString() : String
      {
         return formatToString("INVSWAP","time_","position_","slotObject1_","slotObject2_");
      }
   }
}
