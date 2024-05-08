package kabam.rotmg.stage3D.graphic3D
{
   import flash.utils.Dictionary;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import kabam.rotmg.stage3D.proxies.VertexBuffer3DProxy;
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   
   public class VertexBufferFactory implements DependencyProvider
   {
       
      
      private var vertexBuffer:VertexBuffer3DProxy;
      
      public function VertexBufferFactory(context3D:Context3DProxy)
      {
         super();
         var vertices:Vector.<Number> = Vector.<Number>([-0.5,0.5,0,0,0,0.5,0.5,0,1,0,-0.5,-0.5,0,0,1,0.5,-0.5,0,1,1]);
         this.vertexBuffer = context3D.createVertexBuffer(4,5);
         this.vertexBuffer.uploadFromVector(vertices,0,4);
      }
      
      public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary) : Object
      {
         return this.vertexBuffer;
      }
      
      public function destroy() : void
      {
      }
   }
}
