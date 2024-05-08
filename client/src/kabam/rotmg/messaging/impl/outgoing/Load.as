package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class Load extends OutgoingMessage
   {
       
      
      public var charId_:int;
      
      public function Load(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.charId_);
      }
      
      override public function toString() : String
      {
         return formatToString("LOAD","charId_");
      }
   }
}
