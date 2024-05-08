package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.animation.Animations;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   
   public class XMLParticle extends BasicObject
   {
       
      
      public var texture_:BitmapData = null;
      
      public var animations_:Animations = null;
      
      public var size_:int;
      
      public var durationLeft_:Number;
      
      public var moveVec_:Vector3D;
      
      protected var bitmapFill_:GraphicsBitmapFill;
      
      protected var path_:GraphicsPath;
      
      protected var vS_:Vector.<Number>;
      
      protected var uvt_:Vector.<Number>;
      
      protected var fillMatrix_:Matrix;
      
      public function XMLParticle(props:ParticleProperties)
      {
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
         this.vS_ = new Vector.<Number>();
         this.uvt_ = new Vector.<Number>();
         this.fillMatrix_ = new Matrix();
         super();
         objectId_ = getNextFakeObjectId();
         this.size_ = props.size_;
         z_ = props.z_;
         this.durationLeft_ = props.duration_;
         this.texture_ = props.textureData_.getTexture(objectId_);
         if(props.animationsData_ != null)
         {
            this.animations_ = new Animations(props.animationsData_);
         }
         this.moveVec_ = new Vector3D();
         var moveAngle:Number = Math.PI * 2 * Math.random();
         this.moveVec_.x = Math.cos(moveAngle) * 0.1 * 5;
         this.moveVec_.y = Math.sin(moveAngle) * 0.1 * 5;
      }
      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         var square:Square = null;
         square = map_.getSquare(x,y);
         if(square == null)
         {
            return false;
         }
         x_ = x;
         y_ = y;
         square_ = square;
         return true;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var fdt:Number = dt / 1000;
         this.durationLeft_ = this.durationLeft_ - fdt;
         if(this.durationLeft_ <= 0)
         {
            return false;
         }
         x_ = x_ + this.moveVec_.x * fdt;
         y_ = y_ + this.moveVec_.y * fdt;
         return true;
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var animTexture:BitmapData = null;
         var texture:BitmapData = this.texture_;
         if(this.animations_ != null)
         {
            animTexture = this.animations_.getTexture(time);
            if(animTexture != null)
            {
               texture = animTexture;
            }
         }
         texture = TextureRedrawer.redraw(texture,this.size_,true,0);
         var w:int = texture.width;
         var h:int = texture.height;
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - w / 2,posS_[4] - h,posS_[3] + w / 2,posS_[4] - h,posS_[3] + w / 2,posS_[4],posS_[3] - w / 2,posS_[4]);
         this.path_.data = this.vS_;
         this.bitmapFill_.bitmapData = texture;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
   }
}
