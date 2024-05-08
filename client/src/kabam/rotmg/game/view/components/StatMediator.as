package kabam.rotmg.game.view.components
{
   import flash.events.MouseEvent;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class StatMediator extends Mediator
   {
       
      
      [Inject]
      public var view:StatView;
      
      public function StatMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.mouseOut.add(this.onMouseOut);
         this.view.mouseOver.add(this.onMouseOver);
      }
      
      override public function destroy() : void
      {
         this.view.mouseOut.remove(this.onMouseOut);
         this.view.mouseOver.remove(this.onMouseOver);
         this.view.removeTooltip();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.view.addTooltip();
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.view.removeTooltip();
      }
   }
}
