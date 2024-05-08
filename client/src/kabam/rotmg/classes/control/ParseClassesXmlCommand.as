package kabam.rotmg.classes.control
{
   import kabam.rotmg.assets.model.CharacterTemplate;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterClassStat;
   import kabam.rotmg.classes.model.CharacterClassUnlock;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.classes.model.ClassesModel;
   
   public class ParseClassesXmlCommand
   {
      
      public static const CLASSIC_NAME:String = "Classic";
       
      
      [Inject]
      public var data:XML;
      
      [Inject]
      public var classes:ClassesModel;
      
      public function ParseClassesXmlCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var object:XML = null;
         var objects:XMLList = this.data.Object;
         for each(object in objects)
         {
            this.parseCharacterClass(object);
         }
      }
      
      private function parseCharacterClass(object:XML) : void
      {
         var id:int = object.@type;
         var character:CharacterClass = this.classes.getCharacterClass(id);
         this.populateCharacter(character,object);
      }
      
      private function populateCharacter(character:CharacterClass, object:XML) : void
      {
         var node:XML = null;
         character.id = object.@type;
         character.name = object.@id;
         character.description = object.Description;
         character.hitSound = object.HitSound;
         character.deathSound = object.DeathSound;
         character.bloodProb = object.BloodProb;
         character.slotTypes = this.parseIntList(object.SlotTypes);
         character.defaultEquipment = this.parseIntList(object.Equipment);
         character.hp = this.parseCharacterStat(object,"MaxHitPoints");
         character.mp = this.parseCharacterStat(object,"MaxMagicPoints");
         character.attack = this.parseCharacterStat(object,"Attack");
         character.defense = this.parseCharacterStat(object,"Defense");
         character.speed = this.parseCharacterStat(object,"Speed");
         character.dexterity = this.parseCharacterStat(object,"Dexterity");
         character.hpRegeneration = this.parseCharacterStat(object,"HpRegen");
         character.mpRegeneration = this.parseCharacterStat(object,"MpRegen");
         character.unlockCost = object.UnlockCost;
         for each(node in object.UnlockLevel)
         {
            character.unlocks.push(this.parseUnlock(node));
         }
         character.skins.addSkin(this.makeDefaultSkin(object),true);
      }
      
      private function makeDefaultSkin(object:XML) : CharacterSkin
      {
         var file:String = object.AnimatedTexture.File;
         var index:int = object.AnimatedTexture.Index;
         var skin:CharacterSkin = new CharacterSkin();
         skin.id = 0;
         skin.name = CLASSIC_NAME;
         skin.template = new CharacterTemplate(file,index);
         skin.setState(CharacterSkinState.OWNED);
         skin.setIsSelected(true);
         return skin;
      }
      
      private function parseUnlock(object:XML) : CharacterClassUnlock
      {
         var unlock:CharacterClassUnlock = new CharacterClassUnlock();
         unlock.level = object.@level;
         unlock.character = this.classes.getCharacterClass(object.@type);
         return unlock;
      }
      
      private function parseCharacterStat(xml:XML, name:String) : CharacterClassStat
      {
         var increase:XML = null;
         var node:XML = null;
         var stat:CharacterClassStat = null;
         var main:XML = xml[name][0];
         for each(node in xml.LevelIncrease)
         {
            if(node.text() == name)
            {
               increase = node;
            }
         }
         stat = new CharacterClassStat();
         stat.initial = int(main.toString());
         stat.max = main.@max;
         stat.rampMin = Boolean(increase)?int(increase.@min):int(0);
         stat.rampMax = Boolean(increase)?int(increase.@max):int(0);
         return stat;
      }
      
      private function parseIntList(slotTypes:String) : Vector.<int>
      {
         var source:Array = slotTypes.split(",");
         var count:int = source.length;
         var items:Vector.<int> = new Vector.<int>(count,true);
         for(var i:int = 0; i < count; i++)
         {
            items[i] = int(source[i]);
         }
         return items;
      }
   }
}
