package com.company.assembleegameclient.background
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class NexusBackground extends Background
   {
      
      public static const MOVEMENT:Point = new Point(0.01,0.01);
       
      
      private var water_:BitmapData;
      
      private var islands_:Vector.<Island>;
      
      protected var graphicsData_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
      
      private var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),true,false);
      
      private var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
      
      public function NexusBackground()
      {
         this.islands_ = new Vector.<Island>();
         super();
         this.water_ = new BitmapData(1024,1024,false,0);
         this.water_.perlinNoise(1024,1024,8,Math.random(),true,true,BitmapDataChannel.BLUE,false,null);
      }
      
      override public function draw(camera:Camera, time:int) : void
      {
         this.graphicsData_.length = 0;
         var m:Matrix = this.bitmapFill_.matrix;
         m.identity();
         m.translate(time * MOVEMENT.x,time * MOVEMENT.y);
         m.rotate(-camera.angleRad_);
         this.bitmapFill_.bitmapData = this.water_;
         this.graphicsData_.push(this.bitmapFill_);
         this.path_.data.length = 0;
         var r:Rectangle = camera.clipRect_;
         this.path_.data.push(r.left,r.top,r.right,r.top,r.right,r.bottom,r.left,r.bottom);
         this.graphicsData_.push(this.path_);
         this.graphicsData_.push(GraphicsUtil.END_FILL);
         this.drawIslands(camera,time);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function drawIslands(camera:Camera, time:int) : void
      {
         var island:Island = null;
         for(var i:int = 0; i < this.islands_.length; i++)
         {
            island = this.islands_[i];
            island.draw(camera,time,this.graphicsData_);
         }
      }
   }
}

import com.company.assembleegameclient.background.NexusBackground;
import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

class Island
{
    
   
   public var center_:Point;
   
   public var startTime_:int;
   
   public var bitmapData_:BitmapData;
   
   private var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),true,false);
   
   private var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
   
   function Island(x:Number, y:Number, startTime:int)
   {
      super();
      this.center_ = new Point(x,y);
      this.startTime_ = startTime;
      this.bitmapData_ = AssetLibrary.getImage("stars");
   }
   
   public function draw(camera:Camera, time:int, graphicsData:Vector.<IGraphicsData>) : void
   {
      var dt:int = time - this.startTime_;
      var x:Number = this.center_.x + dt * NexusBackground.MOVEMENT.x;
      var y:Number = this.center_.y + dt * NexusBackground.MOVEMENT.y;
      var m:Matrix = this.bitmapFill_.matrix;
      m.identity();
      m.translate(x,y);
      m.rotate(-camera.angleRad_);
      this.bitmapFill_.bitmapData = this.bitmapData_;
      graphicsData.push(this.bitmapFill_);
      this.path_.data.length = 0;
      var topLeft:Point = m.transformPoint(new Point(x,y));
      var bottomRight:Point = m.transformPoint(new Point(x + this.bitmapData_.width,y + this.bitmapData_.height));
      this.path_.data.push(topLeft.x,topLeft.y,bottomRight.x,topLeft.y,bottomRight.x,bottomRight.y,topLeft.x,bottomRight.y);
      graphicsData.push(this.path_);
      graphicsData.push(GraphicsUtil.END_FILL);
   }
}
