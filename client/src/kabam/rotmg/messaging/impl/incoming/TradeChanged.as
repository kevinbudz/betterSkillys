package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class TradeChanged extends IncomingMessage
   {
       
      
      public var offer_:Vector.<Boolean>;
      
      public function TradeChanged(id:uint, callback:Function)
      {
         this.offer_ = new Vector.<Boolean>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.offer_.length = 0;
         var num:int = data.readShort();
         for(var i:int = 0; i < num; i++)
         {
            this.offer_.push(data.readBoolean());
         }
      }
      
      override public function toString() : String
      {
         return formatToString("TRADECHANGED","offer_");
      }
   }
}
