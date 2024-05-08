package com.company.assembleegameclient.mapeditor
{
   public class METile
   {
       
      
      public var types_:Vector.<int>;
      
      public var objName_:String = null;
      
      public function METile()
      {
         this.types_ = new <int>[-1,-1,-1];
         super();
      }
      
      public function clone() : METile
      {
         var tile:METile = new METile();
         tile.types_ = this.types_.concat();
         tile.objName_ = this.objName_;
         return tile;
      }
      
      public function isEmpty() : Boolean
      {
         for(var l:int = 0; l < Layer.NUM_LAYERS; l++)
         {
            if(this.types_[l] != -1)
            {
               return false;
            }
         }
         return true;
      }
   }
}
