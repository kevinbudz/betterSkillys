package com.company.assembleegameclient.engine3d
{
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.Trig;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

public class Point3D
{

   private static const commands_:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];

   private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();


   public var size_:Number;
   public var posS_:Vector3D;

   private var n:Vector.<Number>;

   private const data_:Vector.<Number> = new Vector.<Number>();
   private const path_:GraphicsPath = new GraphicsPath(commands_,data_);
   private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),false,false);
   private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);

   public function Point3D(size:Number)
   {
      super();
      this.size_ = size;
      this.n = new Vector.<Number>(16, true);
      this.posS_ = new Vector3D();
   }

   public function setSize(size:Number) : void
   {
      this.size_ = size;
   }

   public function draw(graphicsData:Vector.<IGraphicsData>, posL:Vector3D, angle:Number, lToS:Matrix3D, camera:Camera, bitmapData:BitmapData, color:uint = 0) : void
   {
      var ca:Number = NaN;
      var sa:Number = NaN;
      var m:Matrix = null;
      projectVector2posS(lToS, posL);
      if(this.posS_.w < 0)
      {
         return;
      }
      var o:Number = this.posS_.w * Math.sin(camera.pp_.fieldOfView / 2 * Trig.toRadians);
      var s:Number = this.size_ / o;
      this.data_.length = 0;
      if(angle == 0)
      {
         this.data_.push(this.posS_.x - s,this.posS_.y - s,this.posS_.x + s,this.posS_.y - s,this.posS_.x + s,this.posS_.y + s,this.posS_.x - s,this.posS_.y + s);
      }
      else
      {
         ca = Math.cos(angle);
         sa = Math.sin(angle);
         this.data_.push(this.posS_.x + (ca * -s + sa * -s),this.posS_.y + (sa * -s - ca * -s),this.posS_.x + (ca * s + sa * -s),this.posS_.y + (sa * s - ca * -s),this.posS_.x + (ca * s + sa * s),this.posS_.y + (sa * s - ca * s),this.posS_.x + (ca * -s + sa * s),this.posS_.y + (sa * -s - ca * s));
      }
      if(bitmapData != null)
      {
         this.bitmapFill_.bitmapData = bitmapData;
         m = this.bitmapFill_.matrix;
         m.identity();
         if (!Parameters.data_.projOutline) {
           m.scale(2 * s / bitmapData.width, 2 * s / bitmapData.height);
            m.translate(-s, -s);
         }
         else{
            m.translate(-(bitmapData.width / 2), -(bitmapData.height / 2));
         }
         m.rotate(angle);
         m.translate(this.posS_.x,this.posS_.y);
         graphicsData.push(this.bitmapFill_);
      }
      else
      {
         this.solidFill_.color = color;
         graphicsData.push(this.solidFill_);
      }
      graphicsData.push(this.path_);
      graphicsData.push(END_FILL);
   }

   private function projectVector2posS(m:Matrix3D, v:Vector3D):void {
      m.copyRawDataTo(n);
      posS_.x = v.x * n[0] + v.y * n[4] + v.z * n[8] + n[12];
      posS_.y = v.x * n[1] + v.y * n[5] + v.z * n[9] + n[13];
      posS_.z = v.x * n[2] + v.y * n[6] + v.z * n[10] + n[14];
      posS_.w = v.x * n[3] + v.y * n[7] + v.z * n[11] + n[15];
      posS_.project();
   }
}
}