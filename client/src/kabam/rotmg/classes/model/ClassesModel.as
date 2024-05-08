package kabam.rotmg.classes.model
{
   import org.osflash.signals.Signal;
   
   public class ClassesModel
   {
      public static const WIZARD_ID:int = 782;

      public const selected:Signal = new Signal(CharacterClass);
      private const map:Object = {};
      private const classes:Vector.<CharacterClass> = new Vector.<CharacterClass>(0);
      
      private var count:uint = 0;
      private var selectedChar:CharacterClass;
      
      public function ClassesModel()
      {
         super();
      }
      
      public function getCount() : uint
      {
         return this.count;
      }
      
      public function getClassAtIndex(index:int) : CharacterClass
      {
         return this.classes[index];
      }
      
      public function getCharacterClass(id:int) : CharacterClass
      {
         return this.map[id] = this.map[id] || this.makeCharacterClass();
      }
      
      private function makeCharacterClass() : CharacterClass
      {
         var character:CharacterClass = new CharacterClass();
         character.selected.add(this.onClassSelected);
         this.count = this.classes.push(character);
         return character;
      }
      
      private function onClassSelected(charClass:CharacterClass) : void
      {
         if(this.selectedChar != charClass)
         {
            this.selectedChar && this.selectedChar.setIsSelected(false);
            this.selectedChar = charClass;
            this.selected.dispatch(charClass);
         }
      }
      
      public function getSelected() : CharacterClass
      {
         return this.selectedChar || this.getCharacterClass(WIZARD_ID);
      }
      
      public function getCharacterSkin(type:int) : CharacterSkin
      {
         var skin:CharacterSkin;
         var character:CharacterClass;
         for each(character in this.classes)
         {
            skin = character.skins.getSkin(type);
            if(skin != character.skins.getDefaultSkin())
            {
               break;
            }
         }
         return skin;
      }
   }
}
