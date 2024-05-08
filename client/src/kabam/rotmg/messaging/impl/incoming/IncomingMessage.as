package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataOutput;
   import kabam.lib.net.impl.Message;
   
   public class IncomingMessage extends Message
   {
       
      
      public function IncomingMessage(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public final function writeToOutput(data:IDataOutput) : void
      {
         throw new Error("Client should not send " + id + " messages");
      }
   }
}
