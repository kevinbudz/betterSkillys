package kabam.rotmg.characters.reskin.view
{
   import kabam.rotmg.characters.reskin.control.OpenReskinDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ReskinPanelMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ReskinPanel;
      
      [Inject]
      public var openReskinDialog:OpenReskinDialogSignal;
      
      public function ReskinPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.reskin.add(this.onReskin);
         this.view.reskintwo.add(this.onReskin);
      }
      
      override public function destroy() : void
      {
         this.view.reskin.remove(this.onReskin);
         this.view.reskintwo.add(this.onReskin);
      }
      
      private function onReskin() : void
      {
         this.openReskinDialog.dispatch();
      }
   }
}
