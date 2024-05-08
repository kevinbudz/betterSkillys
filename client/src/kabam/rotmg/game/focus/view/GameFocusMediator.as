package kabam.rotmg.game.focus.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.GameObject;
   import flash.utils.Dictionary;
   import kabam.rotmg.game.focus.control.SetGameFocusSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class GameFocusMediator extends Mediator
   {
       
      
      [Inject]
      public var signal:SetGameFocusSignal;
      
      [Inject]
      public var view:GameSprite;
      
      public function GameFocusMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.signal.add(this.onSetGameFocus);
      }
      
      override public function destroy() : void
      {
         this.signal.remove(this.onSetGameFocus);
      }
      
      private function onSetGameFocus(id:String = "") : void
      {
         this.view.setFocus(this.getFocusById(id));
      }
      
      private function getFocusById(id:String) : GameObject
      {
         var object:GameObject = null;
         if(id == "")
         {
            return this.view.map.player_;
         }
         var objects:Dictionary = this.view.map.goDict_;
         for each(object in objects)
         {
            if(object.name_ == id)
            {
               return object;
            }
         }
         return this.view.map.player_;
      }
   }
}
