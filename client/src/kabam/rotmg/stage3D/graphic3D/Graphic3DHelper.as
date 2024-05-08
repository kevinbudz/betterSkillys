package kabam.rotmg.stage3D.graphic3D
{
   import kabam.rotmg.stage3D.proxies.IndexBuffer3DProxy;
   import kabam.rotmg.stage3D.proxies.VertexBuffer3DProxy;
   import org.swiftsuspenders.Injector;
   
   public class Graphic3DHelper
   {
       
      
      public function Graphic3DHelper()
      {
         super();
      }
      
      public static function map(injector:Injector) : void
      {
         injectSingletonIndexBuffer(injector);
         injectSingletonVertexBuffer(injector);
      }
      
      private static function injectSingletonIndexBuffer(injector:Injector) : void
      {
         var factory:IndexBufferFactory = injector.getInstance(IndexBufferFactory);
         injector.map(IndexBuffer3DProxy).toProvider(factory);
      }
      
      private static function injectSingletonVertexBuffer(injector:Injector) : void
      {
         var factory:VertexBufferFactory = injector.getInstance(VertexBufferFactory);
         injector.map(VertexBuffer3DProxy).toProvider(factory);
      }
   }
}
