package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class GotoAck extends OutgoingMessage
   {
       
      
      public var time_:int;
      
      public function GotoAck(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
      }
      
      override public function toString() : String
      {
         return formatToString("GOTOACK","time_");
      }
   }
}
