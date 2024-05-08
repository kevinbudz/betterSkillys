package kabam.rotmg.characters.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class LegacyCharacterModel implements CharacterModel
   {
       
      
      [Inject]
      public var wrapped:PlayerModel;
      
      private var selected:SavedCharacter;
      
      public function LegacyCharacterModel()
      {
         super();
      }
      
      public function getCharacterCount() : int
      {
         return this.wrapped.getCharacterCount();
      }
      
      public function getCharacter(characterId:int) : SavedCharacter
      {
         return this.wrapped.getCharById(characterId);
      }
      
      public function deleteCharacter(characterId:int) : void
      {
         this.wrapped.deleteCharacter(characterId);
         if(this.selected.charId() == characterId)
         {
            this.selected = null;
         }
      }
      
      public function select(character:SavedCharacter) : void
      {
         this.selected = character;
      }
      
      public function getSelected() : SavedCharacter
      {
         return this.selected;
      }
   }
}
