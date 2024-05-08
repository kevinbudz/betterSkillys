package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Notification extends IncomingMessage
   {
      public var objectId_:int;
      public var text_:String;
      public var color_:int;
      public var playerId_:int;
      
      public function Notification(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.objectId_ = data.readInt();
         this.text_ = data.readUTF();
         this.color_ = data.readInt();
         this.playerId_ = data.readInt();
      }
      
      override public function toString() : String
      {
         return formatToString("NOTIFICATION","objectId_","text_","color_","playerId_");
      }
   }
}
