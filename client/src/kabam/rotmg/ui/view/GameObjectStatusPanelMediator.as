package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.GameObjectStatusPanel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class GameObjectStatusPanelMediator extends Mediator
   {
       
      
      [Inject]
      public var view:GameObjectStatusPanel;
      
      private var name:String;
      
      private var names:Array;
      
      public function GameObjectStatusPanelMediator()
      {
         this.names = ["Apple","Tortilla","Chainsaw","Monkey","Flotilla","Zephyr","Ghost","Tupac","Alluvial","Dante","Soprano","Godzilla","Hate","Freebird","Desire","Good","Nightie","Osprey"];
         super();
      }
      
      override public function initialize() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}
