package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class EnemyHit extends OutgoingMessage
   {
      public var time_:int;
      public var bulletId_:uint;
      public var targetId_:int;
      public var kill_:Boolean;
      
      public function EnemyHit(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         data.writeInt(this.bulletId_);
         data.writeInt(this.targetId_);
         data.writeBoolean(this.kill_);
      }
      
      override public function toString() : String
      {
         return formatToString("ENEMYHIT","time_","bulletId_","targetId_","kill_");
      }
   }
}
