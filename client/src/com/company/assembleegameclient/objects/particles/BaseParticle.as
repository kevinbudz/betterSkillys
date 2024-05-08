package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   
   public class BaseParticle extends BasicObject
   {
       
      
      public var timeLeft:Number = 0;
      
      public var spdX:Number;
      
      public var spdY:Number;
      
      public var spdZ:Number;
      
      protected var vS_:Vector.<Number>;
      
      protected var fillMatrix_:Matrix;
      
      protected var path_:GraphicsPath;
      
      protected var bitmapFill_:GraphicsBitmapFill;
      
      public function BaseParticle(bitmapData:BitmapData)
      {
         this.vS_ = new Vector.<Number>(8);
         this.fillMatrix_ = new Matrix();
         this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         super();
         this.bitmapFill_.bitmapData = bitmapData;
         objectId_ = getNextFakeObjectId();
      }
      
      public function initialize(totalTime:Number, speedX:Number, speedY:Number, speedZ:Number, zPos:int) : void
      {
         this.timeLeft = totalTime;
         this.spdX = speedX;
         this.spdY = speedY;
         this.spdZ = speedZ;
         z_ = zPos;
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var halfW:Number = this.bitmapFill_.bitmapData.width / 2;
         var halfH:Number = this.bitmapFill_.bitmapData.height / 2;
         this.vS_[6] = this.vS_[0] = posS_[3] - halfW;
         this.vS_[3] = this.vS_[1] = posS_[4] - halfH;
         this.vS_[4] = this.vS_[2] = posS_[3] + halfW;
         this.vS_[7] = this.vS_[5] = posS_[4] + halfH;
         this.path_.data = this.vS_;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
      
      override public function removeFromMap() : void
      {
         map_ = null;
         square_ = null;
      }
   }
}
