package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
import flash.utils.Dictionary;

public class Particle extends BasicObject
   {
      protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,null,false,false);
      protected var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
      protected var vS_:Vector.<Number>= new Vector.<Number>();
      protected var fillMatrix_:Matrix= new Matrix();

      public var size_:int;
      public var color_:uint;

      private var texture_:BitmapData;
      private var tW_:int;
      private var tH_:int;
      
      public function Particle(color:uint, z:Number, size:int)
      {
         super();
         objectId_ = getNextFakeObjectId();
         this.setZ(z);

         this.color_ = color; // So it doesn't call updateTexture() twice for no reason
         setSize(size);
      }
      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         var square:Square = null;
         square = map_.getSquare(x,y);
         if(square == null)
         {
            return false;
         }
         x_ = x;
         y_ = y;
         square_ = square;
         return true;
      }
      
      public function setColor(color:uint) : void
      {
         this.color_ = color;
         updateTexture();
      }
      
      public function setZ(z:Number) : void
      {
         z_ = z;
      }
      
      public function setSize(size:int) : void
      {
         this.size_ = size / 100 * 5;
         updateTexture();
      }

      private function updateTexture() : void
      {
         this.texture_ = TextureRedrawer.redrawSolidSquare(this.color_,this.size_);
         this.tW_ = this.texture_.width / 2;
         this.tH_ = this.texture_.height / 2;
      }

      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         this.vS_.length = 0;
         this.vS_.push(
                 posS_[3] - this.tW_,
                 posS_[4] - this.tH_,
                 posS_[3] + this.tW_,
                 posS_[4] - this.tH_,
                 posS_[3] + this.tW_,
                 posS_[4] + this.tH_,
                 posS_[3] - this.tW_,
                 posS_[4] + this.tH_);
         this.path_.data = this.vS_;
         this.bitmapFill_.bitmapData = this.texture_;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
   }
}
