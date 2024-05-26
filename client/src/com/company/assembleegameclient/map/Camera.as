package com.company.assembleegameclient.map
{
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.util.Trig;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class Camera
{

   public static const lN_:Vector3D = new Vector3D(0,0,1);
   public static var CENTER_SCREEN_RECT:Rectangle = new Rectangle(-300,-325,600,600);
   public static var OFFSET_SCREEN_RECT:Rectangle = new Rectangle(-300,-450,600,600);

   public var x_:Number;
   public var y_:Number;
   public var z_:Number;
   public var angleRad_:Number;
   public var clipRect_:Rectangle;
   public var pp_:PerspectiveProjection;
   public var maxDist_:Number;
   public var maxDistSq_:Number;
   public var isHallucinating_:Boolean = false;
   public var wToS_:Matrix3D;
   public var wToV_:Matrix3D;
   public var vToS_:Matrix3D;
   public var ppMatrix_:Matrix3D;
   private var nonPPMatrix_:Matrix3D;
   private var p_:Vector3D;
   private var f_:Vector3D;
   private var u_:Vector3D;
   private var r_:Vector3D;
   private var isJittering_:Boolean = false;
   private var jitter_:Number = 0;
   private const MAX_JITTER:Number = 0.5;
   private const JITTER_BUILDUP_MS:int = 10000;
   private var rd_:Vector.<Number>;

   public function Camera()
   {
      this.pp_ = new PerspectiveProjection();
      this.wToS_ = new Matrix3D();
      this.wToV_ = new Matrix3D();
      this.vToS_ = new Matrix3D();
      this.nonPPMatrix_ = new Matrix3D();
      this.p_ = new Vector3D();
      this.f_ = new Vector3D();
      this.u_ = new Vector3D();
      this.r_ = new Vector3D();
      this.rd_ = new Vector.<Number>(16,true);
      super();
      this.pp_.focalLength = 3;
      this.pp_.fieldOfView = 48;
      this.ppMatrix_ = this.pp_.toMatrix3D();
      this.nonPPMatrix_.appendScale(50,50,50);
      this.f_.x = 0;
      this.f_.y = 0;
      this.f_.z = -1;
   }

   public static function adjustDimensions() : void
   {
      var mscale:Number = Parameters.data_.mscale;
      var scaleW:Number = WebMain.sWidth / mscale;
      var scaleH:Number = WebMain.sHeight / mscale;
      var p:Number = Number(scaleH / 3);
      CENTER_SCREEN_RECT = new Rectangle((p - scaleW) / 2,-scaleH * 13 / 24,scaleW,scaleH);
      OFFSET_SCREEN_RECT = new Rectangle((p - scaleW) / 2,-scaleH * 3 / 4,scaleW,scaleH);
   }

   public function configureCamera(object:GameObject, isHallucinating:Boolean) : void
   {
      var screenRect:Rectangle = this.correctViewingArea(Parameters.data_.centerOnPlayer);
      var cameraAngle:Number = Parameters.data_.cameraAngle;
      this.configure(object.x_,object.y_,12,cameraAngle,screenRect,false);
      this.isHallucinating_ = isHallucinating;
   }

   public function correctViewingArea(center:Boolean):Rectangle
   {
      var mscale:Number;
      var sWidth:Number;
      var sHeight:Number;
      var result:Number;
      mscale = Parameters.data_.mscale;
      sWidth = (WebMain.sWidth / mscale);
      sHeight = (WebMain.sHeight / mscale);
      result = ((Parameters.data_.uiscale) ? Number((((200 * WebMain.sHeight) / 600) / mscale)) : Number((200 / mscale)));
      if (center)
      {
         return CENTER_SCREEN_RECT;
      }
      return OFFSET_SCREEN_RECT;
   }

   public function startJitter() : void
   {
      this.isJittering_ = true;
      this.jitter_ = 0;
   }

   public function update(dt:Number) : void
   {
      if(this.isJittering_ && this.jitter_ < this.MAX_JITTER)
      {
         this.jitter_ = this.jitter_ + dt * this.MAX_JITTER / this.JITTER_BUILDUP_MS;
         if(this.jitter_ > this.MAX_JITTER)
         {
            this.jitter_ = this.MAX_JITTER;
         }
      }
   }

   public function configure(x:Number, y:Number, z:Number, angleRad:Number, clipRect:Rectangle, usePP:Boolean) : void
   {
      var o:Number = NaN;
      var w:Number = NaN;
      var h:Number = NaN;
      if(this.isJittering_)
      {
         x = x + RandomUtil.plusMinus(this.jitter_);
         y = y + RandomUtil.plusMinus(this.jitter_);
      }
      this.x_ = x;
      this.y_ = y;
      this.z_ = z;
      this.angleRad_ = angleRad;
      this.clipRect_ = clipRect;
      this.p_.x = x;
      this.p_.y = y;
      this.p_.z = z;
      this.r_.x = Math.cos(this.angleRad_);
      this.r_.y = Math.sin(this.angleRad_);
      this.r_.z = 0;
      this.u_.x = Math.cos(this.angleRad_ + Math.PI / 2);
      this.u_.y = Math.sin(this.angleRad_ + Math.PI / 2);
      this.u_.z = 0;
      this.rd_[0] = this.r_.x;
      this.rd_[1] = this.u_.x;
      this.rd_[2] = this.f_.x;
      this.rd_[3] = 0;
      this.rd_[4] = this.r_.y;
      this.rd_[5] = this.u_.y;
      this.rd_[6] = this.f_.y;
      this.rd_[7] = 0;
      this.rd_[8] = this.r_.z;
      this.rd_[9] = !!usePP?Number(this.u_.z):Number(-1);
      this.rd_[10] = this.f_.z;
      this.rd_[11] = 0;
      this.rd_[12] = -this.p_.dotProduct(this.r_);
      this.rd_[13] = -this.p_.dotProduct(this.u_);
      this.rd_[14] = -this.p_.dotProduct(this.f_);
      this.rd_[15] = 1;
      this.wToV_.rawData = this.rd_;
      if(usePP)
      {
         this.vToS_ = this.ppMatrix_;
      }
      else
      {
         this.vToS_ = this.nonPPMatrix_;
      }
      this.wToS_.identity();
      this.wToS_.append(this.wToV_);
      this.wToS_.append(this.vToS_);
      if(usePP)
      {
         o = this.z_ * Math.tan(this.pp_.fieldOfView / 2 * Trig.toRadians);
         this.maxDist_ = Math.SQRT2 * o * 1.4;
      }
      else
      {
         w = this.clipRect_.width / (2 * 50);
         h = this.clipRect_.height / (2 * 50);
         this.maxDist_ = Math.sqrt(w * w + h * h) + 1;
      }
      this.maxDistSq_ = this.maxDist_ * this.maxDist_;
   }
}
}
