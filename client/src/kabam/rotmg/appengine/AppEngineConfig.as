package kabam.rotmg.appengine
{
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.appengine.api.RetryLoader;
   import kabam.rotmg.appengine.impl.AppEngineRetryLoader;
   import kabam.rotmg.appengine.impl.SimpleAppEngineClient;
   import kabam.rotmg.application.api.ApplicationSetup;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IConfig;
   import robotlegs.bender.framework.api.IContext;
   
   public class AppEngineConfig implements IConfig
   {
      [Inject]
      public var context:IContext;
      
      [Inject]
      public var setup:ApplicationSetup;
      
      [Inject]
      public var injector:Injector;
      
      public function AppEngineConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.configureCoreDependencies();
         this.configureForSimplicity();
      }
      
      private function configureCoreDependencies() : void
      {
         this.injector.map(RetryLoader).toType(AppEngineRetryLoader);
      }

      private function configureForSimplicity() : void
      {
         this.injector.map(AppEngineClient).toType(SimpleAppEngineClient);
      }
   }
}
