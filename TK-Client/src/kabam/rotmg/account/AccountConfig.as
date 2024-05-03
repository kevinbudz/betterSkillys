package kabam.rotmg.account
{
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import kabam.rotmg.account.core.BuyCharacterSlotCommand;
import kabam.rotmg.account.core.control.IsAccountRegisteredGuard;
   import kabam.rotmg.account.core.model.OfferModel;
import kabam.rotmg.account.core.services.GetCharListTask;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.WebAccountConfig;
import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.ui.signals.BuyCharacterSlotSignal;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.framework.api.IConfig;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogger;
   
   public class AccountConfig implements IConfig
   {
       
      
      [Inject]
      public var root:DisplayObjectContainer;
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      [Inject]
      public var context:IContext;
      
      [Inject]
      public var info:LoaderInfo;
      
      [Inject]
      public var logger:ILogger;
      
      public function AccountConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.configureCommonFunctionality();
         this.configureAccountSpecificFunctionality();
      }
      
      private function configureCommonFunctionality() : void
      {
         this.injector.map(TaskErrorSignal).asSingleton();
         this.injector.map(UpdateAccountInfoSignal).asSingleton();
         this.injector.map(GetCharListTask);
//         this.injector.map(GetServerXmlsTask);
         this.injector.map(OfferModel).asSingleton();
         this.commandMap.map(BuyCharacterSlotSignal).toCommand(BuyCharacterSlotCommand).withGuards(IsAccountRegisteredGuard)
      }
      
      private function configureAccountSpecificFunctionality() : void
      {
         this.context.configure(WebAccountConfig);
      }
   }
}
