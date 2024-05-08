package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class EditAccountList extends OutgoingMessage
   {
       
      
      public var accountListId_:int;
      
      public var add_:Boolean;
      
      public var objectId_:int;
      
      public function EditAccountList(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.accountListId_);
         data.writeBoolean(this.add_);
         data.writeInt(this.objectId_);
      }
      
      override public function toString() : String
      {
         return formatToString("EDITACCOUNTLIST","accountListId_","add_","objectId_");
      }
   }
}
