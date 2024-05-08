package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class SquareHit extends OutgoingMessage
   {
       
      
      public var time_:int;
      
      public var bulletId_:uint;
      
      public var objectId_:int;
      
      public function SquareHit(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.time_);
         data.writeInt(this.bulletId_);
         data.writeInt(this.objectId_);
      }
      
      override public function toString() : String
      {
         return formatToString("SQUAREHIT","time_","bulletId_","objectId_");
      }
   }
}
