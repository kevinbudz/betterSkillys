package kabam.lib.net.api
{
   import kabam.lib.net.impl.Message;
   
   public interface MessageProvider
   {
       
      
      function require(param1:int) : Message;
   }
}
