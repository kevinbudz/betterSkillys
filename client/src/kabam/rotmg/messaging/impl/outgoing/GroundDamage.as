package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class GroundDamage extends OutgoingMessage
   {
       
      
      public var time_:int;
      
      public var position_:WorldPosData;
      
      public function GroundDamage(id:uint, callback:Function)
      {
         this.position_ = new WorldPosData();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         this.position_.writeToOutput(data);
      }
      
      override public function toString() : String
      {
         return formatToString("GROUNDDAMAGE","time_","position_");
      }
   }
}
