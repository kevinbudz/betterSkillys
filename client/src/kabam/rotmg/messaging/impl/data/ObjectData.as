package kabam.rotmg.messaging.impl.data
{
   import flash.utils.IDataInput;
   
   public class ObjectData
   {
       
      
      public var objectType_:int;
      
      public var status_:ObjectStatusData;
      
      public function ObjectData()
      {
         this.status_ = new ObjectStatusData();
         super();
      }
      
      public function parseFromInput(data:IDataInput) : void
      {
         this.objectType_ = data.readInt();
         this.status_.parseFromInput(data);
      }
      
      public function toString() : String
      {
         return "objectType_: " + this.objectType_ + " status_: " + this.status_;
      }
   }
}
