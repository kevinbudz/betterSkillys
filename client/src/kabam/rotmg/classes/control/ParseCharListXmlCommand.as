package kabam.rotmg.classes.control
{
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.classes.model.ClassesModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ParseCharListXmlCommand
   {
       
      
      [Inject]
      public var data:XML;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var logger:ILogger;
      
      public function ParseCharListXmlCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.parseMaxLevelsAchieved();
         this.parseItemCosts();
         this.parseOwnership();
      }
      
      private function parseMaxLevelsAchieved() : void
      {
         var maxLevel:XML = null;
         var character:CharacterClass = null;
         var maxLevels:XMLList = this.data.MaxClassLevelList.MaxClassLevel;
         for each(maxLevel in maxLevels)
         {
            character = this.model.getCharacterClass(maxLevel.@classType);
            character.setMaxLevelAchieved(maxLevel.@maxLevel);
         }
      }
      
      private function parseItemCosts() : void
      {
         var cost:XML = null;
         var skin:CharacterSkin = null;
         var costs:XMLList = this.data.ItemCosts.ItemCost;
         for each(cost in costs)
         {
            skin = this.model.getCharacterSkin(cost.@type);
            if(skin)
            {
               skin.cost = int(cost);
            }
            else
            {
               this.logger.warn("Cannot set Character Skin cost: type {0} not found",[cost.@type]);
            }
         }
      }
      
      private function parseOwnership() : void
      {
         var owned:int = 0;
         var skin:CharacterSkin = null;
         var ownership:Array = Boolean(this.data.OwnedSkins.length())?this.data.OwnedSkins.split(","):[];
         for each(owned in ownership)
         {
            skin = this.model.getCharacterSkin(owned);
            if(skin)
            {
               skin.setState(CharacterSkinState.OWNED);
            }
            else
            {
               this.logger.warn("Cannot set Character Skin ownership: type {0} not found",[owned]);
            }
         }
      }
   }
}
