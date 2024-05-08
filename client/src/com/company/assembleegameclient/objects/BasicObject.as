package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Square;
   import flash.display.IGraphicsData;

import kabam.rotmg.stage3D.Object3D.Object3DStage3D;

public class BasicObject
   {
      private static var nextFakeObjectId_:int = 0;

      public var map_:Map;
      public var square_:Square;
      public var objectId_:int;
      public var x_:Number;
      public var y_:Number;
      public var z_:Number;
      public var hasShadow_:Boolean;
      public var drawn_:Boolean;
      public var posW_:Vector.<Number>;
      public var posS_:Vector.<Number>;
      public var sortVal_:int;
      
      public function BasicObject()
      {
         this.posW_ = new Vector.<Number>();
         this.posS_ = new Vector.<Number>();
         super();
         this.clear();
      }
      
      public static function getNextFakeObjectId() : int
      {
         return 0x7F000000 | nextFakeObjectId_++;
      }
      
      public function clear() : void
      {
         this.map_ = null;
         this.square_ = null;
         this.objectId_ = -1;
         this.x_ = 0;
         this.y_ = 0;
         this.z_ = 0;
         this.hasShadow_ = false;
         this.drawn_ = false;
         this.posW_.length = 0;
         this.posS_.length = 0;
         this.sortVal_ = 0;
      }
      
      public function dispose() : void
      {
         this.map_ = null;
         this.square_ = null;
         this.posW_ = null;
         this.posS_ = null;
      }
      
      public function update(time:int, dt:int) : Boolean
      {
         return true;
      }
      
      public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
      }

      public function draw3d(graphicsData3d:Vector.<Object3DStage3D>) : void
      {
      }

      public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
      }
      
      public function computeSortVal(camera:Camera) : void
      {
         this.posW_.length = 0;
         this.posW_.push(this.x_,this.y_,0,this.x_,this.y_,this.z_);
         this.posS_.length = 0;
         camera.wToS_.transformVectors(this.posW_,this.posS_);
         this.sortVal_ = int(this.posS_[1]);
      }
      
      public function addTo(map:Map, x:Number, y:Number) : Boolean
      {
         this.map_ = map;
         this.square_ = this.map_.getSquare(x,y);
         if(this.square_ == null)
         {
            this.map_ = null;
            return false;
         }
         this.x_ = x;
         this.y_ = y;
         return true;
      }
      
      public function removeFromMap() : void
      {
         this.map_ = null;
         this.square_ = null;
      }
   }
}
