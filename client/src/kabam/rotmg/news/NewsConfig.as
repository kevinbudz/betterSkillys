package kabam.rotmg.news
{
   import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
   import kabam.rotmg.news.model.NewsModel;
   import kabam.rotmg.news.services.GetAppEngineNewsTask;
   import kabam.rotmg.news.services.GetNewsTask;
   import kabam.rotmg.news.view.NewsCell;
   import kabam.rotmg.news.view.NewsCellMediator;
   import kabam.rotmg.news.view.NewsMediator;
   import kabam.rotmg.news.view.NewsView;
   import kabam.rotmg.startup.control.StartupSequence;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.framework.api.IConfig;
   import robotlegs.bender.framework.api.IContext;
   
   public class NewsConfig implements IConfig
   {
       
      
      [Inject]
      public var context:IContext;
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      [Inject]
      public var startupSequence:StartupSequence;
      
      public function NewsConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.injector.map(NewsDataUpdatedSignal).asSingleton();
         this.injector.map(NewsModel).asSingleton();
         this.injector.map(GetNewsTask).toType(GetAppEngineNewsTask);
         this.mediatorMap.map(NewsView).toMediator(NewsMediator);
         this.mediatorMap.map(NewsCell).toMediator(NewsCellMediator);
         this.startupSequence.addTask(GetNewsTask);
      }
   }
}
