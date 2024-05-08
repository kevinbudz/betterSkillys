package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class ChangeTrade extends OutgoingMessage
   {
       
      
      public var offer_:Vector.<Boolean>;
      
      public function ChangeTrade(id:uint, callback:Function)
      {
         this.offer_ = new Vector.<Boolean>();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeShort(this.offer_.length);
         for(var i:int = 0; i < this.offer_.length; i++)
         {
            data.writeBoolean(this.offer_[i]);
         }
      }
      
      override public function toString() : String
      {
         return formatToString("CHANGETRADE","offer_");
      }
   }
}
