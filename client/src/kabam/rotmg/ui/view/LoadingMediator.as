package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.LoadingScreen;
   import kabam.rotmg.core.signals.SetLoadingMessageSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class LoadingMediator extends Mediator
   {
       
      
      [Inject]
      public var view:LoadingScreen;
      
      [Inject]
      public var setMessage:SetLoadingMessageSignal;
      
      public function LoadingMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.setMessage.add(this.onSetMessage);
         this.view.setText("<p align=\"center\">Loading...</p>");
      }
      
      override public function destroy() : void
      {
         this.setMessage.remove(this.onSetMessage);
      }
      
      private function onSetMessage(message:String) : void
      {
         this.view.setText(message);
      }
   }
}
