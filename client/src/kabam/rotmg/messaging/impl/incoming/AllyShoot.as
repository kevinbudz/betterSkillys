package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class AllyShoot extends IncomingMessage
   {
       
      
      public var bulletId_:uint;
      
      public var ownerId_:int;
      
      public var containerType_:int;
      
      public var angle_:Number;
      
      public function AllyShoot(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.bulletId_ = data.readInt();
         this.ownerId_ = data.readInt();
         this.containerType_ = data.readInt();
         this.angle_ = data.readFloat();
      }
      
      override public function toString() : String
      {
         return formatToString("ALLYSHOOT","bulletId_","ownerId_","containerType_","angle_");
      }
   }
}
