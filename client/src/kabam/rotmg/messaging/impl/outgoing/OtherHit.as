package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class OtherHit extends OutgoingMessage
   {
       
      
      public var time_:int;
      
      public var bulletId_:uint;
      
      public var objectId_:int;
      
      public var targetId_:int;
      
      public function OtherHit(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         data.writeInt(this.bulletId_);
         data.writeInt(this.objectId_);
         data.writeInt(this.targetId_);
      }
      
      override public function toString() : String
      {
         return formatToString("OTHERHIT","time_","bulletId_","objectId_","targetId_");
      }
   }
}
