package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.engine3d.TextureMatrix;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.TileRedrawer;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Vector3D;
   
   public class Square
   {
      
      public static const UVT:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
      
      private static const LOOKUP:Vector.<int> = new <int>[26171,44789,20333,70429,98257,59393,33961];
       
      
      public var map_:Map;
      
      public var x_:int;
      
      public var y_:int;
      
      public var tileType_:uint = 255;
      
      public var center_:Vector3D;
      
      public var vin_:Vector.<Number>;
      
      public var obj_:GameObject = null;
      
      public var props_:GroundProperties;
      
      public var texture_:BitmapData = null;
      
      public var sink_:int = 0;
      
      public var lastDamage_:int = 0;
      
      public var faces_:Vector.<SquareFace>;
      
      public var topFace_:SquareFace = null;
      
      public var baseTexMatrix_:TextureMatrix = null;
      
      public var lastVisible_:int;
      
      public function Square(map:Map, x:int, y:int)
      {
         this.props_ = GroundLibrary.defaultProps_;
         this.faces_ = new Vector.<SquareFace>();
         super();
         this.map_ = map;
         this.x_ = x;
         this.y_ = y;
         this.center_ = new Vector3D(this.x_ + 0.5,this.y_ + 0.5,0);
         this.vin_ = new <Number>[this.x_,this.y_,0,this.x_ + 1,this.y_,0,this.x_ + 1,this.y_ + 1,0,this.x_,this.y_ + 1,0];
      }
      
      private static function hash(x:int, y:int) : int
      {
         var l:int = LOOKUP[(x + y) % 7];
         var val:int = (x << 16 | y) ^ 81397550;
         val = val * l % 65535;
         return val;
      }
      
      public function dispose() : void
      {
         var squareFace:SquareFace = null;
         this.map_ = null;
         this.center_ = null;
         this.vin_ = null;
         this.obj_ = null;
         this.texture_ = null;
         for each(squareFace in this.faces_)
         {
            squareFace.dispose();
         }
         this.faces_.length = 0;
         if(this.topFace_ != null)
         {
            this.topFace_.dispose();
            this.topFace_ = null;
         }
         this.faces_ = null;
         this.baseTexMatrix_ = null;
      }
      
      public function setTileType(tileType:uint) : void
      {
         this.tileType_ = tileType;
         this.props_ = GroundLibrary.propsLibrary_[this.tileType_];
         this.texture_ = GroundLibrary.getBitmapData(this.tileType_,hash(this.x_,this.y_));
         this.baseTexMatrix_ = new TextureMatrix(this.texture_,UVT);
         this.faces_.length = 0;
      }
      
      public function isWalkable() : Boolean
      {
         return !this.props_.noWalk_ && (this.obj_ == null || !this.obj_.props_.occupySquare_);
      }
      
      public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var face:SquareFace = null;
         if(this.texture_ == null)
         {
            return;
         }
         if(this.faces_.length == 0)
         {
            this.rebuild3D();
         }
         for each(face in this.faces_)
         {
            if(!face.draw(graphicsData,camera,time))
            {
               if(face.face_.vout_[1] < camera.clipRect_.bottom)
               {
                  this.lastVisible_ = 0;
               }
               return;
            }
         }
      }
      
      public function drawTop(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         this.topFace_.draw(graphicsData,camera,time);
      }
      
      private function rebuild3D() : void
      {
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var texture:BitmapData = null;
         var topVIN:Vector.<Number> = null;
         var i:uint = 0;
         this.faces_.length = 0;
         this.topFace_ = null;
         var redrawnTexture:BitmapData = null;
         if(this.props_.animate_.type_ != AnimateProperties.NO_ANIMATE)
         {
            this.faces_.push(new SquareFace(this.texture_,this.vin_,this.props_.xOffset_,this.props_.xOffset_,this.props_.animate_.type_,this.props_.animate_.dx_,this.props_.animate_.dy_));
            redrawnTexture = TileRedrawer.redraw(this,false);
            if(redrawnTexture != null)
            {
               this.faces_.push(new SquareFace(redrawnTexture,this.vin_,0,0,AnimateProperties.NO_ANIMATE,0,0));
            }
         }
         else
         {
            redrawnTexture = TileRedrawer.redraw(this,true);
            xOffset = 0;
            yOffset = 0;
            if(redrawnTexture == null)
            {
               if(this.props_.randomOffset_)
               {
                  xOffset = int(this.texture_.width * Math.random()) / this.texture_.width;
                  yOffset = int(this.texture_.height * Math.random()) / this.texture_.height;
               }
               else
               {
                  xOffset = this.props_.xOffset_;
                  yOffset = this.props_.yOffset_;
               }
            }
            this.faces_.push(new SquareFace(redrawnTexture != null?redrawnTexture:this.texture_,this.vin_,xOffset,yOffset,AnimateProperties.NO_ANIMATE,0,0));
         }
         if(this.props_.sink_)
         {
            this.sink_ = redrawnTexture == null?int(12):int(6);
         }
         else
         {
            this.sink_ = 0;
         }
         if(this.props_.topTD_)
         {
            texture = this.props_.topTD_.getTexture();
            topVIN = this.vin_.concat();
            for(i = 2; i < topVIN.length; i = i + 3)
            {
               topVIN[i] = 1;
            }
            this.topFace_ = new SquareFace(texture,topVIN,0,0,this.props_.topAnimate_.type_,this.props_.topAnimate_.dx_,this.props_.topAnimate_.dy_);
         }
      }
   }
}
