package com.company.assembleegameclient.map
{
import com.company.assembleegameclient.engine3d.Face3D;
import com.company.assembleegameclient.parameters.Parameters;
import flash.display.BitmapData;
import flash.display.IGraphicsData;
import kabam.rotmg.stage3D.GraphicsFillExtra;

public class SquareFace
{


   public var animate_:int;

   public var face_:Face3D;

   public var xOffset_:Number = 0;

   public var yOffset_:Number = 0;

   public var animateDx_:Number = 0;

   public var animateDy_:Number = 0;

   public function SquareFace(texture:BitmapData, vin:Vector.<Number>, xOffset:Number, yOffset:Number, animate:int, animateDx:Number, animateDy:Number)
   {
      super();
      this.face_ = new Face3D(texture,vin,Square.UVT.concat());
      this.xOffset_ = xOffset;
      this.yOffset_ = yOffset;
      if(this.xOffset_ != 0 || this.yOffset_ != 0)
      {
         this.face_.bitmapFill_.repeat = true;
      }
      this.animate_ = animate;
      if(this.animate_ != AnimateProperties.NO_ANIMATE)
      {
         this.face_.bitmapFill_.repeat = true;
      }
      this.animateDx_ = animateDx;
      this.animateDy_ = animateDy;
   }

   public function dispose() : void
   {
      this.face_.dispose();
      this.face_ = null;
   }

   public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : Boolean
   {
      var xOffset:Number = NaN;
      var yOffset:Number = NaN;
      if(this.animate_ != AnimateProperties.NO_ANIMATE)
      {
         switch(this.animate_)
         {
            case AnimateProperties.WAVE_ANIMATE:
               xOffset = this.xOffset_ + Math.sin(this.animateDx_ * time / 1000);
               yOffset = this.yOffset_ + Math.sin(this.animateDy_ * time / 1000);
               break;
            case AnimateProperties.FLOW_ANIMATE:
               xOffset = this.xOffset_ + this.animateDx_ * time / 1000;
               yOffset = this.yOffset_ + this.animateDy_ * time / 1000;
         }
      }
      else
      {
         xOffset = this.xOffset_;
         yOffset = this.yOffset_;
      }
      if(Parameters.isGpuRender())
      {
         GraphicsFillExtra.setOffsetUV(this.face_.bitmapFill_,xOffset,yOffset);
         xOffset = yOffset = 0;
      }
      this.face_.uvt_.length = 0;
      this.face_.uvt_.push(xOffset,yOffset,0,1 + xOffset,yOffset,0,1 + xOffset,1 + yOffset,0,xOffset,1 + yOffset,0);
      this.face_.setUVT(this.face_.uvt_);
      return this.face_.draw(graphicsData,camera);
   }
}
}
