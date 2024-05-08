package kabam.rotmg.servers.control
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class ParseServerDataCommand
   {
      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var data:XML;
      
      public function ParseServerDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.servers.setServers(this.makeListOfServers());
      }
      
      private function makeListOfServers() : Vector.<Server>
      {
         var xml:XML = null;
         var serverList:XMLList = this.data.child("Servers").child("Server");
         var list:Vector.<Server> = new Vector.<Server>(0);
         for each(xml in serverList)
         {
            list.push(this.makeServer(xml));
         }
         return list;
      }
      
      private function makeServer(xml:XML) : Server
      {
         return new Server().setName(xml.Name).setAddress(xml.DNS).setPort(xml.Port).setLatLong(Number(xml.Lat),Number(xml.Long)).setUsage(xml.Usage).setIsAdminOnly(xml.hasOwnProperty("AdminOnly")).setUsageText(xml.UsageText);
      }
   }
}
