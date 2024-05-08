package kabam.lib.net.api
{
   import kabam.lib.net.impl.MessagePool;
   
   public interface MessageMapping
   {
       
      
      function setID(param1:int) : MessageMapping;
      
      function toMessage(param1:Class) : MessageMapping;
      
      function toHandler(param1:Class) : MessageMapping;
      
      function toMethod(param1:Function) : MessageMapping;
      
      function setPopulation(param1:int) : MessageMapping;
      
      function makePool() : MessagePool;
   }
}
