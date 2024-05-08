package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.Context3D;
   import flash.geom.Matrix3D;
   
   public class Context3DProxy
   {
       
      
      private var context3D:Context3D;
      
      public function Context3DProxy(context3D:Context3D)
      {
         super();
         this.context3D = context3D;
      }
      
      public function GetContext3D() : Context3D
      {
         return this.context3D;
      }
      
      public function configureBackBuffer(width:int, height:int, antiAlias:int, enableDepthAndStencil:Boolean = true) : void
      {
         this.context3D.configureBackBuffer(width,height,antiAlias,enableDepthAndStencil);
      }
      
      public function createProgram() : Program3DProxy
      {
         return new Program3DProxy(this.context3D.createProgram());
      }
      
      public function clear() : void
      {
         this.context3D.clear(0.0, 0, 0, 0);
      }
      
      public function present() : void
      {
         this.context3D.present();
      }
      
      public function createIndexBuffer(numIndices:int) : IndexBuffer3DProxy
      {
         return new IndexBuffer3DProxy(this.context3D.createIndexBuffer(numIndices));
      }
      
      public function createVertexBuffer(numVertices:int, data32PerVertex:int) : VertexBuffer3DProxy
      {
         return new VertexBuffer3DProxy(this.context3D.createVertexBuffer(numVertices,data32PerVertex));
      }
      
      public function setVertexBufferAt(index:int, buffer:VertexBuffer3DProxy, bufferOffset:int, format:String = "float4") : void
      {
         this.context3D.setVertexBufferAt(index,buffer.getVertexBuffer3D(),bufferOffset,format);
      }
      
      public function setProgramConstantsFromMatrix(programType:String, firstRegister:int, matrix:Matrix3D, transposedMatrix:Boolean = false) : void
      {
         this.context3D.setProgramConstantsFromMatrix(programType,firstRegister,matrix,transposedMatrix);
      }
      
      public function setProgramConstantsFromVector(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1) : void
      {
         this.context3D.setProgramConstantsFromVector(programType,firstRegister,data,numRegisters);
      }
      
      public function createTexture(width:int, height:int, format:String, optimizeForRenderToTexture:Boolean) : TextureProxy
      {
         return new TextureProxy(this.context3D.createTexture(width,height,format,optimizeForRenderToTexture));
      }
      
      public function setTextureAt(sampler:int, texture:TextureProxy) : void
      {
         this.context3D.setTextureAt(sampler,texture.getTexture());
      }
      
      public function setProgram(program:Program3DProxy) : void
      {
         this.context3D.setProgram(program.getProgram3D());
      }
      
      public function drawTriangles(indexBuffer:IndexBuffer3DProxy) : void
      {
         this.context3D.drawTriangles(indexBuffer.getIndexBuffer3D());
      }
      
      public function setBlendFactors(sourceFactor:String, destinationFactory:String) : void
      {
         this.context3D.setBlendFactors(sourceFactor,destinationFactory);
      }
      
      public function setDepthTest(depthMask:Boolean, passCompareMode:String) : void
      {
         this.context3D.setDepthTest(depthMask,passCompareMode);
      }
   }
}
