package com.company.assembleegameclient.engine3d
{
   public class ModelFace3D
   {
       
      
      public var model_:Model3D;
      
      public var indicies_:Vector.<int>;
      
      public var useTexture_:Boolean;
      
      public function ModelFace3D(model:Model3D, indicies:Vector.<int>, useTexture:Boolean)
      {
         super();
         this.model_ = model;
         this.indicies_ = indicies;
         this.useTexture_ = useTexture;
      }
      
      public static function compare(f1:ModelFace3D, f2:ModelFace3D) : Number
      {
         var val:Number = NaN;
         var i:int = 0;
         var minZ1:Number = Number.MAX_VALUE;
         var maxZ1:Number = Number.MIN_VALUE;
         for(i = 0; i < f1.indicies_.length; i++)
         {
            val = f2.model_.vL_[f1.indicies_[i] * 3 + 2];
            minZ1 = val < minZ1?Number(val):Number(minZ1);
            maxZ1 = val > maxZ1?Number(val):Number(maxZ1);
         }
         var minZ2:Number = Number.MAX_VALUE;
         var maxZ2:Number = Number.MIN_VALUE;
         for(i = 0; i < f2.indicies_.length; i++)
         {
            val = f2.model_.vL_[f2.indicies_[i] * 3 + 2];
            minZ2 = val < minZ2?Number(val):Number(minZ2);
            maxZ2 = val > maxZ2?Number(val):Number(maxZ2);
         }
         if(minZ2 > minZ1)
         {
            return -1;
         }
         if(minZ2 < minZ1)
         {
            return 1;
         }
         if(maxZ2 > maxZ1)
         {
            return -1;
         }
         if(maxZ2 < maxZ1)
         {
            return 1;
         }
         return 0;
      }
   }
}
