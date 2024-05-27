package kabam.rotmg.servers.model
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class FixedIPServerModel implements ServerModel
   {
       
      
      private var localhost:Server;
      
      public function FixedIPServerModel()
      {
         super();
         this.localhost = new Server().setName("localhost").setPort(Parameters.TESTING_SERVER ? Parameters.TESTING_PORT : Parameters.PORT);
      }
      
      public function setIP(ip:String) : FixedIPServerModel
      {
         this.localhost.setAddress(ip);
         return this;
      }
      
      public function getServers() : Vector.<Server>
      {
         return new <Server>[this.localhost];
      }
      
      public function getServer() : Server
      {
         return this.localhost;
      }
      
      public function isServerAvailable() : Boolean
      {
         return true;
      }
      
      public function setServers(servers:Vector.<Server>) : void
      {
      }
   }
}
