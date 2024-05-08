package kabam.display.Loader
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import kabam.display.LoaderInfo.LoaderInfoProxy;
   
   public class LoaderProxy extends Sprite
   {
       
      
      public function LoaderProxy()
      {
         super();
      }
      
      public function get content() : DisplayObject
      {
         return null;
      }
      
      public function get contentLoaderInfo() : LoaderInfoProxy
      {
         return null;
      }
      
      public function load(request:URLRequest, context:LoaderContext = null) : void
      {
      }
      
      public function unload() : void
      {
      }
   }
}
