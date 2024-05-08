package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class PlayerShoot extends OutgoingMessage
   {
      public var time_:int;
      public var bulletId_:uint;
      public var containerType_:int;
      public var startingPos_:WorldPosData;
      public var angle_:Number;

      public function PlayerShoot(id:uint, callback:Function)
      {
         this.startingPos_ = new WorldPosData();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         data.writeInt(this.bulletId_);
         data.writeInt(this.containerType_);
         this.startingPos_.writeToOutput(data);
         data.writeFloat(this.angle_);
      }
      
      override public function toString() : String
      {
         return formatToString("PLAYERSHOOT","time_","bulletId_","containerType_","startingPos_","angle_");
      }
   }
}
