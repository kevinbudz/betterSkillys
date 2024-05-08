package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class EnemyShoot extends IncomingMessage
   {
      public var bulletId_:uint;
      public var ownerId_:int;
      public var bulletType_:int;
      public var startingPos_:WorldPosData;
      public var angle_:Number;
      public var damage_:int;
      public var numShots_:int;
      public var angleInc_:Number;
      
      public function EnemyShoot(id:uint, callback:Function)
      {
         this.startingPos_ = new WorldPosData();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.bulletId_ = data.readInt();
         this.ownerId_ = data.readInt();
         this.bulletType_ = data.readUnsignedByte();
         this.startingPos_.parseFromInput(data);
         this.angle_ = data.readFloat();
         this.damage_ = data.readInt();
         if(data.bytesAvailable > 0)
         {
            this.numShots_ = data.readUnsignedByte();
            this.angleInc_ = data.readFloat();
         }
         else
         {
            this.numShots_ = 1;
            this.angleInc_ = 0;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("SHOOT","bulletId_","ownerId_","bulletType_","startingPos_","angle_","damage_","numShots_","angleInc_");
      }
   }
}
