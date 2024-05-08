package kabam.rotmg.appengine.api
{
   import org.osflash.signals.OnceSignal;
   
   public interface RetryLoader
   {
      function get complete() : OnceSignal;
      
      function setMaxRetries(param1:int) : void;
      
      function setDataFormat(param1:String) : void;
      
      function sendRequest(param1:String, param2:Object) : void;
   }
}
