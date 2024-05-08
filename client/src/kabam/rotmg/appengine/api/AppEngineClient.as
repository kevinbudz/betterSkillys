package kabam.rotmg.appengine.api
{
   import org.osflash.signals.OnceSignal;
   
   public interface AppEngineClient
   {
       
      
      function get complete() : OnceSignal;
      
      function setDataFormat(param1:String) : void;
      
      function setSendEncrypted(param1:Boolean) : void;
      
      function setMaxRetries(param1:int) : void;
      
      function sendRequest(param1:String, param2:Object) : void;
   }
}
