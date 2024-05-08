package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Failure extends IncomingMessage
   {
      public static const INCORRECT_VERSION:int = 1;
      public static const FORCE_CLOSE_GAME:int = 2;
      public static const INVALID_TELEPORT_TARGET:int = 3;
       
      
      public var errorId_:int;
      
      public var errorDescription_:String;
      
      public function Failure(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.errorId_ = data.readInt();
         this.errorDescription_ = data.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("FAILURE","errorId_","errorDescription_");
      }
   }
}
