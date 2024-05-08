package kabam.rotmg.messaging.impl.incoming
{
   import flash.display.BitmapData;
   import flash.utils.IDataInput;
   
   public class Death extends IncomingMessage
   {
       
      
      public var accountId_:int;
      
      public var charId_:int;
      
      public var killedBy_:String;
      
      public var background:BitmapData;
      
      public function Death(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      public function disposeBackground() : void
      {
         this.background && this.background.dispose();
         this.background = null;
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.accountId_ = data.readInt();
         this.charId_ = data.readInt();
         this.killedBy_ = data.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("DEATH","accountId_","charId_","killedBy_");
      }
   }
}
