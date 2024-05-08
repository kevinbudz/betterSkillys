package kabam.rotmg.servers
{
   import kabam.rotmg.account.core.signals.CharListDataSignal;
   import kabam.rotmg.servers.api.ServerModel;
   import kabam.rotmg.servers.control.ParseServerDataCommand;
   import kabam.rotmg.servers.model.LiveServerModel;
import kabam.rotmg.servers.signals.RefreshServerSignal;

import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.framework.api.IConfig;
   
   public class ServersConfig implements IConfig
   {
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      public function ServersConfig()
      {
         super();
      }
      
      public function configure() : void
      {
            this.configureLiveServers();
      }
      
      private function configureLiveServers() : void
      {
         this.injector.map(ServerModel).toSingleton(LiveServerModel);
         this.commandMap.map(CharListDataSignal).toCommand(ParseServerDataCommand);
         this.commandMap.map(RefreshServerSignal).toCommand(ParseServerDataCommand);
      }
   }
}
