package io.decagames.rotmg.ui.tabs
{
   import flash.events.Event;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class UITabMediator extends Mediator
   {
       
      
      [Inject]
      public var view:UITab;
      
      public function UITabMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         if(this.view.transparentBackgroundFix)
         {
            this.view.addEventListener(Event.ENTER_FRAME,this.checkSize);
         }
      }
      
      private function checkSize(param1:Event) : void
      {
         if(this.view.content)
         {
            this.view.drawTransparentBackground();
         }
      }
      
      override public function destroy() : void
      {
         if(this.view.transparentBackgroundFix)
         {
            this.view.removeEventListener(Event.ENTER_FRAME,this.checkSize);
         }
      }
   }
}
