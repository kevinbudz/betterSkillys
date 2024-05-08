package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class GlobalNotification extends IncomingMessage
   {
       
      
      public var type:int;
      
      public var text:String;
      
      public function GlobalNotification(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.type = data.readInt();
         this.text = data.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("GLOBAL_NOTIFICATION","type","text");
      }
   }
}
