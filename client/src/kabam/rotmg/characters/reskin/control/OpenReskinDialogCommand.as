package kabam.rotmg.characters.reskin.control
{
   import flash.display.DisplayObject;
   import kabam.rotmg.characters.reskin.view.ReskinCharacterView;
   import kabam.rotmg.classes.model.CharacterSkins;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.classes.view.CharacterSkinListItemFactory;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class OpenReskinDialogCommand
   {
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var factory:CharacterSkinListItemFactory;
      
      public function OpenReskinDialogCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.openDialog.dispatch(this.makeView());
      }
      
      private function makeView() : ReskinCharacterView
      {
         var view:ReskinCharacterView = new ReskinCharacterView();
         view.setList(this.makeList());
         view.x = (800 - view.width) * 0.5;
         view.y = (600 - view.viewHeight) * 0.5;
         return view;
      }
      
      private function makeList() : Vector.<DisplayObject>
      {
         var skins:CharacterSkins = this.getCharacterSkins();
         return this.factory.make(skins);
      }
      
      private function getCharacterSkins() : CharacterSkins
      {
         return this.model.getSelected().skins;
      }
   }
}
