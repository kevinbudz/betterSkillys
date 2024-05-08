package kabam.rotmg.classes.view
{
   import kabam.rotmg.classes.control.BuyCharacterSkinSignal;
   import kabam.rotmg.classes.control.FocusCharacterSkinSignal;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CharacterSkinListItemMediator extends Mediator
   {
       
      
      [Inject]
      public var view:CharacterSkinListItem;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var buyCharacterSkin:BuyCharacterSkinSignal;
      
      [Inject]
      public var focusCharacterSkin:FocusCharacterSkinSignal;
      
      public function CharacterSkinListItemMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.buy.add(this.onBuy);
         this.view.over.add(this.onOver);
         this.view.out.add(this.onOut);
         this.view.selected.add(this.onSelected);
      }
      
      override public function destroy() : void
      {
         this.view.buy.remove(this.onBuy);
         this.view.over.remove(this.onOver);
         this.view.out.remove(this.onOut);
         this.view.selected.remove(this.onSelected);
         this.view.setModel(null);
      }
      
      private function onOver() : void
      {
         this.focusCharacterSkin.dispatch(this.view.getModel());
      }
      
      private function onOut() : void
      {
         this.focusCharacterSkin.dispatch(null);
      }
      
      private function onBuy() : void
      {
         var skin:CharacterSkin = this.view.getModel();
         this.buyCharacterSkin.dispatch(skin);
      }
      
      private function onSelected(isSelected:Boolean) : void
      {
         this.view.getModel().setIsSelected(isSelected);
      }
   }
}
