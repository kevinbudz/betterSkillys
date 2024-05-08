package kabam.display.LoaderInfo
{
   import flash.display.LoaderInfo;
   import flash.events.IEventDispatcher;
   
   public interface LoaderInfoProxy extends IEventDispatcher
   {
       
      
      function set loaderInfo(param1:LoaderInfo) : void;
   }
}
