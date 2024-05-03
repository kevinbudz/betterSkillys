package com.company.assembleegameclient.engine3d
{
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsBitmapFill;
import flash.geom.Matrix;
import flash.display.GraphicsSolidFill;
import flash.geom.Vector3D;
import com.company.util.Trig;
import com.company.assembleegameclient.parameters.Parameters;
import flash.display.IGraphicsData;
import flash.geom.Matrix3D;
import com.company.assembleegameclient.map.Camera;
import flash.display.BitmapData;

public class Point3D
{

   private static const commands_:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO];
   private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();

   private const data_:Vector.<Number> = new Vector.<Number>();
   private const path_:GraphicsPath = new GraphicsPath(commands_, data_);
   private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, new Matrix(), false, false);
   private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 1);

   public var size_:Number;
   public var posS_:Vector3D;
   private var n:Vector.<Number>;

   public function Point3D(_arg_1:Number)
   {
      this.size_ = _arg_1;
      this.n = new Vector.<Number>(16, true);
      this.posS_ = new Vector3D();
   }

   public function setSize(_arg_1:Number):void
   {
      this.size_ = _arg_1;
   }

   public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Vector3D, _arg_3:Number, _arg_4:Matrix3D, _arg_5:Camera, _arg_6:BitmapData, _arg_7:uint=0):void
   {
      var _local_8:Number = NaN;
      var _local_9:Number = NaN;
      var _local_10:Matrix;
      this.projectVector2posS(_arg_4, _arg_2);
      if (this.posS_.w < 0)
      {
         return;
      };
      var _local_11:Number = (this.posS_.w * Math.sin(((_arg_5.pp_.fieldOfView / 2) * Trig.toRadians)));
      var _local_12:Number = (this.size_ / _local_11);
      this.data_.length = 0;
      if (_arg_3 == 0)
      {
         this.data_.push((this.posS_.x - _local_12), (this.posS_.y - _local_12), (this.posS_.x + _local_12), (this.posS_.y - _local_12), (this.posS_.x + _local_12), (this.posS_.y + _local_12), (this.posS_.x - _local_12), (this.posS_.y + _local_12));
      }
      else
      {
         _local_8 = Math.cos(_arg_3);
         _local_9 = Math.sin(_arg_3);
         this.data_.push((this.posS_.x + ((_local_8 * -(_local_12)) + (_local_9 * -(_local_12)))), (this.posS_.y + ((_local_9 * -(_local_12)) - (_local_8 * -(_local_12)))), (this.posS_.x + ((_local_8 * _local_12) + (_local_9 * -(_local_12)))), (this.posS_.y + ((_local_9 * _local_12) - (_local_8 * -(_local_12)))), (this.posS_.x + ((_local_8 * _local_12) + (_local_9 * _local_12))), (this.posS_.y + ((_local_9 * _local_12) - (_local_8 * _local_12))), (this.posS_.x + ((_local_8 * -(_local_12)) + (_local_9 * _local_12))), (this.posS_.y + ((_local_9 * -(_local_12)) - (_local_8 * _local_12))));
      };
      if (_arg_6 != null)
      {
         this.bitmapFill_.bitmapData = _arg_6;
         _local_10 = this.bitmapFill_.matrix;
         _local_10.identity();
         if (!Parameters.data_.projOutline)
         {
            _local_10.scale(((2 * _local_12) / _arg_6.width), ((2 * _local_12) / _arg_6.height));
            _local_10.translate(-(_local_12), -(_local_12));
         }
         else
         {
            _local_10.translate(-(_arg_6.width / 2), -(_arg_6.height / 2));
         };
         _local_10.rotate(_arg_3);
         _local_10.translate(this.posS_.x, this.posS_.y);
         _arg_1.push(this.bitmapFill_);
      }
      else
      {
         this.solidFill_.color = _arg_7;
         _arg_1.push(this.solidFill_);
      };
      _arg_1.push(this.path_);
      _arg_1.push(END_FILL);
   }

   private function projectVector2posS(_arg_1:Matrix3D, _arg_2:Vector3D):void
   {
      _arg_1.copyRawDataTo(this.n);
      this.posS_.x = ((((_arg_2.x * this.n[0]) + (_arg_2.y * this.n[4])) + (_arg_2.z * this.n[8])) + this.n[12]);
      this.posS_.y = ((((_arg_2.x * this.n[1]) + (_arg_2.y * this.n[5])) + (_arg_2.z * this.n[9])) + this.n[13]);
      this.posS_.z = ((((_arg_2.x * this.n[2]) + (_arg_2.y * this.n[6])) + (_arg_2.z * this.n[10])) + this.n[14]);
      this.posS_.w = ((((_arg_2.x * this.n[3]) + (_arg_2.y * this.n[7])) + (_arg_2.z * this.n[11])) + this.n[15]);
      this.posS_.project();
   }


}
}//package com.company.assembleegameclient.engine3d