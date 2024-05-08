package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class AcceptTrade extends OutgoingMessage
   {
       
      
      public var myOffer_:Vector.<Boolean>;
      
      public var yourOffer_:Vector.<Boolean>;
      
      public function AcceptTrade(id:uint, callback:Function)
      {
         this.myOffer_ = new Vector.<Boolean>();
         this.yourOffer_ = new Vector.<Boolean>();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         var i:int = 0;
         data.writeShort(this.myOffer_.length);
         for(i = 0; i < this.myOffer_.length; i++)
         {
            data.writeBoolean(this.myOffer_[i]);
         }
         data.writeShort(this.yourOffer_.length);
         for(i = 0; i < this.yourOffer_.length; i++)
         {
            data.writeBoolean(this.yourOffer_[i]);
         }
      }
      
      override public function toString() : String
      {
         return formatToString("ACCEPTTRADE","myOffer_","yourOffer_");
      }
   }
}
