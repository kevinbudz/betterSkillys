package com.company.assembleegameclient.game
{
   import kabam.rotmg.messaging.impl.data.MoveRecord;
   
   public class MoveRecords
   {
       
      
      public var lastClearTime_:int = -1;
      
      public var records_:Vector.<MoveRecord>;
      
      public function MoveRecords()
      {
         this.records_ = new Vector.<MoveRecord>();
         super();
      }
      
      public function addRecord(time:int, x:Number, y:Number) : void
      {
         if(this.lastClearTime_ < 0)
         {
            return;
         }
         var id:int = this.getId(time);
         if(id < 1 || id > 10)
         {
            return;
         }
         if(this.records_.length == 0)
         {
            this.records_.push(new MoveRecord(time,x,y));
            return;
         }
         var currRecord:MoveRecord = this.records_[this.records_.length - 1];
         var currId:int = this.getId(currRecord.time_);
         if(id != currId)
         {
            this.records_.push(new MoveRecord(time, x, y));
            return;
         }

         var score:int = this.getScore(id,time);
         var currScore:int = this.getScore(id,currRecord.time_);
         if(score < currScore)
         {
            currRecord.time_ = time;
            currRecord.x_ = x;
            currRecord.y_ = y;
         }
      }
      
      private function getId(time:int) : int
      {
         return (time - this.lastClearTime_ + 50) / 100;
      }
      
      private function getScore(id:int, time:int) : int
      {
         return Math.abs(time - this.lastClearTime_ - id * 100);
      }
      
      public function clear(time:int) : void
      {
         this.records_.length = 0;
         this.lastClearTime_ = time;
      }
   }
}
