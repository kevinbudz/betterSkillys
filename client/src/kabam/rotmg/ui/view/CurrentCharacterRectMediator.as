package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
   import kabam.rotmg.characters.deletion.view.ConfirmDeleteCharacterDialog;
   import kabam.rotmg.characters.model.CharacterModel;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CurrentCharacterRectMediator extends Mediator
   {
       
      
      [Inject]
      public var view:CurrentCharacterRect;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var model:CharacterModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function CurrentCharacterRectMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.selected.add(this.onSelected);
         this.view.deleteCharacter.add(this.onDeleteCharacter);
      }
      
      override public function destroy() : void
      {
         this.view.selected.remove(this.onSelected);
         this.view.deleteCharacter.remove(this.onDeleteCharacter);
      }
      
      private function onSelected(character:SavedCharacter) : void
      {
         var characterClass:CharacterClass = this.classesModel.getCharacterClass(character.objectType());
         characterClass.setIsSelected(true);
         characterClass.skins.getSkin(character.skinType()).setIsSelected(true);
         this.launchGame(character);
      }
      
      private function launchGame(character:SavedCharacter) : void
      {
         var data:GameInitData = new GameInitData();
         data.createCharacter = false;
         data.charId = character.charId();
         data.isNewGame = true;
         this.playGame.dispatch(data);
      }
      
      private function onDeleteCharacter(character:SavedCharacter) : void
      {
         this.model.select(character);
         this.openDialog.dispatch(new ConfirmDeleteCharacterDialog());
      }
   }
}
