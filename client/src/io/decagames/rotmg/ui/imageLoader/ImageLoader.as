package io.decagames.rotmg.ui.imageLoader
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public class ImageLoader
   {
       
      
      private var _loader:Loader;
      
      private var _callBack:Function;
      
      public function ImageLoader()
      {
         super();
      }
      
      private static function onIOError(param1:IOErrorEvent) : void
      {
      }
      
      private static function onSecurityEventError(param1:SecurityErrorEvent) : void
      {
      }
      
      public function loadImage(param1:String, param2:Function) : void
      {
         var imageURL:String = param1;
         var callBack:Function = param2;
         this._callBack = callBack;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,callBack);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityEventError);
         try
         {
            this._loader.load(new URLRequest(imageURL));
            return;
         }
         catch(error:SecurityError)
         {
            return;
         }
      }
      
      public function removeLoaderListeners() : void
      {
         if(this._loader && this._loader.contentLoaderInfo)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this._callBack);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityEventError);
         }
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
   }
}
