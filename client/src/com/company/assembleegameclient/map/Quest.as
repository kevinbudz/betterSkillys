package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.utils.getTimer;
   
   public class Quest
   {
      public var map_:Map;
      
      public var objectId_:int = -1;
      
      private var questAvailableAt_:int = 0;
      
      private var questOldAt_:int = 0;
      
      public function Quest(map:Map)
      {
         super();
         this.map_ = map;
      }
      
      public function setObject(objectId:int) : void
      {
         if(this.objectId_ == -1 && objectId != -1)
         {
            this.questAvailableAt_ = getTimer() + 200;
            this.questOldAt_ = this.questAvailableAt_;
         }
         this.objectId_ = objectId;
      }
      
      public function completed() : void
      {
         this.questAvailableAt_ = getTimer() + 200;
         this.questOldAt_ = this.questAvailableAt_;
      }
      
      public function getObject(time:int) : GameObject
      {
         if(time < this.questAvailableAt_)
         {
            return null;
         }
         return this.map_.goDict_[this.objectId_];
      }
      
      public function isNew(time:int) : Boolean
      {
         return time < this.questOldAt_;
      }
   }
}
