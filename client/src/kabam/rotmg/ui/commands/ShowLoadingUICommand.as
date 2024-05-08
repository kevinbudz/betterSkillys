package kabam.rotmg.ui.commands
{
   import com.company.assembleegameclient.screens.AccountLoadingScreen;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.view.BadDomainView;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ShowLoadingUICommand
   {
       
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var logger:ILogger;
      
      public function ShowLoadingUICommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.showLoadingScreen();
      }
      
      private function showLoadingScreen() : void
      {
         this.setScreen.dispatch(new AccountLoadingScreen());
      }
      
      private function openBadDomainView() : void
      {
         this.logger.debug("bad domain, deny");
         this.setScreen.dispatch(new BadDomainView());
      }
   }
}
