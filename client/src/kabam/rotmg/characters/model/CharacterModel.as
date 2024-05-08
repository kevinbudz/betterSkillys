package kabam.rotmg.characters.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   
   public interface CharacterModel
   {
       
      
      function getCharacterCount() : int;
      
      function getCharacter(param1:int) : SavedCharacter;
      
      function deleteCharacter(param1:int) : void;
      
      function select(param1:SavedCharacter) : void;
      
      function getSelected() : SavedCharacter;
   }
}
