package kabam.rotmg.classes.control
{
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.classes.model.ClassesModel;
   
   public class ResetClassDataCommand
   {
       
      
      [Inject]
      public var classes:ClassesModel;
      
      public function ResetClassDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var count:int = this.classes.getCount();
         for(var i:int = 0; i < count; i++)
         {
            this.resetClass(this.classes.getClassAtIndex(i));
         }
      }
      
      private function resetClass(charClass:CharacterClass) : void
      {
         charClass.setIsSelected(charClass.id == ClassesModel.WIZARD_ID);
         this.resetClassSkins(charClass);
      }
      
      private function resetClassSkins(charClass:CharacterClass) : void
      {
         var skin:CharacterSkin = null;
         var defaultSkin:CharacterSkin = charClass.skins.getDefaultSkin();
         var count:int = charClass.skins.getCount();
         for(var i:int = 0; i < count; i++)
         {
            skin = charClass.skins.getSkinAt(i);
            if(skin != defaultSkin)
            {
               this.resetSkin(charClass.skins.getSkinAt(i));
            }
         }
      }
      
      private function resetSkin(charSkin:CharacterSkin) : void
      {
         charSkin.setState(CharacterSkinState.LOCKED);
      }
   }
}
