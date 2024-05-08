package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import com.company.util.Triangle;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Face3D
   {
      private static const blackOutFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);

      public var origTexture_:BitmapData;
      public var vin_:Vector.<Number>;
      public var uvt_:Vector.<Number>;
      public var vout_:Vector.<Number>;
      public var backfaceCull_:Boolean;
      public var shade_:Number = 1.0;
      public var blackOut_:Boolean = false;
      private var needGen_:Boolean = true;
      private var textureMatrix_:TextureMatrix = null;
      public var bitmapFill_:GraphicsBitmapFill= new GraphicsBitmapFill(null,null,false,false);
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),null);
      
      public function Face3D(texture:BitmapData, vin:Vector.<Number>, uvt:Vector.<Number>, backfaceCull:Boolean = false, shading:Boolean = false)
      {
         var normal:Vector3D = null;
         this.vout_ = new Vector.<Number>();
         super();
         this.origTexture_ = texture;
         this.vin_ = vin;
         this.uvt_ = uvt;
         this.backfaceCull_ = backfaceCull;
         if(shading)
         {
            normal = new Vector3D();
            Plane3D.computeNormalVec(vin,normal);
            this.shade_ = Lighting3D.shadeValue(normal,0.75);
         }
         this.path_.commands.push(GraphicsPathCommand.MOVE_TO);
         for(var v:int = 3; v < this.vin_.length; v = v + 3)
         {
            this.path_.commands.push(GraphicsPathCommand.LINE_TO);
         }
         this.path_.data = this.vout_;
      }
      
      public function dispose() : void
      {
         this.origTexture_ = null;
         this.vin_ = null;
         this.uvt_ = null;
         this.vout_ = null;
         this.textureMatrix_ = null;
         this.bitmapFill_ = null;
         this.path_.commands = null;
         this.path_.data = null;
         this.path_ = null;
      }
      
      public function setTexture(texture:BitmapData) : void
      {
         if(this.origTexture_ == texture)
         {
            return;
         }
         this.origTexture_ = texture;
         this.needGen_ = true;
      }
      
      public function setUVT(uvt:Vector.<Number>) : void
      {
         this.uvt_ = uvt;
         this.needGen_ = true;
      }
      
      public function maxY() : Number
      {
         var maxY:Number = -Number.MAX_VALUE;
         var len:int = this.vout_.length;
         for(var i:int = 0; i < len; i = i + 2)
         {
            if(this.vout_[i + 1] > maxY)
            {
               maxY = this.vout_[i + 1];
            }
         }
         return maxY;
      }
      
      public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera) : Boolean
      {
         var vS:Vector.<Number> = null;
         var ux:Number = NaN;
         var uy:Number = NaN;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var iplus1:int = 0;
         Utils3D.projectVectors(camera.wToS_,this.vin_,this.vout_,this.uvt_);
         if(this.backfaceCull_)
         {
            vS = this.vout_;
            ux = vS[2] - vS[0];
            uy = vS[3] - vS[1];
            vx = vS[4] - vS[0];
            vy = vS[5] - vS[1];
            if(ux * vy - uy * vx > 0)
            {
               return false;
            }
         }
         var minX:Number = camera.clipRect_.x - 10;
         var minY:Number = camera.clipRect_.y - 10;
         var maxX:Number = camera.clipRect_.right + 10;
         var maxY:Number = camera.clipRect_.bottom + 10;
         var clip:Boolean = true;
         var len:int = this.vout_.length;
         for(var i:int = 0; i < len; i = i + 2)
         {
            iplus1 = i + 1;
            if(this.vout_[i] >= minX && this.vout_[i] <= maxX && this.vout_[iplus1] >= minY && this.vout_[iplus1] <= maxY)
            {
               clip = false;
               break;
            }
         }
         if(clip)
         {
            return false;
         }
         if(this.blackOut_)
         {
            graphicsData.push(blackOutFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicsUtil.END_FILL);
            return true;
         }
         if(this.needGen_)
         {
            this.generateTextureMatrix();
         }
         this.textureMatrix_.calculateTextureMatrix(this.vout_);
         this.bitmapFill_.bitmapData = this.textureMatrix_.texture_;
         this.bitmapFill_.matrix = this.textureMatrix_.tToS_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
         return true;
      }
      
      public function contains(xS:Number, yS:Number) : Boolean
      {
         if(Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[2],this.vout_[3],this.vout_[4],this.vout_[5],xS,yS))
         {
            return true;
         }
         if(this.vout_.length == 8 && Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[4],this.vout_[5],this.vout_[6],this.vout_[7],xS,yS))
         {
            return true;
         }
         return false;
      }
      
      private function generateTextureMatrix() : void
      {
         var texture:BitmapData = TextureRedrawer.redrawFace(this.origTexture_,this.shade_);
         if(this.textureMatrix_ == null)
         {
            this.textureMatrix_ = new TextureMatrix(texture,this.uvt_);
         }
         else
         {
            this.textureMatrix_.texture_ = texture;
            this.textureMatrix_.calculateUVMatrix(this.uvt_);
         }
         this.needGen_ = false;
      }
   }
}
