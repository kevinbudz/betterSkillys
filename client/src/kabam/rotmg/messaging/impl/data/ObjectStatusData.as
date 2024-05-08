package kabam.rotmg.messaging.impl.data
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ObjectStatusData
   {
       
      
      public var objectId_:int;
      
      public var pos_:WorldPosData;
      
      public var stats_:Vector.<StatData>;
      
      public function ObjectStatusData()
      {
         this.pos_ = new WorldPosData();
         this.stats_ = new Vector.<StatData>();
         super();
      }
      
      public function parseFromInput(data:IDataInput) : void
      {
         this.objectId_ = data.readInt();
         this.pos_.parseFromInput(data);
         var len:int = data.readShort();
         var s:int;
         for(s = len; s < this.stats_.length; s++)
         {
            FreeList.deleteObject(this.stats_[s]);
         }
         this.stats_.length = Math.min(len,this.stats_.length);
         while(this.stats_.length < len)
         {
            this.stats_.push(FreeList.newObject(StatData) as StatData);
         }
         for(s = 0; s < len; s++)
         {
            this.stats_[s].parseFromInput(data);
         }
      }
      
      public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.objectId_);
         this.pos_.writeToOutput(data);
         data.writeShort(this.stats_.length);
         for(var s:int = 0; s < this.stats_.length; s++)
         {
            this.stats_[s].writeToOutput(data);
         }
      }
      
      public function toString() : String
      {
         return "objectId_: " + this.objectId_ + " pos_: " + this.pos_ + " stats_: " + this.stats_;
      }
   }
}
