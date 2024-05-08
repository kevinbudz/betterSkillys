package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class TradeAccepted extends IncomingMessage
   {
       
      
      public var myOffer_:Vector.<Boolean>;
      
      public var yourOffer_:Vector.<Boolean>;
      
      public function TradeAccepted(id:uint, callback:Function)
      {
         this.myOffer_ = new Vector.<Boolean>();
         this.yourOffer_ = new Vector.<Boolean>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var i:int = 0;
         this.myOffer_.length = 0;
         var num:int = data.readShort();
         for(i = 0; i < num; i++)
         {
            this.myOffer_.push(data.readBoolean());
         }
         this.yourOffer_.length = 0;
         num = data.readShort();
         for(i = 0; i < num; i++)
         {
            this.yourOffer_.push(data.readBoolean());
         }
      }
      
      override public function toString() : String
      {
         return formatToString("TRADEACCEPTED","myOffer_","yourOffer_");
      }
   }
}
