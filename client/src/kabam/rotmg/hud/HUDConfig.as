package kabam.rotmg.hud
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.framework.api.IConfig;
   
   public class HUDConfig implements IConfig
   {
       
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      public function HUDConfig()
      {
         super();
      }
      
      public function configure() : void
      {
      }
   }
}
