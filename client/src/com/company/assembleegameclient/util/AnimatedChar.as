package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.Trig;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class AnimatedChar
   {
      
      public static const RIGHT:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const DOWN:int = 2;
      
      public static const UP:int = 3;
      
      public static const NUM_DIR:int = 4;
      
      public static const STAND:int = 0;
      
      public static const WALK:int = 1;
      
      public static const ATTACK:int = 2;
      
      public static const NUM_ACTION:int = 3;
      
      private static const SEC_TO_DIRS:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[LEFT,UP,DOWN],new <int>[UP,LEFT,DOWN],new <int>[UP,RIGHT,DOWN],new <int>[RIGHT,UP,DOWN],new <int>[RIGHT,DOWN],new <int>[DOWN,RIGHT],new <int>[DOWN,LEFT],new <int>[LEFT,DOWN]];
      
      private static const PIOVER4:Number = Math.PI / 4;
       
      
      public var origImage_:MaskedImage;
      
      public var width_:int;
      
      public var height_:int;
      
      public var firstDir_:int;
      
      private var dict_:Dictionary;
      
      public function AnimatedChar(image:MaskedImage, width:int, height:int, firstDir:int)
      {
         this.dict_ = new Dictionary();
         super();
         this.origImage_ = image;
         this.width_ = width;
         this.height_ = height;
         this.firstDir_ = firstDir;
         var classDict:Dictionary = new Dictionary();
         var frames:MaskedImageSet = new MaskedImageSet();
         frames.addFromMaskedImage(image,width,height);
         if(firstDir == RIGHT)
         {
            this.dict_[RIGHT] = this.loadDir(0,false,false,frames);
            this.dict_[LEFT] = this.loadDir(0,true,false,frames);
            if(frames.images_.length >= 14)
            {
               this.dict_[DOWN] = this.loadDir(7,false,true,frames);
               if(frames.images_.length >= 21)
               {
                  this.dict_[UP] = this.loadDir(14,false,true,frames);
               }
            }
         }
         else if(firstDir == DOWN)
         {
            this.dict_[DOWN] = this.loadDir(0,false,true,frames);
            if(frames.images_.length >= 14)
            {
               this.dict_[RIGHT] = this.loadDir(7,false,false,frames);
               this.dict_[LEFT] = this.loadDir(7,true,false,frames);
               if(frames.images_.length >= 21)
               {
                  this.dict_[UP] = this.loadDir(14,false,true,frames);
               }
            }
         }
         else
         {
            trace("ERROR: unsupported first dir: " + firstDir);
         }
      }
      
      public function getFirstDirImage() : BitmapData
      {
         var bd:BitmapData = new BitmapData(this.width_ * 7,this.height_,true,0);
         var actionDict:Dictionary = this.dict_[this.firstDir_];
         var vec:Vector.<MaskedImage> = actionDict[STAND];
         if(vec.length > 0)
         {
            bd.copyPixels(vec[0].image_,vec[0].image_.rect,new Point(0,0));
         }
         vec = actionDict[WALK];
         if(vec.length > 0)
         {
            bd.copyPixels(vec[0].image_,vec[0].image_.rect,new Point(this.width_,0));
         }
         if(vec.length > 1)
         {
            bd.copyPixels(vec[1].image_,vec[1].image_.rect,new Point(this.width_ * 2,0));
         }
         vec = actionDict[ATTACK];
         if(vec.length > 0)
         {
            bd.copyPixels(vec[0].image_,vec[0].image_.rect,new Point(this.width_ * 4,0));
         }
         if(vec.length > 1)
         {
            bd.copyPixels(vec[1].image_,new Rectangle(this.width_,0,this.width_ * 2,this.height_),new Point(this.width_ * 5,0));
         }
         return bd;
      }
      
      public function imageVec(dir:int, action:int) : Vector.<MaskedImage>
      {
         return this.dict_[dir][action];
      }
      
      public function imageFromDir(dir:int, action:int, p:Number) : MaskedImage
      {
         var texVec:Vector.<MaskedImage> = this.dict_[dir][action];
         p = Math.max(0,Math.min(0.99999,p));
         var i:int = p * texVec.length;
         return texVec[i];
      }
      
      public function imageFromAngle(angle:Number, action:int, p:Number) : MaskedImage
      {
         var sec:int = int(angle / PIOVER4 + 4) % 8;
         var dirs:Vector.<int> = SEC_TO_DIRS[sec];
         var actionDict:Dictionary = this.dict_[dirs[0]];
         if(actionDict == null)
         {
            actionDict = this.dict_[dirs[1]];
            if(actionDict == null)
            {
               actionDict = this.dict_[dirs[2]];
            }
         }
         var texVec:Vector.<MaskedImage> = actionDict[action];
         p = Math.max(0,Math.min(0.99999,p));
         var i:int = p * texVec.length;
         return texVec[i];
      }
      
      public function imageFromFacing(facing:Number, camera:Camera, action:int, p:Number) : MaskedImage
      {
         var ca:Number = Trig.boundToPI(facing - camera.angleRad_);
         var sec:int = int(ca / PIOVER4 + 4) % 8;
         var dirs:Vector.<int> = SEC_TO_DIRS[sec];
         var actionDict:Dictionary = this.dict_[dirs[0]];
         if(actionDict == null)
         {
            actionDict = this.dict_[dirs[1]];
            if(actionDict == null)
            {
               actionDict = this.dict_[dirs[2]];
            }
         }
         var texVec:Vector.<MaskedImage> = actionDict[action];
         p = Math.max(0,Math.min(0.99999,p));
         var i:int = p * texVec.length;
         return texVec[i];
      }
      
      private function loadDir(offset:int, mirror:Boolean, sym:Boolean, frames:MaskedImageSet) : Dictionary
      {
         var attackVec:Vector.<MaskedImage> = null;
         var image:BitmapData = null;
         var mask:BitmapData = null;
         var dirDict:Dictionary = new Dictionary();
         var standImage:MaskedImage = frames.images_[offset + 0];
         var walk1Image:MaskedImage = frames.images_[offset + 1];
         var walk2Image:MaskedImage = frames.images_[offset + 2];
         if(walk2Image.amountTransparent() == 1)
         {
            walk2Image = null;
         }
         var attack1Image:MaskedImage = frames.images_[offset + 4];
         var attack2Image:MaskedImage = frames.images_[offset + 5];
         if(attack1Image.amountTransparent() == 1)
         {
            attack1Image = null;
         }
         if(attack2Image.amountTransparent() == 1)
         {
            attack2Image = null;
         }
         var swordBitImage:MaskedImage = frames.images_[offset + 6];
         if(attack2Image != null && swordBitImage.amountTransparent() != 1)
         {
            image = new BitmapData(this.width_ * 3,this.height_,true,0);
            image.copyPixels(attack2Image.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
            image.copyPixels(swordBitImage.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
            mask = null;
            if(attack2Image.mask_ != null || swordBitImage.mask_ != null)
            {
               mask = new BitmapData(this.width_ * 3,this.height_,true,0);
            }
            if(attack2Image.mask_ != null)
            {
               mask.copyPixels(attack2Image.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
            }
            if(swordBitImage.mask_ != null)
            {
               mask.copyPixels(swordBitImage.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
            }
            attack2Image = new MaskedImage(image,mask);
         }
         var standVec:Vector.<MaskedImage> = new Vector.<MaskedImage>();
         standVec.push(!!mirror?standImage.mirror():standImage);
         dirDict[STAND] = standVec;
         var walkVec:Vector.<MaskedImage> = new Vector.<MaskedImage>();
         walkVec.push(!!mirror?walk1Image.mirror():walk1Image);
         if(walk2Image != null)
         {
            walkVec.push(!!mirror?walk2Image.mirror():walk2Image);
         }
         else if(sym)
         {
            walkVec.push(!mirror?walk1Image.mirror(7):walk1Image);
         }
         else
         {
            walkVec.push(!!mirror?standImage.mirror():standImage);
         }
         dirDict[WALK] = walkVec;
         if(attack1Image == null && attack2Image == null)
         {
            attackVec = walkVec;
         }
         else
         {
            attackVec = new Vector.<MaskedImage>();
            if(attack1Image != null)
            {
               attackVec.push(!!mirror?attack1Image.mirror():attack1Image);
            }
            if(attack2Image != null)
            {
               attackVec.push(!!mirror?attack2Image.mirror():attack2Image);
            }
         }
         dirDict[ATTACK] = attackVec;
         return dirDict;
      }
      public function getHeight():int {
         return (this.height_);
      }
   }
}
