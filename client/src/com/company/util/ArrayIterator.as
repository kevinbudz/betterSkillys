package com.company.util
{
   public class ArrayIterator implements IIterator
   {
       
      
      private var objects_:Array;
      
      private var index_:int;
      
      public function ArrayIterator(objects:Array)
      {
         super();
         this.objects_ = objects;
         this.index_ = 0;
      }
      
      public function reset() : void
      {
         this.index_ = 0;
      }
      
      public function next() : Object
      {
         return this.objects_[this.index_++];
      }
      
      public function hasNext() : Boolean
      {
         return this.index_ < this.objects_.length;
      }
   }
}
