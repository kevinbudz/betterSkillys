package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class AccountList extends IncomingMessage
   {
       
      
      public var accountListId_:int;
      
      public var accountIds_:Vector.<int>;
      
      public function AccountList(id:uint, callback:Function)
      {
         this.accountIds_ = new Vector.<int>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var _local2:int;
         this.accountListId_ = data.readInt();
         this.accountIds_.length = 0;
         var num:int = data.readShort();
         _local2 = 0;
         while (_local2 < num) {
            this.accountIds_.push(data.readUTF());
            _local2++;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("ACCOUNTLIST","accountListId_","accountIds_");
      }
   }
}
