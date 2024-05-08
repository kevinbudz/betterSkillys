package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class Pong extends OutgoingMessage
   {
       
      
      public var serial_:int;
      
      public var time_:int;
      
      public function Pong(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.serial_);
         data.writeInt(this.time_);
      }
      
      override public function toString() : String
      {
         return formatToString("PONG","serial_","time_");
      }
   }
}
