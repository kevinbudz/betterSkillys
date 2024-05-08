package kabam.rotmg.stage3D.Object3D
{
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import kabam.rotmg.stage3D.graphic3D.TextureFactory;
   
   public class Object3DStage3D
   {
      
      public static const missingTextureBitmap:BitmapData = new BitmapData(1,1,true,2290649343);
       
      
      public var model_:Model3D_stage3d = null;
      
      private var bitmapData:BitmapData;
      
      public var modelMatrix_:Matrix3D;
      
      public var modelView_:Matrix3D;
      
      public var modelViewProjection_:Matrix3D;
      
      public var position:Vector3D;
      
      private var zRotation_:Number;
      
      private var texture_:Texture;
      
      public function Object3DStage3D(model:Model3D_stage3d)
      {
         super();
         this.model_ = model;
         this.modelMatrix_ = new Matrix3D();
         this.modelView_ = new Matrix3D();
         this.modelViewProjection_ = new Matrix3D();
      }
      
      public function setBitMapData(bitmap:BitmapData) : void
      {
         this.bitmapData = TextureFactory.GetFlippedBitmapData(bitmap);
      }
      
      public function setPosition(x:Number, y:Number, z:Number, angleDegrees:Number) : void
      {
         this.position = new Vector3D(x,-y,z);
         this.zRotation_ = angleDegrees;
      }
      
      public function dispose() : void
      {
         if(this.texture_ != null)
         {
            this.texture_.dispose();
            this.texture_ = null;
         }
         this.bitmapData = null;
         this.modelMatrix_ = null;
         this.modelView_ = null;
         this.modelViewProjection_ = null;
         this.position = null;
      }
      
      public function UpdateModelMatrix(widthOffset:Number, heightOffset:Number) : void
      {
         this.modelMatrix_.identity();
         this.modelMatrix_.appendRotation(-90,Vector3D.Z_AXIS);
         this.modelMatrix_.appendRotation(-this.zRotation_,Vector3D.Z_AXIS);
         this.modelMatrix_.appendTranslation(this.position.x,this.position.y,0);
         this.modelMatrix_.appendTranslation(widthOffset,heightOffset,0);
      }
      
      public function GetModelMatrix() : Matrix3D
      {
         return this.modelMatrix_;
      }
      
      public function draw(context:Context3D) : void
      {
         var group:OBJGroup = null;
         context.setVertexBufferAt(0,this.model_.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         context.setVertexBufferAt(1,this.model_.vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_3);
         context.setVertexBufferAt(2,this.model_.vertexBuffer,6,Context3DVertexBufferFormat.FLOAT_2);
         if(this.texture_ == null && this.bitmapData != null)
         {
            this.texture_ = context.createTexture(this.bitmapData.width,this.bitmapData.height,Context3DTextureFormat.BGRA,false);
            this.texture_.uploadFromBitmapData(this.bitmapData);
         }
         else if(this.texture_ == null)
         {
            this.bitmapData = missingTextureBitmap;
            this.texture_ = context.createTexture(this.bitmapData.width,this.bitmapData.height,Context3DTextureFormat.BGRA,false);
            this.texture_.uploadFromBitmapData(this.bitmapData);
         }
         context.setTextureAt(0,this.texture_);
         for each(group in this.model_.groups)
         {
            if(group.indexBuffer != null)
            {
               context.drawTriangles(group.indexBuffer);
            }
         }
      }
   }
}
