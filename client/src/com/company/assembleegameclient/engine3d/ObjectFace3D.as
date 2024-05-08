package com.company.assembleegameclient.engine3d
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.GraphicsUtil;
import com.company.util.MoreColorUtil;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Vector3D;
import kabam.rotmg.stage3D.GraphicsFillExtra;

public class ObjectFace3D
{

   public static const blackBitmap:BitmapData = new BitmapData(1,1,true,4278190080);


   public var obj_:Object3D;

   public var indices_:Vector.<int>;

   public var useTexture_:Boolean;

   public var texture_:BitmapData = null;

   public var normalL_:Vector3D = null;

   public var normalW_:Vector3D;

   public var shade_:Number = 1.0;

   private var path_:GraphicsPath;

   private var solidFill_:GraphicsSolidFill;

   public const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill();

   private var tToS_:Matrix;

   private var tempMatrix_:Matrix;

   public function ObjectFace3D(obj:Object3D, indices:Vector.<int>, useTexture:Boolean = true)
   {
      this.solidFill_ = new GraphicsSolidFill(16777215,1);
      this.tToS_ = new Matrix();
      this.tempMatrix_ = new Matrix();
      super();
      this.obj_ = obj;
      this.indices_ = indices;
      this.useTexture_ = useTexture;
      var commands:Vector.<int> = new Vector.<int>();
      for(var i:int = 0; i < this.indices_.length; i++)
      {
         commands.push(i == 0?GraphicsPathCommand.MOVE_TO:GraphicsPathCommand.LINE_TO);
      }
      var data:Vector.<Number> = new Vector.<Number>();
      data.length = this.indices_.length * 2;
      this.path_ = new GraphicsPath(commands,data);
   }

   public function dispose() : void
   {
      this.indices_ = null;
      this.path_.commands = null;
      this.path_.data = null;
      this.path_ = null;
   }

   public function computeLighting() : void
   {
      this.normalW_ = new Vector3D();
      Plane3D.computeNormal(this.obj_.getVecW(this.indices_[0]),this.obj_.getVecW(this.indices_[1]),this.obj_.getVecW(this.indices_[this.indices_.length - 1]),this.normalW_);
      this.shade_ = Lighting3D.shadeValue(this.normalW_,0.75);
      if(this.normalL_ != null)
      {
         this.normalW_ = this.obj_.lToW_.deltaTransformVector(this.normalL_);
      }
   }

   public function draw(graphicsData:Vector.<IGraphicsData>, color:uint, texture:BitmapData) : void
   {
      var ind:int = 0;
      var i0:int = this.indices_[0] * 2;
      var i1:int = this.indices_[1] * 2;
      var i2:int = this.indices_[this.indices_.length - 1] * 2;
      var vS:Vector.<Number> = this.obj_.vS_;
      var ux:Number = vS[i1] - vS[i0];
      var uy:Number = vS[i1 + 1] - vS[i0 + 1];
      var vx:Number = vS[i2] - vS[i0];
      var vy:Number = vS[i2 + 1] - vS[i0 + 1];
      if(ux * vy - uy * vx < 0)
      {
         return;
      }
      if(!Parameters.data_.GPURender && (!this.useTexture_ || texture == null))
      {
         this.solidFill_.color = MoreColorUtil.transformColor(new ColorTransform(this.shade_,this.shade_,this.shade_),color);
         graphicsData.push(this.solidFill_);
      }
      else
      {
         if(texture == null && Parameters.data_.GPURender)
         {
            texture = blackBitmap;
         }
         else
         {
            texture = TextureRedrawer.redrawFace(texture,this.shade_);
         }
         this.bitmapFill_.bitmapData = texture;
         this.bitmapFill_.matrix = this.tToS(texture);
         graphicsData.push(this.bitmapFill_);
      }
      for(var i:int = 0; i < this.indices_.length; i++)
      {
         ind = this.indices_[i];
         this.path_.data[i * 2] = vS[ind * 2];
         this.path_.data[i * 2 + 1] = vS[ind * 2 + 1];
      }
      graphicsData.push(this.path_);
      graphicsData.push(GraphicsUtil.END_FILL);
      /*if(Parameters.isGpuRender() && this.bitmapFill_ != null)
      {
         GraphicsFillExtra.setSoftwareDraw(this.bitmapFill_,true);
      }*/
   }

   private function tToS(texture:BitmapData) : Matrix
   {
      var uvts:Vector.<Number> = this.obj_.uvts_;
      var i0:int = this.indices_[0] * 3;
      var i1:int = this.indices_[1] * 3;
      var i2:int = this.indices_[this.indices_.length - 1] * 3;
      var uv0x:Number = uvts[i0] * texture.width;
      var uv0y:Number = uvts[i0 + 1] * texture.height;
      this.tToS_.a = uvts[i1] * texture.width - uv0x;
      this.tToS_.b = uvts[i1 + 1] * texture.height - uv0y;
      this.tToS_.c = uvts[i2] * texture.width - uv0x;
      this.tToS_.d = uvts[i2 + 1] * texture.height - uv0y;
      this.tToS_.tx = uv0x;
      this.tToS_.ty = uv0y;
      this.tToS_.invert();
      i0 = this.indices_[0] * 2;
      i1 = this.indices_[1] * 2;
      i2 = this.indices_[this.indices_.length - 1] * 2;
      var vS:Vector.<Number> = this.obj_.vS_;
      this.tempMatrix_.a = vS[i1] - vS[i0];
      this.tempMatrix_.b = vS[i1 + 1] - vS[i0 + 1];
      this.tempMatrix_.c = vS[i2] - vS[i0];
      this.tempMatrix_.d = vS[i2 + 1] - vS[i0 + 1];
      this.tempMatrix_.tx = vS[i0];
      this.tempMatrix_.ty = vS[i0 + 1];
      this.tToS_.concat(this.tempMatrix_);
      return this.tToS_;
   }
}
}
