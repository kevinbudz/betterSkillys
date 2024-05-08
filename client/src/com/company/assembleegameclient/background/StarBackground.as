package com.company.assembleegameclient.background
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.AssetLibrary;
   import com.company.util.ImageSet;
   import com.company.util.PointUtil;
   import flash.display.IGraphicsData;
   
   public class StarBackground extends Background
   {
       
      
      public var stars_:Vector.<Star>;
      
      protected var graphicsData_:Vector.<IGraphicsData>;
      
      public function StarBackground()
      {
         this.stars_ = new Vector.<Star>();
         this.graphicsData_ = new Vector.<IGraphicsData>();
         super();
         for(var i:int = 0; i < 100; i++)
         {
            this.tryAddStar();
         }
      }
      
      override public function draw(camera:Camera, time:int) : void
      {
         var star:Star = null;
         this.graphicsData_.length = 0;
         for each(star in this.stars_)
         {
            star.draw(this.graphicsData_,camera,time);
         }
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function tryAddStar() : void
      {
         var star:Star = null;
         var starSet:ImageSet = AssetLibrary.getImageSet("stars");
         var newStar:Star = new Star(Math.random() * 1000 - 500,Math.random() * 1000 - 500,4 * (0.5 + 0.5 * Math.random()),starSet.images_[int(starSet.images_.length * Math.random())]);
         for each(star in this.stars_)
         {
            if(PointUtil.distanceXY(newStar.x_,newStar.y_,star.x_,star.y_) < 3)
            {
               return;
            }
         }
         this.stars_.push(newStar);
      }
   }
}

import com.company.assembleegameclient.map.Camera;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.IGraphicsData;
import flash.geom.Matrix;

class Star
{
   
   protected static const sqCommands:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
   
   protected static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
    
   
   public var x_:Number;
   
   public var y_:Number;
   
   public var scale_:Number;
   
   public var bitmap_:BitmapData;
   
   private var w_:Number;
   
   private var h_:Number;
   
   protected var bitmapFill_:GraphicsBitmapFill;
   
   protected var path_:GraphicsPath;
   
   function Star(x:Number, y:Number, scale:Number, bitmap:BitmapData)
   {
      this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),false,false);
      this.path_ = new GraphicsPath(sqCommands,new Vector.<Number>());
      super();
      this.x_ = x;
      this.y_ = y;
      this.scale_ = scale;
      this.bitmap_ = bitmap;
      this.w_ = this.bitmap_.width * this.scale_;
      this.h_ = this.bitmap_.height * this.scale_;
   }
   
   public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
   {
      var nx:Number = this.x_ * Math.cos(-camera.angleRad_) - this.y_ * Math.sin(-camera.angleRad_);
      var ny:Number = this.x_ * Math.sin(-camera.angleRad_) + this.y_ * Math.cos(-camera.angleRad_);
      var m:Matrix = this.bitmapFill_.matrix;
      m.identity();
      m.translate(-this.bitmap_.width / 2,-this.bitmap_.height / 2);
      m.scale(this.scale_,this.scale_);
      m.translate(nx,ny);
      this.bitmapFill_.bitmapData = this.bitmap_;
      this.path_.data.length = 0;
      var sx:Number = nx - this.w_ / 2;
      var sy:Number = ny - this.h_ / 2;
      this.path_.data.push(sx,sy,sx + this.w_,sy,sx + this.w_,sy + this.h_,sx,sy + this.h_);
      graphicsData.push(this.bitmapFill_);
      graphicsData.push(this.path_);
      graphicsData.push(END_FILL);
   }
}
