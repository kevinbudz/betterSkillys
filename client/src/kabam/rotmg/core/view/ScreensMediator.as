package kabam.rotmg.core.view
{
   import flash.display.Sprite;
   import kabam.rotmg.core.model.ScreenModel;
   import kabam.rotmg.core.signals.GotoPreviousScreenSignal;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ScreensMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ScreensView;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var model:ScreenModel;
      
      [Inject]
      public var gotoPrevious:GotoPreviousScreenSignal;
      
      public function ScreensMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.setScreen.add(this.onSetScreen);
         this.gotoPrevious.add(this.onGotoPrevious);
      }
      
      override public function destroy() : void
      {
         this.setScreen.remove(this.onSetScreen);
         this.gotoPrevious.add(this.onGotoPrevious);
      }
      
      private function onSetScreen(screen:Sprite) : void
      {
         this.model.currentType = Object(screen).constructor as Class;
         this.view.setScreen(screen);
      }
      
      private function onGotoPrevious() : void
      {
         this.view.setScreen(this.view.getPrevious());
      }
   }
}
