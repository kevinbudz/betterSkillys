package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Face3D;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   
   public class Wall extends GameObject
   {
      
      private static const UVT:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
      
      private static const sqX:Vector.<int> = new <int>[0,1,0,-1];
      
      private static const sqY:Vector.<int> = new <int>[-1,0,1,0];
       
      
      public var faces_:Vector.<Face3D>;
      
      private var topFace_:Face3D = null;
      
      private var topTexture_:BitmapData = null;
      
      public function Wall(objectXML:XML)
      {
         this.faces_ = new Vector.<Face3D>();
         super(objectXML);
         hasShadow_ = false;
         var topTextureData:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
         this.topTexture_ = topTextureData.getTexture(0);
      }
      
      override public function setObjectId(objectId:int) : void
      {
         super.setObjectId(objectId);
         var topTextureData:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
         this.topTexture_ = topTextureData.getTexture(objectId);
      }
      
      override public function getColor() : uint
      {
         return BitmapUtil.mostCommonColor(this.topTexture_);
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var animTexture:BitmapData = null;
         var face:Face3D = null;
         var sq:Square = null;
         if(texture_ == null)
         {
            return;
         }
         if(this.faces_.length == 0)
         {
            this.rebuild3D();
         }
         var texture:BitmapData = texture_;
         if(animations_ != null)
         {
            animTexture = animations_.getTexture(time);
            if(animTexture != null)
            {
               texture = animTexture;
            }
         }
         for(var f:int = 0; f < this.faces_.length; f++)
         {
            face = this.faces_[f];
            sq = map_.lookupSquare(x_ + sqX[f],y_ + sqY[f]);
            if(sq == null || sq.texture_ == null || sq != null && sq.obj_ is Wall && !sq.obj_.dead_)
            {
               face.blackOut_ = true;
            }
            else
            {
               face.blackOut_ = false;
               if(animations_ != null)
               {
                  face.setTexture(texture);
               }
            }
            face.draw(graphicsData,camera);
         }
         this.topFace_.draw(graphicsData,camera);
      }
      
      public function rebuild3D() : void
      {
         this.faces_.length = 0;
         var xi:int = x_;
         var yi:int = y_;
         var vin:Vector.<Number> = new <Number>[xi,yi,1,xi + 1,yi,1,xi + 1,yi + 1,1,xi,yi + 1,1];
         this.topFace_ = new Face3D(this.topTexture_,vin,UVT,false,true);
         this.topFace_.bitmapFill_.repeat = true;
         this.addWall(xi,yi,1,xi + 1,yi,1);
         this.addWall(xi + 1,yi,1,xi + 1,yi + 1,1);
         this.addWall(xi + 1,yi + 1,1,xi,yi + 1,1);
         this.addWall(xi,yi + 1,1,xi,yi,1);
      }
      
      private function addWall(x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number) : void
      {
         var vin:Vector.<Number> = new <Number>[x0,y0,z0,x1,y1,z1,x1,y1,z1 - 1,x0,y0,z0 - 1];
         var face:Face3D = new Face3D(texture_,vin,UVT,true,true);
         face.bitmapFill_.repeat = true;
         this.faces_.push(face);
      }
   }
}
