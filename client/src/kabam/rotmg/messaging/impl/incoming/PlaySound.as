package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class PlaySound extends IncomingMessage
   {
       
      
      public var ownerId_:int;
      
      public var soundId_:int;
      
      public function PlaySound(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.ownerId_ = data.readInt();
         this.soundId_ = data.readUnsignedByte();
      }
      
      override public function toString() : String
      {
         return formatToString("PLAYSOUND","ownerId_","soundId_");
      }
   }
}
