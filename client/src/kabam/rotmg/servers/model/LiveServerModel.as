package kabam.rotmg.servers.model
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.servers.api.LatLong;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class LiveServerModel implements ServerModel
   {
       
      
      [Inject]
      public var model:PlayerModel;
      
      private const servers:Vector.<Server> = new Vector.<Server>(0);
      
      public function LiveServerModel()
      {
         super();
      }
      
      public function setServers(list:Vector.<Server>) : void
      {
         var server:Server = null;
         this.servers.length = 0;
         for each(server in list)
         {
            this.servers.push(server);
         }
      }
      
      public function getServers() : Vector.<Server>
      {
         return this.servers;
      }
      
      public function getServer() : Server
      {
         var server:Server = null;
         var priority:int = 0;
         var dist:Number = NaN;
         var isAdmin:Boolean = this.model.isAdmin();
         var myLocation:LatLong = this.model.getMyPos();
         var closestServer:Server = null;
         var minDist:Number = Number.MAX_VALUE;
         var bestPriority:int = int.MAX_VALUE;
         for each(server in this.servers)
         {
            if(!(server.isFull() && !isAdmin))
            {
               if(server.name == Parameters.data_.preferredServer)
               {
                  return server;
               }
               priority = server.priority();
               dist = LatLong.distance(myLocation,server.latLong);
               if(priority < bestPriority || priority == bestPriority && dist < minDist)
               {
                  closestServer = server;
                  minDist = dist;
                  bestPriority = priority;
               }
            }
         }
         return closestServer;
      }
      
      public function isServerAvailable() : Boolean
      {
         return this.servers.length > 0;
      }
   }
}
