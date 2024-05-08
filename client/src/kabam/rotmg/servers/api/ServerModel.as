package kabam.rotmg.servers.api
{
   public interface ServerModel
   {
       
      
      function setServers(param1:Vector.<Server>) : void;
      
      function getServer() : Server;
      
      function isServerAvailable() : Boolean;
      
      function getServers() : Vector.<Server>;
   }
}
