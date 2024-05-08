package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ServerPlayerShoot extends IncomingMessage
   {
       
      
      public var bulletId_:uint;
      
      public var ownerId_:int;
      
      public var containerType_:int;
      
      public var startingPos_:WorldPosData;
      
      public var angle_:Number;
      
      public var damage_:int;
      
      public function ServerPlayerShoot(id:uint, callback:Function)
      {
         this.startingPos_ = new WorldPosData();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.bulletId_ = data.readInt();
         this.ownerId_ = data.readInt();
         this.containerType_ = data.readInt();
         this.startingPos_.parseFromInput(data);
         this.angle_ = data.readFloat();
         this.damage_ = data.readInt();
      }
      
      override public function toString() : String
      {
         return formatToString("SHOOT","bulletId_","ownerId_","containerType_","startingPos_","angle_","damage_");
      }
   }
}
