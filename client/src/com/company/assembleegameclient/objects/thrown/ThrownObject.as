package com.company.assembleegameclient.objects.thrown
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   
   public class ThrownObject extends BasicObject
   {
       
      
      protected var bitmapFill_:GraphicsBitmapFill;
      
      protected var path_:GraphicsPath;
      
      protected var vS_:Vector.<Number>;
      
      protected var fillMatrix_:Matrix;
      
      public var size_:int;
      
      private var _bitmapData:BitmapData;
      
      protected var _rotationDelta:Number = 0;
      
      private var _rotation:Number = 0;
      
      public function ThrownObject(z:Number, bitmapData:BitmapData)
      {
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
         this.vS_ = new Vector.<Number>();
         this.fillMatrix_ = new Matrix();
         super();
         hasShadow_ = false;
         objectId_ = getNextFakeObjectId();
         this._bitmapData = bitmapData;
         z_ = z;
      }
      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         var square:Square = map_.getSquare(x,y);
         if(!square)
         {
            return false;
         }
         x_ = x;
         y_ = y;
         square_ = square;
         return true;
      }
      
      public function setSize(size:int) : void
      {
         this.size_ = size / 100 * 5;
      }
      
      override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         trace("denied");
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var texture:BitmapData = this._bitmapData;
         var w:int = texture.width;
         var h:int = texture.height;
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] + h / 2,posS_[3] - w / 2,posS_[4] + h / 2);
         this.path_.data = this.vS_;
         this.bitmapFill_.bitmapData = texture;
         this.fillMatrix_.identity();
         if(this._rotationDelta)
         {
            this._rotation = this._rotation + this._rotationDelta;
            this.fillMatrix_.translate(-w / 2,-h / 2);
            this.fillMatrix_.rotate(this._rotation);
            this.fillMatrix_.translate(w / 2,h / 2);
         }
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
   }
}
