package kabam.rotmg.stage3D.graphic3D
{
   import flash.utils.Dictionary;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import kabam.rotmg.stage3D.proxies.IndexBuffer3DProxy;
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   
   public class IndexBufferFactory implements DependencyProvider
   {
      
      private static const numVertices:int = 6;
       
      
      private var indexBuffer:IndexBuffer3DProxy;
      
      public function IndexBufferFactory(context3D:Context3DProxy)
      {
         super();
         var indices:Vector.<uint> = Vector.<uint>([0,1,2,2,1,3]);
         if(context3D != null)
         {
            this.indexBuffer = context3D.createIndexBuffer(numVertices);
            this.indexBuffer.uploadFromVector(indices,0,numVertices);
         }
      }
      
      public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary) : Object
      {
         return this.indexBuffer;
      }
      
      public function destroy() : void
      {
      }
   }
}
