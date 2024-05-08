package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Ping extends IncomingMessage
   {
      public var serial_:int;
      public var roundTripTime_:int;

      public function Ping(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.serial_ = data.readInt();
         this.roundTripTime_ = data.readInt();
      }
      
      override public function toString() : String
      {
         return formatToString("PING","serial_");
      }
   }
}
