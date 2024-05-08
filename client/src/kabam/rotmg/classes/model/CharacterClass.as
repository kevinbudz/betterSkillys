package kabam.rotmg.classes.model
{
   import com.company.assembleegameclient.appengine.CharacterStats;
   import org.osflash.signals.Signal;
   
   public class CharacterClass
   {
       
      
      public const selected:Signal = new Signal(CharacterClass);
      
      public var id:int;
      
      public var name:String;
      
      public var description:String;
      
      public var hitSound:String;
      
      public var deathSound:String;
      
      public var bloodProb:Number;
      
      public var slotTypes:Vector.<int>;
      
      public var defaultEquipment:Vector.<int>;
      
      public var hp:CharacterClassStat;
      
      public var mp:CharacterClassStat;
      
      public var attack:CharacterClassStat;
      
      public var defense:CharacterClassStat;
      
      public var speed:CharacterClassStat;
      
      public var dexterity:CharacterClassStat;
      
      public var hpRegeneration:CharacterClassStat;
      
      public var mpRegeneration:CharacterClassStat;
      
      public var unlockCost:int;
      
      private var maxLevelAchieved:int;
      
      private var isSelected:Boolean;
      
      public const unlocks:Vector.<CharacterClassUnlock> = new Vector.<CharacterClassUnlock>(0);
      
      public const skins:CharacterSkins = new CharacterSkins();
      
      private var stats:CharacterStats;
      
      public function CharacterClass()
      {
         super();
      }
      
      public function getIsSelected() : Boolean
      {
         return this.isSelected;
      }
      
      public function setIsSelected(value:Boolean) : void
      {
         if(this.isSelected != value)
         {
            this.isSelected = value;
            this.isSelected && this.selected.dispatch(this);
         }
      }
      
      public function getMaxLevelAchieved() : int
      {
         return this.maxLevelAchieved;
      }
      
      public function setMaxLevelAchieved(maxLevel:int) : void
      {
         this.maxLevelAchieved = maxLevel;
         this.skins.updateSkins(this.maxLevelAchieved);
      }
      
      public function getStats() : CharacterStats
      {
         return this.stats;
      }
   }
}
