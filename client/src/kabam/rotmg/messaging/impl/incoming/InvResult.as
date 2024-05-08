package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class InvResult extends IncomingMessage
   {
       
      
      public var result_:int;
      
      public function InvResult(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.result_ = data.readInt();
      }
      
      override public function toString() : String
      {
         return formatToString("INVRESULT","result_");
      }
   }
}
