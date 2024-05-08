package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix3D;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Object3D
   {
       
      
      public var model_:Model3D = null;
      
      public var vL_:Vector.<Number>;
      
      public var uvts_:Vector.<Number>;
      
      public var faces_:Vector.<ObjectFace3D>;
      
      public var vS_:Vector.<Number>;
      
      public var vW_:Vector.<Number>;
      
      public var lToW_:Matrix3D;
      
      public function Object3D(model:Model3D = null)
      {
         var mf:ModelFace3D = null;
         this.faces_ = new Vector.<ObjectFace3D>();
         this.vS_ = new Vector.<Number>();
         this.vW_ = new Vector.<Number>();
         this.lToW_ = new Matrix3D();
         super();
         if(model != null)
         {
            this.model_ = model;
            this.vL_ = this.model_.vL_;
            this.uvts_ = this.model_.uvts_.concat();
            for each(mf in this.model_.faces_)
            {
               this.faces_.push(new ObjectFace3D(this,mf.indicies_,mf.useTexture_));
            }
         }
         else
         {
            this.vL_ = new Vector.<Number>();
            this.uvts_ = new Vector.<Number>();
         }
         this.setPosition(0,0,0,0);
      }
      
      public static function getObject(name:String) : Object3D
      {
         var model:Model3D = Model3D.getModel(name);
         return new Object3D(model);
      }
      
      public function dispose() : void
      {
         var face:ObjectFace3D = null;
         this.vL_ = null;
         this.uvts_ = null;
         for each(face in this.faces_)
         {
            face.dispose();
         }
         this.faces_.length = 0;
         this.faces_ = null;
         this.vS_ = null;
         this.vW_ = null;
         this.lToW_ = null;
      }
      
      public function setPosition(x:Number, y:Number, z:Number, angleDegrees:Number) : void
      {
         var face:ObjectFace3D = null;
         this.lToW_.identity();
         this.lToW_.appendRotation(angleDegrees,Vector3D.Z_AXIS);
         this.lToW_.appendTranslation(x,y,z);
         this.lToW_.transformVectors(this.vL_,this.vW_);
         for each(face in this.faces_)
         {
            face.computeLighting();
         }
      }
      
      public function getVecW(index:int) : Vector3D
      {
         var i:int = index * 3;
         if(i >= this.vW_.length)
         {
            return null;
         }
         return new Vector3D(this.vW_[i],this.vW_[i + 1],this.vW_[i + 2]);
      }
      
      public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, color:uint, bitmapData:BitmapData) : void
      {
         var face:ObjectFace3D = null;
         Utils3D.projectVectors(camera.wToS_,this.vW_,this.vS_,this.uvts_);
         for each(face in this.faces_)
         {
            face.draw(graphicsData,color,bitmapData);
         }
      }
   }
}
