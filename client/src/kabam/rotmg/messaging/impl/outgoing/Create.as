package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class Create extends OutgoingMessage
   {
       
      
      public var classType:int;
      
      public var skinType:int;
      
      public function Create(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeShort(this.classType);
         data.writeShort(this.skinType);
      }
      
      override public function toString() : String
      {
         return formatToString("CREATE","classType");
      }
   }
}
