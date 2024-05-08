package kabam.rotmg.messaging.impl.incoming
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.TradeItem;
   
   public class TradeStart extends IncomingMessage
   {
       
      
      public var myItems_:Vector.<TradeItem>;
      
      public var yourName_:String;
      
      public var yourItems_:Vector.<TradeItem>;
      
      public function TradeStart(id:uint, callback:Function)
      {
         this.myItems_ = new Vector.<TradeItem>();
         this.yourItems_ = new Vector.<TradeItem>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var i:int = 0;
         var len:int = data.readShort();
         for(i = len; i < this.myItems_.length; i++)
         {
            FreeList.deleteObject(this.myItems_[i]);
         }
         this.myItems_.length = Math.min(len,this.myItems_.length);
         while(this.myItems_.length < len)
         {
            this.myItems_.push(FreeList.newObject(TradeItem) as TradeItem);
         }
         for(i = 0; i < len; i++)
         {
            this.myItems_[i].parseFromInput(data);
         }
         this.yourName_ = data.readUTF();
         len = data.readShort();
         for(i = len; i < this.yourItems_.length; i++)
         {
            FreeList.deleteObject(this.yourItems_[i]);
         }
         this.yourItems_.length = Math.min(len,this.yourItems_.length);
         while(this.yourItems_.length < len)
         {
            this.yourItems_.push(FreeList.newObject(TradeItem) as TradeItem);
         }
         for(i = 0; i < len; i++)
         {
            this.yourItems_[i].parseFromInput(data);
         }
      }
      
      override public function toString() : String
      {
         return formatToString("TRADESTART","myItems_","yourName_","yourItems_");
      }
   }
}
