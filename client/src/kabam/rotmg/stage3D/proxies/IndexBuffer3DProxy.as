package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.IndexBuffer3D;
   
   public class IndexBuffer3DProxy
   {
       
      
      private var indexBuffer:IndexBuffer3D;
      
      public function IndexBuffer3DProxy(indexBuffer:IndexBuffer3D)
      {
         super();
         this.indexBuffer = indexBuffer;
      }
      
      public function uploadFromVector(data:Vector.<uint>, startOffset:int, count:int) : void
      {
         this.indexBuffer.uploadFromVector(data,startOffset,count);
      }
      
      public function getIndexBuffer3D() : IndexBuffer3D
      {
         return this.indexBuffer;
      }
   }
}
