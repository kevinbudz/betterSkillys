package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.VertexBuffer3D;
   
   public class VertexBuffer3DProxy
   {
       
      
      private var vertexBuffer3D:VertexBuffer3D;
      
      protected var data:Vector.<Number>;
      
      public function VertexBuffer3DProxy(vertexBuffer3D:VertexBuffer3D)
      {
         super();
         this.vertexBuffer3D = vertexBuffer3D;
      }
      
      public function uploadFromVector(data:Vector.<Number>, startVertex:int, numVertices:int) : void
      {
         this.data = data;
         this.vertexBuffer3D.uploadFromVector(data,startVertex,numVertices);
      }
      
      public function getVertexBuffer3D() : VertexBuffer3D
      {
         return this.vertexBuffer3D;
      }
      
      public function getData() : Vector.<Number>
      {
         return this.data;
      }
   }
}
