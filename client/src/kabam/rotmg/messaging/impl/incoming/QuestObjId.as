package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class QuestObjId extends IncomingMessage
   {
       
      
      public var objectId_:int;
      
      public function QuestObjId(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.objectId_ = data.readInt();
      }
      
      override public function toString() : String
      {
         return formatToString("QUESTOBJID","objectId_");
      }
   }
}
