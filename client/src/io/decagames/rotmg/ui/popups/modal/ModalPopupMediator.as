package io.decagames.rotmg.ui.popups.modal
{
   import flash.events.Event;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ModalPopupMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ModalPopup;
      
      private var lastContentHeight:int = 0;
      
      public function ModalPopupMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         if(this.view.autoSize)
         {
            this.lastContentHeight = this.view.contentContainer.height;
            this.view.resize();
            this.view.addEventListener(Event.ENTER_FRAME,this.checkForUpdates);
         }
      }
      
      override public function destroy() : void
      {
         this.view.removeEventListener(Event.ENTER_FRAME,this.checkForUpdates);
         this.view.dispose();
      }
      
      private function checkForUpdates(param1:Event) : void
      {
         if(this.view.contentContainer.height != this.lastContentHeight)
         {
            this.lastContentHeight = this.view.contentContainer.height;
            this.view.resize();
         }
      }
   }
}
