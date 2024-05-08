package com.company.assembleegameclient.util
{
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   
   public class MaskedImage
   {
       
      
      public var image_:BitmapData;
      
      public var mask_:BitmapData;
      
      public function MaskedImage(image:BitmapData, mask:BitmapData)
      {
         super();
         this.image_ = image;
         this.mask_ = mask;
      }
      
      public function width() : int
      {
         return this.image_.width;
      }
      
      public function height() : int
      {
         return this.image_.height;
      }
      
      public function mirror(width:int = 0) : MaskedImage
      {
         var mirroredImage:BitmapData = BitmapUtil.mirror(this.image_,width);
         var mirroredMask:BitmapData = this.mask_ == null?null:BitmapUtil.mirror(this.mask_,width);
         return new MaskedImage(mirroredImage,mirroredMask);
      }
      
      public function amountTransparent() : Number
      {
         return BitmapUtil.amountTransparent(this.image_);
      }
   }
}
