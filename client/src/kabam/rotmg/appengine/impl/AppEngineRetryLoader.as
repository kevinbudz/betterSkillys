package kabam.rotmg.appengine.impl
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import kabam.rotmg.appengine.api.RetryLoader;
   import org.osflash.signals.OnceSignal;
   
   public class AppEngineRetryLoader implements RetryLoader
   {
       
      
      private const _complete:OnceSignal = new OnceSignal(Boolean);
      
      private var maxRetries:int;
      
      private var dataFormat:String;
      
      private var url:String;
      
      private var params:Object;
      
      private var urlRequest:URLRequest;
      
      private var urlLoader:URLLoader;
      
      private var retriesLeft:int;
      
      public function AppEngineRetryLoader()
      {
         super();
         this.maxRetries = 0;
         this.dataFormat = URLLoaderDataFormat.TEXT;
      }
      
      public function get complete() : OnceSignal
      {
         return this._complete;
      }
      
      public function setDataFormat(dataFormat:String) : void
      {
         this.dataFormat = dataFormat;
      }
      
      public function setMaxRetries(maxRetries:int) : void
      {
         this.maxRetries = maxRetries;
      }
      
      public function sendRequest(url:String, params:Object) : void
      {
         this.url = url;
         this.params = params;
         this.retriesLeft = this.maxRetries;
         this.internalSendRequest();
      }
      
      private function internalSendRequest() : void
      {
         this.cancelPendingRequest();
         this.urlRequest = this.makeUrlRequest();
         this.urlLoader = this.makeUrlLoader();
         this.urlLoader.load(this.urlRequest);
      }
      
      private function makeUrlRequest() : URLRequest
      {
         var urlRequest:URLRequest = new URLRequest(this.url);
         urlRequest.method = URLRequestMethod.POST;
         urlRequest.data = this.makeUrlVariables();
         return urlRequest;
      }
      
      private function makeUrlVariables() : URLVariables
      {
         var key:* = null;
         var vars:URLVariables = new URLVariables();
         vars.ignore = getTimer();
         for(key in this.params)
         {
            vars[key] = this.params[key];
         }
         return vars;
      }
      
      private function makeUrlLoader() : URLLoader
      {
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.dataFormat = this.dataFormat;
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         urlLoader.addEventListener(Event.COMPLETE,this.onComplete);
         return urlLoader;
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         var text:String = this.urlLoader.data;
         if(text.length == 0)
         {
            text = "Unable to contact server";
         }
         this.retryOrReportError(text);
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         this.cleanUpAndComplete(false,"Security Error");
      }
      
      private function retryOrReportError(error:String) : void
      {
         if(this.retriesLeft-- > 0)
         {
            this.internalSendRequest();
         }
         else
         {
            this.cleanUpAndComplete(false,error);
         }
      }
      
      private function onComplete(event:Event) : void
      {
         if(this.dataFormat == URLLoaderDataFormat.TEXT)
         {
            this.handleTextResponse(this.urlLoader.data);
         }
         else
         {
            this.cleanUpAndComplete(true,ByteArray(this.urlLoader.data));
         }
      }
      
      private function handleTextResponse(response:String) : void
      {
         if(response.substring(0,7) == "<Error>")
         {
            this.retryOrReportError(response);
         }
         else if(response.substring(0,12) == "<FatalError>")
         {
            this.cleanUpAndComplete(false,response);
         }
         else
         {
            this.cleanUpAndComplete(true,response);
         }
      }
      
      private function cleanUpAndComplete(isOK:Boolean, data:*) : void
      {
         if(!isOK && data is String)
         {
            data = this.parseXML(data);
         }
         this.cancelPendingRequest();
         this._complete.dispatch(isOK,data);
      }
      
      private function parseXML(data:String) : String
      {
         var match:Array = data.match("<.*>(.*)</.*>");
         return match && match.length > 1?match[1]:data;
      }
      
      private function cancelPendingRequest() : void
      {
         if(this.urlLoader)
         {
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.closeLoader();
            this.urlLoader = null;
         }
      }
      
      private function closeLoader() : void
      {
         try
         {
            this.urlLoader.close();
         }
         catch(e:Error)
         {
         }
      }
   }
}
