package kabam.rotmg.classes.view
{
import com.company.assembleegameclient.appengine.SavedCharacter;

import flash.display.DisplayObject;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;

import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CharacterSkinListMediator extends Mediator
   {
      [Inject]
      public var view:CharacterSkinListView;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var factory:CharacterSkinListItemFactory;
      
      public function CharacterSkinListMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.model.selected.add(this.setSkins);
         this.setSkins(this.model.getSelected());
      }
      
      override public function destroy() : void
      {
         this.model.selected.remove(this.setSkins);
      }
      
      private function setSkins(charClass:CharacterClass) : void
      {
         var items:Vector.<DisplayObject> = this.factory.make(charClass.skins);
         this.view.setItems(items);
      }
   }
}
