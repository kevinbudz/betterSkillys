package kabam.display.LoaderInfo
{
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoaderInfoProxyConcrete extends EventDispatcher implements LoaderInfoProxy
   {
       
      
      private var _loaderInfo:LoaderInfo;
      
      public function LoaderInfoProxyConcrete()
      {
         super();
      }
      
      override public function toString() : String
      {
         return this._loaderInfo.toString();
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this._loaderInfo.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this._loaderInfo.removeEventListener(type,listener,useCapture);
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         return this._loaderInfo.dispatchEvent(event);
      }
      
      override public function hasEventListener(type:String) : Boolean
      {
         return this._loaderInfo.hasEventListener(type);
      }
      
      override public function willTrigger(type:String) : Boolean
      {
         return this._loaderInfo.willTrigger(type);
      }
      
      public function set loaderInfo(value:LoaderInfo) : void
      {
         this._loaderInfo = value;
      }
   }
}
