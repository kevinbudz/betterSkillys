package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class Buy extends OutgoingMessage
   {
      public var objectId_:int;
      
      public function Buy(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.objectId_);
      }
      
      override public function toString() : String
      {
         return formatToString("BUY","objectId_");
      }
   }
}
